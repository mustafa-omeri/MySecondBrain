# log.md — global olay kaydı

> ⭐ **Append-only.** Satır **silinmez**, **düzeltilmez.** Hata olursa yeni
> kayıt düşülür. Tarih: `YYYY-MM-DD`.
>
> Biçim:
> ```
> ## [YYYY-MM-DD] <operasyon> | <konu>
> ```

## Operasyon türleri

| Tür | Ne zaman |
|---|---|
| `ingest` | `raw/`'dan bir şey işlendi |
| `query` | vault'tan bilgi arandı |
| `lint` | tutarlılık kontrolü yapıldı |
| `learn` | profil güncellendi |
| `decision` | karar sayfası açıldı |
| `schema-change` | yapı/kural değişti |
| `build` | kod/arac üretildi |
| `fix` | hata düzeltildi |

---

## [YYYY-MM-DD] schema-change | vault kuruldu (şablon → kişisel)

**Ajan:** hazırla komutu
**Ne yapıldı:**
- `<VAULT_YOLU>` placeholder'ı gerçek yolla değiştirildi
- `profile/user.md` · `profile/preferences.md` dolduruldu
- `profile/reactions.md` boş kaldı (ölçüm henüz yok)
- `git init` + ilk commit

**Değişen dosyalar:** _(listele)_

**⏳ Bekleyen:** ilk `raw/` belgesi · ilk sohbet kaydı · ilk proje