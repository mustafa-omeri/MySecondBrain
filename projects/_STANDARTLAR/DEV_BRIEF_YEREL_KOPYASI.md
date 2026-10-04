# DEV_BRIEF — yerel kopya

> ⭐ **Bu dosya, vault kökündeki `DEV_BRIEF.md`'nin POINTER tablosudur.**
> Kod ajanı kök dosyayı okur; bu tablo **güncellik kontrolü** içindir.
>
> ⛔ İçerik **buraya kopyalanmaz.** Kaynak: `<VAULT_YOLU>\DEV_BRIEF.md`

## Kurulum tablosu

`tools\proje-init.ps1` bu tabloya satır ekler (idempotent).

| Proje | Slug | Repo | AGENTS.md | DB | Tarih | Kurulum | Not |
|---|---|---|---|---|---|---|---|
| _(kayıt yok)_ | | | | | | | |

## ⭐ Senkron kontrolü

| | |
|---|---|
| Bu tablodaki `Not` sütunu | `proje-init <tarih>` |
| vault `DEV_BRIEF.md` sürümü | dosya başındaki `updated` |

Bayat **yerel kopya** varsa uyarı verilir: *"brif güncellendi, repodaki kopya
eski kaldı."*

> ⭐ LINT bunu kontrol eder — `lint-report.md` madde 9.

## Related
- `DEV_BRIEF.md` — asıl dosya
- `tools/proje-init.ps1` — bu tabloyu günceller