<#
.SYNOPSIS
    ⭐ Kurulum sonrası sağlık kontrolü ("hazırla" komutunun son adımı).
.DESCRIPTION
    Bu script VAULT'U DEĞİŞTİRMEZ — yalnız okur ve raporlar.
    Kırmızı satır varsa vault eksik demektir; düzeltilmesi gerekir.
.EXAMPLE
    pwsh -NoProfile -File tools\vault-baslangic-dogrula.ps1
#>
[CmdletBinding()]
param(
  [string]$Vault,
  [string[]]$KisiAdi
)

$ErrorActionPreference = 'Stop'
if (-not $Vault) { $Vault = Split-Path -Parent (Split-Path -Parent $PSCommandPath) }
$utf8 = New-Object System.Text.UTF8Encoding($false)

$hata = 0; $uyari = 0; $tamam = 0

function Basari($m) { $script:tamam++; Write-Host "TAMAM  $m" -ForegroundColor Green }
function UyariF($m) { $script:uyari++; Write-Host "UYARI  $m" -ForegroundColor Yellow }
function HataF($m) { $script:hata++;  Write-Host "HATA   $m" -ForegroundColor Red }

Write-Host "`n=== VAULT BASLANGIC DOGRULAMA ===" -ForegroundColor Cyan
Write-Host "Vault: $Vault`n"

# --- 1) Zorunlu dosyalar -------------------------------------------------
Write-Host "--- 1) Zorunlu dosyalar ---"
$zorunlu = @(
  'CLAUDE.md','AGENTS.md','HAZIRLA.md','MANUEL.md','README.md','NASIL_KULLANILIR.md','ACIK_ISLER.md',
  'index.md','network.md','log.md','ingest-manifest.md','lint-report.md',
  'DEV_BRIEF.md','RAW_ISLEM_PROMPT.md',
  'REPO_ROOT_AGENTS_STUB.md',
  'CODING_AGENT_PROMPT.md','LIBRARIAN_AGENT_PROMPT.md',
  '.gitignore','.vaultignore'
)
foreach ($f in $zorunlu) {
  if (Test-Path -LiteralPath (Join-Path $Vault $f)) { Basari "$f" }
  else { HataF "$f EKSIK" }
}

# --- 2) AGENTS.md == CLAUDE.md -------------------------------------------
Write-Host "`n--- 2) AGENTS.md / CLAUDE.md senkron ---"
$c = Join-Path $Vault 'CLAUDE.md'; $a = Join-Path $Vault 'AGENTS.md'
if ((Test-Path $c) -and (Test-Path $a)) {
  $hc = (Get-FileHash $c -Algorithm SHA256).Hash
  $ha = (Get-FileHash $a -Algorithm SHA256).Hash
  if ($hc -eq $ha) { Basari "birebir ayni (birebir kopya bekleniyor)" }
  else { HataF "FARKLI — AGENTS.md, CLAUDE.md'nin birebir kopyasi olmali" }
}

# --- 3) Klasör iskeleti --------------------------------------------------
Write-Host "`n--- 3) Klasor iskeleti ---"
$klasorler = @('raw','raw\projects','raw\chats','raw\chats\_SABLON','raw\knowhow','raw\inbox',
  'raw\articles','raw\transcripts','raw\agent-output',
  'sources','entities','concepts','global','global\decisions',
  'staging','archive','_SABLON','tools','profile',
  'projects\_STANDARTLAR','projects\_STANDARTLAR\decisions',
  'projects\_TEMPLATE_PROJECT')
foreach ($k in $klasorler) {
  if (Test-Path -LiteralPath (Join-Path $Vault $k)) { Basari "$k" }
  else { HataF "$k EKSIK" }
}

# --- 4) profile/ doluluğu ------------------------------------------------
Write-Host "`n--- 4) profile/ dolulugu (bilgi, hata degil) ---"
foreach ($p in @('user.md','preferences.md','reactions.md','patterns.md')) {
  $y = Join-Path $Vault "profile\$p"
  if (-not (Test-Path $y)) { HataF "profile\$p EKSIK"; continue }
  $t = Get-Content -LiteralPath $y -Raw -Encoding UTF8
  if ($t -match 'BOŞ ŞABLON') { UyariF "profile\$p henuz BOS — 'hazırla' ADIM 3 tamamlanmamis" }
  else { Basari "profile\$p doldurulmus" }
}

# --- 5) ⭐ Placeholder kontrolü ------------------------------------------
Write-Host "`n--- 5) Placeholder (<VAULT_YOLU>) ---"
$ph = Get-ChildItem -LiteralPath $Vault -Recurse -File -Include *.md,*.ps1,*.json -ErrorAction SilentlyContinue |
      Where-Object { $_.FullName -notmatch '\\raw\\' } |
      Select-String -Pattern '<VAULT_YOLU>' -List -ErrorAction SilentlyContinue
if ($ph) {
  foreach ($h in $ph) { UyariF "placeholder kaldi: $($h.Path.Replace($Vault,''))" }
} else { Basari "placeholder yok — yol degistirilmis" }

# --- 6) ⭐ Kisisel veri sizintisi ----------------------------------------
# ⭐ Bunlar REGEX olarak yazilir. Sebep: anayasa dosyalari bu kaliplarin
#    KENDINI "aranacak kalip" olarak yazar (orn. `AKIA[0-9A-Z]{16}`).
#    Duz metin arama, kalibin kendisini bulgulu sanirdi -> FALSE POSITIVE.
#
# ⭐⭐ Kisi adi BURAYA YAZILMAZ. Sifir bir kisi adyla baslamalidir.
#    Kendi adini yazmak, sifirlamayi degil, sizmayi kalicilastirir.
#    Kendi adini denetlemek istiyorsan parametreyle ver:
#      -KisiAdi "Ahmet Yilmaz"
Write-Host "`n--- 6) Kisisel veri sizintisi denetimi ---"
$iz = [ordered]@{
  'kisisel e-posta'   = '[A-Za-z0-9._%+-]+@(gmail|hotmail|outlook|yahoo)\.[a-z]{2,}'
  'parola'            = 'password\s*[:=]\s*["''][^"'']{4,}'
  'api anahtari'      = '\b[0-9a-fA-F]{32,}\b'
  'aws anahtari'      = 'AKIA[0-9A-Z]{16}'
  'private key'       = 'BEGIN [A-Z ]*PRIVATE KEY'
  'jdbc'              = 'jdbc:[a-z]+://'
  'tc kimlik'         = '\b\d{11}\b'
  'iban'              = '\bTR\d{2}[0-9 ]{20,28}\b'
  'WINDOWS KULLANICI YOLU' = 'C:\\Users\\[^\\\s"'']+'
}
# parametreyle gelen ek adlar
if ($KisiAdi) { foreach ($n in $KisiAdi) { $iz["kisi adi: $n"] = [regex]::Escape($n) } }

$leak = @()
Get-ChildItem -LiteralPath $Vault -Recurse -File -Include *.md -ErrorAction SilentlyContinue |
  Where-Object { $_.FullName -notmatch '\\raw\\' } |
  ForEach-Object {
    $f = $_
    $t = Get-Content -LiteralPath $f.FullName -Raw -Encoding UTF8 -ErrorAction SilentlyContinue
    if (-not $t) { return }
    foreach ($k in $iz.Keys) {
      if ($t -match $iz[$k]) { $leak += "$($f.Name): $k" }
    }
  }
if ($leak) { foreach ($l in ($leak | Sort-Object -Unique)) { HataF "SIZINTI $l" } }
else { Basari "kisisel veri kalibi bulunamadi" }

# --- 7) Araçlar ----------------------------------------------------------
Write-Host "`n--- 7) Araclar ---"
foreach ($s in @('proje-init.ps1','proje-init-dogrula.ps1','raw-dogrula.ps1',
                 'vaultignore-dogrula.ps1','secret-vault')) {
  $y = Join-Path $Vault "tools\$s"
  if (Test-Path -LiteralPath $y) { Basari "tools\$s" } else { HataF "tools\$s EKSIK" }
}

# --- 8) Git --------------------------------------------------------------
Write-Host "`n--- 8) Git ---"
if (Test-Path -LiteralPath (Join-Path $Vault '.git')) { Basari "git repo kurulu" }
else { UyariF "git repo yok — 'git init' onerilir (versiyon tarihi bedava)" }

# --- 9) .vaultignore boş mu? --------------------------------------------
Write-Host "`n--- 9) .vaultignore ---"
$vi = Get-Content -LiteralPath (Join-Path $Vault '.vaultignore') -Encoding UTF8 |
      Where-Object { $_ -notmatch '^\s*#' -and $_.Trim() -ne '' }
if ($vi) { Basari "$($vi.Count) kural tanimli" }
else { UyariF "kural yok — tum raw/ taranacak (bu normal)" }

# --- Ozet ---------------------------------------------------------------
Write-Host "`n" -NoNewline
Write-Host ("-" * 60)
Write-Host "TAMAM: $tamam   UYARI: $uyari   HATA: $hata" -ForegroundColor Cyan
if ($hata -eq 0 -and $uyari -eq 0) { Write-Host "Vault HAZIR." -ForegroundColor Green }
elseif ($hata -eq 0) { Write-Host "Vault calisiyor — uyarilari gozden gecir." -ForegroundColor Yellow }
else { Write-Host "Eksik var — yukaridaki HATA satirlarini duzelt." -ForegroundColor Red }
Write-Host "`nBu script HICBIR SEY YAZMADI.`n"