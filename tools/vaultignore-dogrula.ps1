<#
  vaultignore-dogrula.ps1 — .vaultignore kurallarını doğrular ve uygular

  ⭐ Ne yapar:
     1) Her kuralın **gerekçesi** var mı? (yoksa ⛔ — çünkü `.vaultignore`
        bir kör nokta yaratır ve gerekçesiz kural gizlemedir)
     2) Kaç dosya bu kurallara takılıyor? (sayı — çünkü `raw/` immutable,
        yok sayılan yine de **parmak izinde** görünmeli)
     3) ⭐ **YANLIŞLIKLA** ignore edilmiş bir şey var mı? (yani bir içerik
        klasörü — örn. `raw/chats/` — listede mi? olmamalı)

  ⭐ Semantik farkı hatırla:
     .gitignore   → commit edilmesin mi?
     .vaultignore → hiç açılıp okunmasın mı?
#>
[CmdletBinding()]
param([switch]$Sessiz)

$ErrorActionPreference = 'Stop'
$vault = Split-Path -Parent (Split-Path -Parent $PSCommandPath)
$vi    = Join-Path $vault '.vaultignore'
$rawDir = Join-Path $vault 'raw'
$ok=0; $hata=0

function C { param($m) if(-not $Sessiz){ Write-Host $m } }
function G { param($m) C "  [OK] $m"; $script:ok++ }
function X { param($m) C "  [X] $m"; $script:hata++ }

C ""
C "=== VAULTIGNORE DOGRULAMA ===" -ForegroundColor Cyan

if (-not (Test-Path -LiteralPath $vi)) { X ".vaultignore yok"; exit 1 }

# ── 1) Gerekçe kontrolü ───────────────────────────────────────
C ""
C "1) GEREKCE ZORUNLULUGU"
$kurallar = @()
foreach ($line in Get-Content -LiteralPath $vi -Encoding UTF8) {
  $s = $line.Trim()
  if (-not $s -or $s.StartsWith('#')) { continue }
  # ⚠️ Gerekçe **zorunlu** ve **biçimli**: `# gerekçe:` öneki olmadan
  #    kural kabul edilmez. Aksi halde bu dosya "ilgimi çekmiyor" gibi
  #    keyfî gerekçelerle bir kör noktaya dönüşür.
  $gerekce = $null
  if ($s -match '^(?<p>\S+)\s*#\s*gerekçe:\s*(?<g>.+)$') {
    $gerekce = $Matches.g.Trim()
    $kurallar += @{ Pattern = $Matches.p; Gerekce = $gerekce }
  } else {
    $kurallar += @{ Pattern = ($s -split '\s+#')[0]; Gerekce = $null }
  }
}
if ($kurallar.Count -eq 0) { X "kural bulunamadi"; }
foreach ($k in $kurallar) {
  if ($k.Gerekce -and $k.Gerekce.Length -ge 15) {
    G "$($k.Pattern)"
  } else {
    X "$($k.Pattern)  -> gerekce eksik/celo kisa. `.vaultignore` bir kor nokta yaratir; her kuralin gerekcesi ZORUNLUDUR."
  }
}

# ── 2) Yanlışlıkla ignore edilmiş içerik klasörü ───────────────
C ""
C "2) ASLA IGNORE EDILMEMESI GEREKENLER"
$yasak = @(
  @{ p='raw/chats/';          n='sohbet tepkileri — ikinci beyinin olcum birimi' }
  @{ p='raw/knowhow/Keep/';   n='15 know-how sayfasi buradan cikti' }
  @{ p='raw/knowledge-base/'; n='KB terfi dongusu bu snapshotlardan besleniyor' }
  @{ p='raw/projects/';       n='proje belgeleri' }
)
$yasakBulundu = $false
foreach ($y in $yasak) {
  $hit = $kurallar | Where-Object { $_.Pattern -like "*$($y.p)*" }
  if ($hit) { X "$($y.p) listede! -> $($y.n)"; $yasakBulundu = $true }
}
if (-not $yasakBulundu) { G "yasakli hicbir icerik klasoru ignore edilmemis" }

# ── 3) Kural sayısı ve kapsam ─────────────────────────────────
C ""
C "3) KAPSAM OLCUMU"
if (-not (Test-Path -LiteralPath $rawDir)) { X "raw/ yok"; exit 1 }
$all = @(Get-ChildItem $rawDir -Recurse -File -Force)
$hit = @()
$others = @()
foreach ($f in $all) {
  $rel = $f.FullName.Substring($rawDir.Length + 1) -replace '\\','/'
  foreach ($k in $kurallar) {
    # ⚠️ SIRA KRISTIK. Tek yanlis sira kurali sessizce HICBIR seyi
    # yakalamaz (2026-10-01'de boyle oldu: 73 yerine 54 dosya).
    #   1) bastaki `**/`  -> <GD>   (yoksa `raw/.git/...` yakalanmaz)
    #   2) `**`           -> <C>
    #   3) `*`            -> <J>
    #   4) `?`            -> <Q>
    #   5) kalan `.`      -> <D>   (. kaçışı, yer tutucu ACILMADAN)
    #   6-9) yer tutucular acilir  -> regex
    $rx = $k.Pattern
    $rx = $rx -replace '^\*\*/','<GD>'
    $rx = $rx -replace '\*\*','<C>'
    $rx = $rx -replace '\*','<J>'
    $rx = $rx -replace '\?','<Q>'
    $rx = $rx -replace '\.','<D>'
    $rx = $rx -replace '<GD>','(?:.*/)?'
    $rx = $rx -replace '<C>','.*'
    $rx = $rx -replace '<J>','[^/]*'
    $rx = $rx -replace '<Q>','.'
    $rx = $rx -replace '<D>','\.'
    $rx = '^' + $rx + '$'

    if ($rel -match $rx) { $hit += $rel; break }
    # dizin deseni: joker İÇERMEYEN, `/` ile biten desen -> altındaki her şey
    $dir = ($k.Pattern -replace '<\w+>','X').TrimEnd('/')
    if ($k.Pattern -notmatch '<\w+>' -and $rel -like "$dir/*") { $hit += $rel; break }
  }
}
$hit = $hit | Sort-Object -Unique
$other = @($all | ForEach-Object { $_.FullName.Substring($rawDir.Length+1) -replace '\\','/' } |
           Where-Object { $hit -notcontains $_ })

C "  kural sayisi        : $($kurallar.Count)"
C "  [OK] ignore edilen  : $($hit.Count)  (parmak izinde GORUNUR, acilmaz)"
C "  islenebilir         : $($other.Count)"
if ($hit.Count -gt 0) {
  C ""
  C "  ignore edilen dosyalar (kurala gore):"
  $hit | Group-Object { ($_ -split '/')[0] } | Sort-Object Count -Descending |
    ForEach-Object { C ("    {0,4}  raw\{1}\" -f $_.Count, $_.Name) }
}

C ""
C "==========================================================="
C "  [OK] $ok   [X] $hata"
if ($hata -eq 0) { C "  [OK] .vaultignore butunluklu."; exit 0 }
else { C "  [X] yukaridaki kurallari duzelt."; exit 1 }
