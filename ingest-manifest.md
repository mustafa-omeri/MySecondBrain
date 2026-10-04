# ingest-manifest — ham kaynak takibi

> ⭐⭐ **Bu dosya olmadan hiçbir ajan `raw/`'ı tarayamaz.**
> Ham kaynak taraması yapacaksan **önce Bölüm 1'e bak.**
>
> ⛔ **"Taramayı atladım, yeni bir şey yok"** demek **kanıtsız tespittir.**
> Sayı/tarih değişimini **tespit edemiyorsan** → *"yok"* deme, **emin ol.**

## ⭐ Bölüm 1 — `raw/` envanteri

| Klasör | Toplam | İşlenen | 🔶 | ⬜ | Son işleme | Not |
|---|---:|---:|---:|---:|---|---|
| `raw/inbox/` | 1 | 0 | — | ⬜ | — | boş — yalnız `.gitkeep` |
| `raw/articles/` | 1 | 0 | — | ⬜ | — | boş — yalnız `.gitkeep` |
| `raw/transcripts/` | 1 | 0 | — | ⬜ | — | boş — yalnız `.gitkeep` |
| `raw/chats/<ajtör>/` | 0 | 0 | — | ⬜ | — | sohbet kaydı bekleniyor |
| `raw/knowhow/` | 0 | 0 | — | ⬜ | — | |
| `raw/projects/` | 0 | 0 | — | ⬜ | — | |
| `raw/agent-output/` | 0 | 0 | — | ⬜ | — | Kütüphaneci'nin katmanı |

**Sütun açıklaması:**
`Toplam` = `.gitkeep` hariç dosya sayısı · `İşlenen` = kaynak sayfası
oluşturulan · `🔶` = kısmen · `⬜` = hiç · `Son işleme` = tarih

> ⓘ Bir klasör **`.gitkeep` dışında dosya içermiyorsa** işlenmemiş sayılır.

## Bölüm 2 — Açık işler (bayraklar)

| # | İş | Durum | Açıldı | Not |
|---|---|---|---|---|
| — | _(açık iş yok)_ | | | |

> ⭐ Bu tablo **kapanmayan işlerin** tek yeri. Kapatılan bayrak **silinmez**,
> durumu `✅` olur ve notu gerekçesini yazar.

## Bölüm 3 — Kararlar (bayrağın kapandı mı, neye karar verildi)

| Bayrak | Karar | Tarih |
|---|---|---|
| _(yok)_ | | |

## ⭐ Dört kural

1. **Önce buraya bak.** Ham kaynak taraması bu dosyayı atlayarak yapılmaz.
2. **Sayı değişmediyse tekrar bakma.** Yeni olanları işle.
3. **Değersizse de yaz.** ⛔ *"Önemli değil"* cevabı da kayıttır — sessizce
   geçilmez. Aksi halde sonraki ajan aynı dosyayı yeniden değerlendirip
   aynı soruyu tekrarlar.
4. **"Yok" bulguları zaman damgalıdır.** ⭐ Bir aracın deposu ölçüldüyse ve
   "boş" çıktıysa, bu bulgu **araç sürümü değişince geçersizdir.**
   Yeniden ölçmeden "hâlâ boş" deme.

## Related
- `CLAUDE.md` §7.0 — routing tablosu
- `RAW_ISLEM_PROMPT.md` — ham kaynak işleme komutu