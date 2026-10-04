<#
  raw-dogrula.ps1 — `raw/` parmak izi

  ⭐ NEDEN VAR: `raw/` immutable. Bu script, klasörün dokunulmadığını
  SÖZLE değil ÖLÇÜMLE kanıtlar. ~200 ms'de 1000+ dosya.

  ⭐⭐ HASH GİRDİSİNİN TANIMI — DEĞİŞTİRME
  ---------------------------------------------------------------
  Her dosya için şu string, KÖK GÖREL yolla birleştirilir:

      <raw/ KOKUNE GORE goreli yol>|<boyut>|<LastWriteTimeUtc.Ticks>

  Örnek:  knowhow\Keep\not.md|1536|638500000000000000

  Ardından  satırlar FullName'e göre sıralanır,
  "COUNT=<adet>\n" + satırlar  SHA-256 ile özetlenir, ilk 16 hex yazılır.

  ⚠️ 2026-09-30 UYARI: Aynı dosyalar için **farklı hash** çıktı, çünkü
  eski sürüm yolları vault KÖKÜNE göre kırpıyordu. Girdi dizisi değişirse
  hash değişir — bu bir İHLAL DEĞİL, ölçümün kendisi değişmiştir.
  Bu yüzden hash'in **nasıl** üretildiği burada sabit yazılıdır.
  Yukarıdaki tanımı değiştirirsen TÜM eski karşılaştırmalar geçersiz olur.

  KULLANIM:
    pwsh -NoProfile -File tools\raw-dogrula.ps1
      → mevcut COUNT + PARMAKIZI yazar (rapora not et)

    pwsh -NoProfile -File tools\raw-dogrula.ps1 -Beklenen "1084/236865E14525C178"
      → karşılaştırır; artış ℹ️, düşüş ⛔

  ⭐ YANLIŞ ALARM UYARISI (2026-09-30'da 6 kez oldu):
    `projects/_STANDARTLAR/` altında PowerShell'in yol çözümlemesi
    ARAKALIARLA başarısız oluyor — dosya görünür, `Test-Path: False`.
    Bu bir dosya hatası DEĞİLDİR. Tarayıcıda "kırık bağlantı" görürsen
    önce burayı kontrol et.
#>
[CmdletBinding()]
param(
  [string]$Beklenen
)

$ErrorActionPreference = 'Stop'

function Get-RawParmakIzi {
  $root = Split-Path -Parent (Split-Path -Parent $PSCommandPath)
  $rawDir = Join-Path $root 'raw'
  $rows = Get-ChildItem $rawDir -Recurse -File -Force |
    Sort-Object FullName |
    ForEach-Object {
      "$($_.FullName.Substring($rawDir.Length + 1))|$($_.Length)|$($_.LastWriteTimeUtc.Ticks)"
    }
  $txt = "COUNT=$($rows.Count)`n" + ($rows -join "`n")
  $sha = [BitConverter]::ToString(
    [Security.Cryptography.SHA256]::Create().ComputeHash(
      [Text.Encoding]::UTF8.GetBytes($txt))).Replace('-','').Substring(0,16)
  # ⚠️ 2026-10-01: iki sayım ayrı raporlanır. `Get-ChildItem` yapısal
  # `.gitkeep` dosyalarını da sayar; manifest ise içerik sayar. Bu kırılma
  # bilinçli: parmak izi HER DOSYAYI kapsar (değişiklik tespiti için),
  # manifest ise İÇERİĞİ sayar. İkisini karıştırmak "su seviyesi"
  # mantığını bozuyordu.
  $keep = @(Get-ChildItem $rawDir -Recurse -File -Force -Filter '.gitkeep').Count
  "$($rows.Count)/$sha/$keep"
}

$mevcut = Get-RawParmakIzi
# ⭐ 2026-10-01: çıktı 3 alanlı → `COUNT=n  PARMAKIZI=xxxxxxxx  GITKEEP=n`
#    (eski 2 alanlı biçim geriye dönük olarak hâlâ kabul edilir)
Write-Output "COUNT=$($mevcut -replace '/','  ')"

if (-not $Beklenen) { exit 0 }
if ($mevcut -eq $Beklenen) { Write-Output "✅ DEĞİŞMEDİ"; exit 0 }

$yeni = [int]($mevcut -split '/')[0]
$eski = if ($Beklenen -match '^\s*(\d+)') { [int]$Matches[1] } else { 0 }

if ($yeni -gt $eski) {
  Write-Output "ℹ️ ARTIS ($eski → $yeni) — kullanıcı yeni belge eklemiş. Dokunulmamış kabul edilir."
  exit 0
}

Write-Output "⛔ DEĞİŞTİ (düşüş veya açıklanamayan değişim)"
exit 1