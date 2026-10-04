<#
  proje-init-dogrula.ps1 — Yeni proje bağlantısı doğrulaması

  ⭐ NEDEN VAR: `PROJE_INIT_REPO` + `PROJE_INIT_VAULT` iki ayrı komut.
  Bu script, ikisinin de gerçekten çalıştığını kanıtlar. Bugüne kadar
  elle kontrol ediliyordu — 3 repoda elle dağınıklı injector düzeltildi.

  KULLANIM:
    pwsh -NoProfile -File tools\proje-init-dogrula.ps1 -Repo "C:\devtools\ws\MyApp" -Slug "my-app"

  ⭐ Bu script SADEce okur. Hiçbir dosyayı değiştirmez.
#>
[CmdletBinding()]
param(
  [Parameter(Mandatory = $true)][string]$Repo,
  [Parameter(Mandatory = $true)][string]$Slug
)

$ErrorActionPreference = 'Continue'
$vault = Split-Path -Parent (Split-Path -Parent $PSCommandPath)
$ok = 0; $hata = 0

function Test-Item {
  param([string]$Yol, [string]$Etiket)
  if (Test-Path -LiteralPath $Yol) {
    Write-Output "  ✅ $Etiket"
    $script:ok++
  } else {
    Write-Output "  ⛔ $Etiket — BULUNAMADI: $Yol"
    $script:hata++
  }
}

Write-Output "=== 1) REPO TARAFI ($Repo) ==="
Test-Item (Join-Path $Repo 'DEV_BRIEF.md')            'DEV_BRIEF.md (profil kopyası)'
Test-Item (Join-Path $Repo 'knowledge-base.md')        'knowledge-base.md (yazma hedefi)'

# Ajan konvansiyonu — biri olmalı
$agents   = Join-Path $Repo 'AGENTS.md'
$dotAgent = Join-Path $Repo '.agent\AGENTS.md'
if (Test-Path -LiteralPath $agents) {
  Write-Output "  ✅ AGENTS.md (kök)"
  $ok++
} elseif (Test-Path -LiteralPath $dotAgent) {
  Write-Output "  ✅ .agent\AGENTS.md (injector)"
  $ok++
} else {
  Write-Output "  ⛔ Hiçbir AGENTS.md yok — ajan bu projeyi tanımayacak"
  $hata++
}

# ⭐ İdempotency: injector iki kez yazılmış mı?
$hedef = if (Test-Path -LiteralPath $agents) { $agents } else { $dotAgent }
if (Test-Path -LiteralPath $hedef) {
  $n = (Select-String -LiteralPath $hedef -Pattern 'Geliştirici Belleği' -SimpleMatch -ErrorAction SilentlyContinue | Measure-Object).Count
  if ($n -eq 0) { Write-Output "  ⛔ Injector YOK — '# Geliştirici Belleği' başlığı bulunamadı"; $hata++ }
  elseif ($n -eq 1) { Write-Output "  ✅ Injector tam (1 kopya)"; $ok++ }
  else { Write-Output "  ⛔ Injector $n kez var — init iki kez çalıştırılmış"; $hata++ }

  # ⭐ Yazma yönü kuralı
  if (Select-String -LiteralPath $hedef -Pattern 'VAULT.A HİÇBİR ŞEY YAZMA|hiçbir şey yazma' -ErrorAction SilentlyContinue) {
    Write-Output "  ✅ Yazma yönü kuralı var (vault'a yazma)"
    $ok++
  } else {
    Write-Output "  ⛌ Yazma yönü kuralı yok — ajan vault'a yazabilir"
  }

  # ⭐ Karar kaydı (bugün eklendi, sık unutulur)
  if (Select-String -LiteralPath $hedef -Pattern 'Değerlendirilen Alternatifler' -ErrorAction SilentlyContinue) {
    Write-Output "  ✅ Karar kaydı formatı tanımlı"
    $ok++
  } else {
    Write-Output "  ⛔ Karar kaydı formatı yok — ajan yalnız hata yazar"
    $hata++
  }
}

Write-Output ""
Write-Output "=== 2) VAULT TARAFI (projects/$Slug) ==="
$p = Join-Path $vault "projects\$Slug"
Test-Item (Join-Path $p 'PROJECT.md')   'PROJECT.md'
Test-Item (Join-Path $p 'log.md')       'log.md'
Test-Item (Join-Path $p 'decisions')    'decisions/ klasörü'
Test-Item (Join-Path $p 'decisions\index.md') '⭐ decisions/index.md — bağlı kararlar'

# ⭐ Karar listesi gerçekten dolu mu?
$idx = Join-Path $p 'decisions\index.md'
if (Test-Path -LiteralPath $idx) {
  $n = (Select-String -LiteralPath $idx -Pattern '\[\[' -ErrorAction SilentlyContinue | Measure-Object).Count
  if ($n -eq 0) { Write-Output "  ⛔ decisions/index.md BOŞ — ajan hangi kararın kendine ait olduğunu bilmez"; $hata++ }
  else { Write-Output "  ✅ $n karar bağlantısı listelenmiş"; $ok++ }
}

Write-Output ""
Write-Output "=== 3) KAYIT ==="
$tab = Join-Path $vault 'projects\_STANDARTLAR\DEV_BRIEF_YEREL_KOPYASI.md'
if (Test-Path -LiteralPath $tab) {
  if (Select-String -LiteralPath $tab -Pattern $Slug -SimpleMatch -ErrorAction SilentlyContinue) {
    Write-Output "  ✅ Kurulum tablosunda kayıtlı"; $ok++
  } else {
    Write-Output "  ⛔ Kurulum tablosunda YOK — DEV_BRIEF.md dağıtımı takip edilemez"; $hata++
  }
}
if (Select-String -LiteralPath (Join-Path $vault 'index.md') -Pattern $Slug -SimpleMatch -ErrorAction SilentlyContinue) {
Write-Output "  ✅ index.md'de kayıtlı"; $ok++
  } else {
    Write-Output "  ⛔ index.md'de YOK"; $hata++
  }

  # ⭐ Bu kontrol 2026-10-01'de eklendi: script manifest'e yazamadı ama
  # doğrulama bunu YAKALAMADI — 13/13 yanlış yeşil verdi.
  if ((Get-Content -LiteralPath "$vault\ingest-manifest.md" -Raw -Encoding UTF8) -match [regex]::Escape("raw/projects/$Slug")) {
    Write-Output "  ✅ manifest'te kayıtlı"; $ok++
  } else {
    Write-Output "  ⛔ manifest'te YOK — ham kaynak klasörü kayıtsız"; $hata++
  }

Write-Output ""
Write-Output "════════════════════════════════════════"
Write-Output "  ✅ $ok   ⛔ $hata"
if ($hata -eq 0) {
  Write-Output "  ⭐ Proje second brain'a TAM bağlı."
  exit 0
} else {
  Write-Output "  ⛔ BAĞLANTI EKSİK — yukarıdaki kırmızıları düzelt."
  exit 1
}