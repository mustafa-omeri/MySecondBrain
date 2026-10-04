<#
  proje-init.ps1 — ⭐ Yeni projeyi second brain'a bağlar (TEK KOMUT)

  ⭐ NEDEN VAR: iki ayrı komut + elle doğrulama gerekiyordu. Bu script
  hepsini tek yerde yapar ve TEK yerde doğrular.

  ⭐ ⛔ KOD AJANI YOK: dosyaları bu script yazar, ajan değil. Bu yüzden
  çıktı deterministik — ajan modeli değişse de aynı sonuç.

  ⭐ KURAL BOZULMAZ: "kod ajanı vault'a yazmaz" geçerlidir; yazan ajan
  değil, bu script'tir.

  KULLANIM:
    pwsh -NoProfile -File tools\proje-init.ps1 -Repo "C:\devtools\ws\yeni"

    # etkilesimsiz (CI / tekrarlı):
    pwsh -NoProfile -File tools\proje-init.ps1 -Repo "..." -Stack 2 `
         -Kararlar "frontend-stack-react-vite,kod-ajani-vaulta-yazmaz"

    # sadece dogrula, hicbir sey yazma:
    pwsh -NoProfile -File tools\proje-init.ps1 -Repo "..." -SadeceDogrula

  ⭐ IDEMPOTENT: ikinci calistirmada hicbir sey uzerine yazilmaz.
#>
[CmdletBinding()]
param(
  [Parameter(Mandatory = $true)][string]$Repo,
  [int]$Stack,
  [string]$StackAdi,
  [string]$Kararlar,
  [switch]$OnayGec,
  [switch]$SadeceDogrula
)

$ErrorActionPreference = 'Stop'
$vault = Split-Path -Parent (Split-Path -Parent $PSCommandPath)
# ⭐ Slug üretimi: camelCase — repo klasörü adı neyse slug odur.
#   Kebab-case DEĞİL (karar: projects/_STANDARTLAR/decisions/
#   proje-isimlendirmesi-camelcase). Kebab-case yalnız WIKI SAYFALARI
#   (kaynak/kavram/karar .md dosyaları) içindir.
#   2026-10-01'de kebab-case üretiliyordu ve vault'ta iki isim yaşadı:
#     repo `SecondBrainVaultMCP` -> slug `second-brain-vault-mcp`
#   camelCase ile ikisi aynı olur: `secondBrainVaultMCP`.
function ConvertTo-Slug {
  param([string]$Ad)
  $s = $Ad.Trim()
  if ($s -match '[^A-Za-z0-9]+') {
    Write-Host "  [!] klasor adi tirnak/boşluk iceriyor: '$Ad'" -ForegroundColor Yellow
  }
  # Tirnak, bosluk ve tireleri kaldir: 'My Cool App' -> 'MyCoolApp'
  $s = $s -replace '[^A-Za-z0-9]+',''
  if (-not $s) { Write-Host "  [X] klasor adindan slug uretilemiyor: '$Ad'" -ForegroundColor Red; exit 1 }
  # ilk harfi kucult
  $s = $s.Substring(0,1).ToLower() + $s.Substring(1)
  $s
}
# ⭐ Slug = repo klasörü adının camelCase hali. KEBAB-CASE DEĞİL.
#   Kullanıcı kararı 2026-10-01 → proje-isimlendirmesi-camelcase
#   Gerekçe: slug repo adından farklı görününce vault'ta iki isim
#   yaşar ve ajan hangisini arayacağını bilmez.
#   (Bir sonraki slug'ın kebab-case olduğu görüldü:
#    `SecondBrainVaultMCP` -> `second-brain-vault-mcp`.)
$slug  = ConvertTo-Slug (Split-Path -Leaf $Repo)
$tarih = Get-Date -Format 'yyyy-MM-dd'
$utf8  = New-Object System.Text.UTF8Encoding $false

function Yaz   { param($m) Write-Host "  $m" -ForegroundColor Gray }
function Tamam { param($m) Write-Host "  [OK] $m" -ForegroundColor Green }
function Uyari { param($m) Write-Host "  [!] $m" -ForegroundColor Yellow }
function Hata  { param($m) Write-Host "  [X] $m" -ForegroundColor Red }
function Sor   { param($m) Write-Host "  $m" -ForegroundColor Cyan }

Write-Host ""
Write-Host "=== PROJE INIT ===" -ForegroundColor Cyan
Write-Host "  Repo : $Repo"
Write-Host "  Slug : $slug" -ForegroundColor White
Write-Host ""

if (-not (Test-Path -LiteralPath $Repo)) { Hata "Repo yok: $Repo"; exit 1 }
$Repo = (Resolve-Path -LiteralPath $Repo).Path

$devBriefVar = Test-Path -LiteralPath "$Repo\DEV_BRIEF.md"
$vaultVar    = Test-Path -LiteralPath "$vault\projects\$slug\PROJECT.md"
if ($devBriefVar -and $vaultVar -and -not $SadeceDogrula) {
  Uyari "Bu proje zaten bagli gorunuyor."
  $c = Read-Host "  Yine de devam? (e/h)"
  if ($c -ne 'e') { Yaz "Iptal."; exit 0 }
  Uyari "Devam: hicbir mevcut dosya UZERINE YAZILMAYACAK."
}

if ($SadeceDogrula) {
  & (Join-Path $PSCommandPath '..\proje-init-dogrula.ps1') -Repo $Repo -Slug $slug
  exit $LASTEXITCODE
}

# ── 1) Stack ─────────────────────────────────────────────────────
$STACK_LIST = @{
  1 = @{ Ad='Java backend';   Tek='Java 21 / Spring Boot 4 / Maven' }
  2 = @{ Ad='React frontend'; Tek='React 18+ / Vite / npm' }
  3 = @{ Ad='Node backend';   Tek='Node / Prisma / PostgreSQL' }
  4 = @{ Ad='Baska / karma'; Tek='' }
}
if (-not $Stack) {
  Sor "Bu proje hangi stack? (1 yazman yeterli)"
  foreach ($k in (1,2,3,4)) { Yaz "  $k) $($STACK_LIST[$k].Ad)  --  $($STACK_LIST[$k].Tek)" }
  $Stack = [int](Read-Host "  Secim")
}
if (-not $STACK_LIST.ContainsKey($Stack)) { Hata "Gecersiz stack"; exit 1 }
$stackAd = if ($Stack -eq 4 -and $StackAdi) { $StackAdi } else { $STACK_LIST[$Stack].Tek }
Tamam "Stack: $($STACK_LIST[$Stack].Ad) -- $stackAd"

# ── 2) Kararlar ──────────────────────────────────────────────────
$D = @(
  @{ Slug='kod-ajani-vaulta-yazmaz';                  Ad='Kod ajani vault''a yazmaz';           V=($true) }
  @{ Slug='frontend-stack-react-vite';                Ad='Frontend yigini React+Vite';          V=($Stack -eq 2) }
  # ⭐ 2026-10-01: PostgreSQL artik VARSAYILAN DEGIL. Kullanici itirazi:
  #   "MCP projesinde DB'ye ihtiyacimiz henuez yok, her projede db
  #    olacak diye bir kural da olamaz." Kapsam daraltildi:
  #   yalnizca VERITABANI OLAN projelerde gecerli.
  @{ Slug='postgresql-tum-projelerde-tek-veritabani'; Ad='PostgreSQL (yalniz DB''si olan projede)'; V=($false) }
  @{ Slug='feature-based-paket-yapisi';               Ad='Feature-based paket yapisi';          V=($Stack -in @(1,3)) }
  @{ Slug='api-mutasyonlarinda-post-kullanimi';       Ad='Mutasyonlarda POST';                  V=($Stack -in @(1,3)) }
  @{ Slug='silme-standarti-soft-delete';              Ad='Soft delete (status=DELETED)';        V=($Stack -in @(1,2,3)) }
  @{ Slug='dokumantasyon-once-kod-sonra';            Ad='Dokumantasyon once, kod sonra';       V=($true) }
  @{ Slug='ui-durum-guncellemesi-yansima-testi';      Ad='UI durum yansima testi';              V=($Stack -eq 2) }
  @{ Slug='proje-isimlendirmesi-camelcase';           Ad='Proje isimlendirmesi camelCase';      V=($true) }
)
$secilen = @()
if ($Kararlar) {
  $secilen = @($Kararlar -split ',' | ForEach-Object { $_.Trim() } | Where-Object { $_ })
} elseif ($OnayGec) {
  $secilen = @($D | Where-Object { $_.V } | ForEach-Object { $_.Slug })
} else {
  Write-Host ""
  Sor "Bu projeye hangi standartlar gecerli? (1'den baslayarak virgulle yaz, bos = varsayilan)"
  $n = 1
  foreach ($d in $D) { $m = if ($d.V) { '[x]' } else { '[ ]' }; Yaz "  $m $n) $($d.Ad)"; $n++ }
  $g = Read-Host "  Secim (orn: 1,2,5)"
  if ($g) {
    $secilen = @(($g -split ',') | ForEach-Object { $D[[int]$_.Trim()-1].Slug })
  } else {
    $secilen = @($D | Where-Object { $_.V } | ForEach-Object { $_.Slug })
    Uyari "Varsayilan kullanildi."
  }
}
Tamam "Kararlar: $($secilen.Count) adet"

# karar satirini iki bicimde uret (AGENTS.md ve index.md icin)
$listeAg = @()
foreach ($s in $secilen) {
  $ad = ($D | Where-Object { $_.Slug -eq $s } | Select-Object -First 1).Ad
  if (-not $ad) { $ad = $s }
  $listeAg += "    - ${ad}: $vault\projects\_STANDARTLAR\decisions\$s.md"
}
$listeAgTxt = if ($listeAg.Count) { $listeAg -join "`n" } else { '    (yok)' }

$listeMd = @()
foreach ($s in $secilen) {
  $ad = ($D | Where-Object { $_.Slug -eq $s } | Select-Object -First 1).Ad
  if (-not $ad) { $ad = $s }
  $listeMd += "| $ad | [[projects/_STANDARTLAR/decisions/$s]] |"
}
$listeMdTxt = if ($listeMd.Count) { $listeMd -join "`n" } else { '| _(yok)_ | -- |' }

# ── 3) Repo tarafi ──────────────────────────────────────────────
Write-Host "`n  -- REPO TARAFI --" -ForegroundColor Cyan

$kb = "$Repo\knowledge-base.md"
if (Test-Path -LiteralPath $kb) { Uyari "knowledge-base.md var -- dokunulmadi" }
else {
  Copy-Item -LiteralPath "$vault\_SABLON\knowledge-base-sablonu.md" -Destination $kb -Force
  Tamam "knowledge-base.md"
}

$db = "$Repo\DEV_BRIEF.md"
if (Test-Path -LiteralPath $db) { Uyari "DEV_BRIEF.md var -- dokunulmadi" }
else {
  Copy-Item -LiteralPath "$vault\DEV_BRIEF.md" -Destination $db -Force
  Tamam "DEV_BRIEF.md"
}

$ag = "$Repo\AGENTS.md"
if (Test-Path -LiteralPath $ag) {
  $m = Get-Content -LiteralPath $ag -Raw -Encoding UTF8
  if ($m -match 'Gelistirici Bellegi|Geliştirici Belleği') {
    Uyari "AGENTS.md'de injector zaten var -- cift yazilmadi (idempotency)"
  } else {
    Uyari "AGENTS.md var ama bagli degil -- elle eklemelisin"
  }
} else {
  $agTxt = @"
# Geliştirici Belleği (ZORUNLU ÖN OKUMA — kod yazmadan önce)

- **Bu geliştiricinin profili:** `DEV_BRIEF.md` (repo kökü) — mutlaka oku.
  Çalışma tarzı, karar prensipleri, kanıtlı precedent kütüphanesi, YAPMA listesi.
- **Ne zaman:** her görev başında, kod yazmadan önce.
- **Ne zaman vault'a git:** Mimari karar · rol/yetki · veri tabanı/şema ·
  iş kuralı · çapraz proje kuralı konularında **karar vermeden önce**.
- **Öncelik:** Bu dosyadaki kurallar geçerlidir. Çelişmede bu dosya kazanır.

- **OKUMA KANITI:** Her cevabının sonuna tek satır ekle --
  `Uyguladığım brif bölümleri: §3, §4` ve `Vault'tan okuduğum: <dosya> §<bölüm>`.
  Yazamıyorsan brifi kullanmamışsın.

- **KB YAZMA ZORUNLULUĞU:** Çözdüğün her hatayı ve verdiğin her kalıcı
  kararı bu repodaki `knowledge-base.md`'ye yaz.
    · hata  -> `### Problem` · `### Root Cause` · `### Solution` · `### Files Changed`
    · karar -> `### Karar` · `### Karar Gerekçesi` · `### Değerlendirilen Alternatifler`
  **Bu dosyayı okuma, sadece yaz** (200 KB'a çıkabilir).
  Aynı hatayı/kararı ikinci kez bulursan tekrar yazma -- terfi oner.

- **VAULT'A HİÇBİR ŞEY YAZMA.** `raw/` · `sources/` · `projects/` ·
  `global/` · `log.md` -- hepsi Kütüphaneci'nin katmanı.
  Tek yazma hedefin bu klasördeki `knowledge-base.md`'dir.

---

## Proje Stack'i ve Bu Projeye Bağlı Çapraz Proje Kararları

- **Stack:** $stackAd
- **Kararlar (okunacak yerler -- kopyalanmaz):**

$listeAgTxt

---

Kalici hafiza ve karar gecmisi bu repo'da DEGIL, su vault'ta:

    $vault

Bu vault bir ikinci beyindir. Buradaki dosyalar baglayicidir.

===========================================================
KOD YAZMADAN ONCE -- SIRAYLA OKU (9 adim, atlaman yok)
===========================================================

1) $vault\CLAUDE.md -> Bolum 8 (sozlesme) + Bolum 9 (kesin kurallar)
2) $vault\profile\preferences.md -> tercihlerin. SANA DA GECERLIDIR.
3) $vault\profile\reactions.md -> neye TEPKI verdigin.
   -> §Ret edilenler = YASAK LISTESI · §Onaylanmis kaliplar = standart
4) $vault\projects\_STANDARTLAR\PROJECT.md -> ve decisions/ altindaki TUMU
5) $vault\projects\$slug\PROJECT.md
6) $vault\projects\$slug\architecture.md
7) $vault\projects\$slug\decisions\ -> TUMU
8) $vault\projects\$slug\log.md -> SON 10-15 SATIR
9) $vault\projects\$slug\sources\ -> EN SON 3-5 dosya

Bu 9 adim tamamlanmadan koda dokunma. Projeyi kesfetmeye calisma -- zaten yazili.

===========================================================
YAZMA -- TEK HEDEF: BU PROJENIN knowledge-base.md DOSYASI
===========================================================

· Hata kaydi  -> ### Problem · ### Root Cause · ### Solution · ### Files Changed
· Karar kaydi -> ### Karar · ### Karar Gerekçesi · ### Değerlendirilen Alternatifler

VAULT'A HICBIR SEY YAZMA. Tek yazma hedefin bu klasordeki knowledge-base.md.
Bu dosyayi OKUMA -- "Daha once oldu mu?" cevabi DEV_BRIEF.md §3'te.
KIM OKUR: yalnizca Kutuphaneci (snapshot ile).
"@
  [IO.File]::WriteAllText($ag, $agTxt, $utf8)
  Tamam "AGENTS.md (9 adim okuma + $($secilen.Count) karar)"
}

# ── 4) Vault tarafi ──────────────────────────────────────────────
Write-Host "`n  -- VAULT TARAFI --" -ForegroundColor Cyan
$vp = "$vault\projects\$slug"
foreach ($d in @($vp, "$vp\decisions", "$vp\sources", "$vault\raw\projects\$slug")) {
  if (-not (Test-Path -LiteralPath $d)) { New-Item -ItemType Directory -Path $d -Force | Out-Null }
}
Tamam "projects\$slug\ + raw\projects\$slug\"

$idxTxt = @"
# $slug — geçerli kararlar

> ⭐ Bu liste **projeye bağlı** standartları gösterir. Kaynak sayfaları
> vault'tadır — **kopyalanmaz, okunur.**

## Stack

| | |
|---|---|
| | $stackAd |
| Repo | ``$Repo`` |

## Bağlı standartlar (cross-project)

| Karar | Kaynak |
|---|---|
$listeMdTxt

## Projeye özel kararlar

Henüz yok. Ajan karar verdiğinde buraya eklenir.

## Related
- [[projects/$slug/PROJECT]] · [[architecture]]
- [[projects/_STANDARTLAR/PROJECT]] — tüm projelere geçerli kurallar
- [[network]]
"@
[IO.File]::WriteAllText("$vp\decisions\index.md", $idxTxt, $utf8)
Tamam "decisions\index.md ($($secilen.Count) karar)"

if (Test-Path -LiteralPath "$vp\PROJECT.md") { Uyari "PROJECT.md var -- dokunulmadi" }
else {
  $pjTxt = @"
---
title: $slug
type: project
project: $slug
status: active
confidence: stated
created: $tarih
updated: $tarih
source: [[tools/proje-init.ps1]]
tags: [yeni-proje]
---

# $slug

> ⭐ **Repo:** ``$Repo``
> **Kurulum:** `tools/proje-init.ps1` ile tek komutla · $tarih

## Stack

$stackAd

## ⭐ Bağlı kararlar

→ **[[decisions/index]]** — bu projeye geçerli standartlar

## Repo tarafı

| Dosya | Rol |
|---|---|
| `AGENTS.md` | ajan okuma sırası + ⛔ yazma yönü |
| `DEV_BRIEF.md` | geliştirici profili (vault kopyası) |
| `knowledge-base.md` | ⭐ ajanın **tek yazma hedefi** |

## Related
- [[decisions/index]] — ⭐ bağlı kararlar
- [[projects/_STANDARTLAR/PROJECT]] · [[network]]
"@
  [IO.File]::WriteAllText("$vp\PROJECT.md", $pjTxt, $utf8)
  Tamam "PROJECT.md"
}

if (-not (Test-Path -LiteralPath "$vp\architecture.md")) {
  Copy-Item -LiteralPath "$vault\projects\_TEMPLATE_PROJECT\architecture.md" -Destination "$vp\architecture.md" -Force
  Tamam "architecture.md (sablon)"
}

if (-not (Test-Path -LiteralPath "$vp\log.md")) {
  $lgTxt = @"
# $slug — Proje Logu

## [$tarih] schema-change | Proje açıldı

**Repo:** ``$Repo``
**Stack:** $stackAd
**Kurulum:** `tools/proje-init.ps1` (tek komut) · $($secilen.Count) karar bağlandı
"@
  [IO.File]::WriteAllText("$vp\log.md", $lgTxt, $utf8)
  Tamam "log.md"
}

# ── 5) Kayit ────────────────────────────────────────────────────
Write-Host "`n  -- KAYIT --" -ForegroundColor Cyan
$short = Split-Path -Leaf $Repo
$dbSha  = (Get-FileHash "$vault\DEV_BRIEF.md").Hash.Substring(0,12)

$ix = "$vault\index.md"
$ixT = Get-Content -LiteralPath $ix -Raw -Encoding UTF8
if ($ixT -match [regex]::Escape("projects/$slug/PROJECT")) { Uyari "index.md'de zaten var" }
else {
  $ixSatir = "- ⭐ [[projects/$slug/PROJECT]] — **$tarih'da açıldı**, ``tools/proje-init.ps1`` ile tek komutta kuruldu"
  # ⚠️ PowerShell overload belirsizligi: [regex]::Replace(x,p,r,1) cagirisinda
  #    '1' bir TUM eslesme sayisi DEGIL RegexOptions olarak cozulur → TUM
  #    satirlari degistirir. Açık Regex nesnesi + instance Replace kullan.
  $reIx = [regex]::new('(?m)^(## Projeler\s*)\r?$')
  $yeni = $reIx.Replace($ixT, "`$1`r`n$ixSatir", 1)
  if ($yeni -eq $ixT) { Uyari "index.md'de '## Projeler' basligi bulunamadi — elle ekle" }
  else { [IO.File]::WriteAllText($ix, $yeni, $utf8); Tamam "index.md" }
}

$mf = "$vault\ingest-manifest.md"
$mfT = Get-Content -LiteralPath $mf -Raw -Encoding UTF8
if ($mfT -match [regex]::Escape("raw/projects/$slug")) { Uyari "manifest'te zaten var" }
else {
  # ⚠️ anchor: manifest'te satır BAŞINA proje yazılır, "raw/projects/ (diğer)"
#    diye bir satır YOKTUR. İlk `raw/projects/` satırının ÜSTÜne ekle.
$satir = "| ``raw/projects/$slug/`` | 0 | 0 | — | — | 🔄 | — | ⭐ $tarih'da ``proje-init.ps1`` ile açıldı — boş |"
$reMf = [regex]::new('(?m)^\| `raw/projects/')
$yeni = $reMf.Replace($mfT, "$satir`r`n`$0", 1)
if ($yeni -eq $mfT) { Uyari "manifest'te 'raw/projects/' satiri bulunamadi — elle ekle" }
else { [IO.File]::WriteAllText($mf, $yeni, $utf8); Tamam "ingest-manifest.md" }
}

$kt = "$vault\projects\_STANDARTLAR\DEV_BRIEF_YEREL_KOPYASI.md"
$ktT = Get-Content -LiteralPath $kt -Raw -Encoding UTF8
if ($ktT -match [regex]::Escape("``$slug``")) { Uyari "kurulum tablosunda zaten var" }
else {
  $kSatir = "| $short | ``$slug`` | ``$Repo`` | kök ``AGENTS.md`` | ✅ | $tarih | ``$dbSha…`` | ``proje-init $tarih`` |"
  $reKt = [regex]::new('(?m)^(\|\s*-{3,}[^\r\n]*\|)\r?$')
  $yeni = $reKt.Replace($ktT, "`$1`r`n$kSatir", 1)
  if ($yeni -eq $ktT) { Uyari "kurulum tablosunda baslik ayraci yok - elle ekle" }
  else { [IO.File]::WriteAllText($kt, $yeni, $utf8); Tamam "kurulum tablosu" }
}

# ⛔ idempotency: her calistirmada log'a yeni giris EKLENMEZ
$logYolu = "$vault\log.md"
if ((Get-Content -LiteralPath $logYolu -Raw -Encoding UTF8) -match [regex]::Escape("schema-change | ⭐ Yeni proje: ``$slug``")) {
  Uyari "log.md'de bu proje zaten kayitli -- tekrar yazilmadi (idempotency)"
} else {
$logSatir = @"

---

## [$tarih] schema-change | ⭐ Yeni proje: ``$slug``

**Repo:** ``$Repo``
**Stack:** $stackAd

**Kurulum:** ``tools/proje-init.ps1`` — TEK komutta repo + vault + kayıt + dogrulama.
**Bağlı kararlar ($($secilen.Count)):** $($secilen -join ', ')

> Dosyaları **script** yazdı, kod ajanı değil — çıktı deterministik.
"@
Add-Content -LiteralPath $logYolu -Value $logSatir -Encoding UTF8
Tamam "log.md"
}

# ── 6) Dogrulama ────────────────────────────────────────────────
Write-Host "`n  -- DOGRULAMA --" -ForegroundColor Cyan
Write-Host ""
& (Join-Path $PSCommandPath '..\proje-init-dogrula.ps1') -Repo $Repo -Slug $slug
$d = $LASTEXITCODE

Write-Host "`n  -- raw/ KANITI --" -ForegroundColor Cyan
& (Join-Path $PSCommandPath '..\raw-dogrula.ps1')

Write-Host ""
if ($d -eq 0) { Write-Host "=== PROJE HAZIR ===" -ForegroundColor Green }
else          { Write-Host "=== EKSIK VAR -- yukaridaki kirmizilari duzelt ===" -ForegroundColor Red }
Write-Host ""
exit $d
