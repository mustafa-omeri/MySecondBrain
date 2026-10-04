# ACIK_ISLER — vault'un kendi eksi/hata defteri

> ⭐ **Bu dosya "sonra düzeltirim" dediğin her şeyin tutulduğu yerdir.**
> `lint-report.md` bir **anlık görüntüdür** (tarihli). Bu dosya **süreçtir**
> (kapanmadıkça durur).
>
> ⛔ **Bu dosya otomatik düzelmez.** Kaydeder, sıralar, bekler.
> ⛔ **Madde uydurma.** Buraya yazan ajan kanıtını (dosya + satır) yazar.

## ⭐ İki dosyanın farkı

| | `lint-report.md` | ⭐ `ACIK_ISLER.md` |
|---|---|---|
| Tip | **rapor** — bir anın fotoğrafı | **defter** — kapanmayan işler |
| Tarih | Her lint'te **değişir** | Kalıcı; madde kapanınca ✅ olur |
| Kullanım | *"vault genelde ne durumda?"* | *"sırada ne var?"* |
| Silinir mi? | Her lint'te **yeniden yazılır** | Hayır — kapanan madde de kalır |

## ⭐ Çalışma süreci — 5 adım

### ADIM 1 — Topla
Bulgu varsa buraya yaz. **Zorunlu 3 alan:**

| Alan | Kural |
|---|---|
| **Kanıt** | dosya yolu + satır. *"bir yerde"* yazma |
| **Neden önemli** | Etkisi ne? Kim yanılır? |
| **Nasıl doğrulanır** | Bitince hangi komut/sayım yeşile döner? |

### ADIM 2 — Önceliklendir
`P1` yanlış bilgi üretir · `P2` çalışmayı yavaşlatır · `P3` temizlik

### ADIM 3 — Tek tek işle
**Sırayla.** Toplu *"hepsini düzelt"* denmez — hangisinin kırıldığını
anlamak zorlaşır.

### ADIM 4 — Doğrula
Madde 3'teki komutu/sayımı çalıştır. Yeşile dönmediyse **kapatma.**

### ADIM 5 — Kapat
`✅` işaretle + `log.md`'ye giriş düş + **satırı silme.**

> ⭐ **Kapanan satır kalır.** 3 ay sonra aynı hata yapılırsa
> *"kaç kez olmuş"* sorusu cevaplanabilir olur.

---

## 🔶 P1 — yanlış bilgi üretir

_(henüz açık madde yok)_

## 🔶 P2 — çalışmayı yavaşlatır

| # | Bulgu | Kanıt | Nasıl doğrulanır | Durum |
|---|---|---|---|---|
| **1** | `raw/chats/<ajtör>/` klasörü **boş** — sohbet kaydı bekleniyor | `ingest-manifest.md` §1 | Klasörde dosya var + işlendi | ⬜ *(kullanıcıda)* |

## 🔶 P3 — temizlik

_(henüz açık madde yok)_

---

## ⭐ Değişiklik kaydı

| Tarih | Ne |
|---|---|
| 2026-10-04 | ⭐ **Dosya açıldı** (şablon) — içinde henüz eksi yok; kendi eksiklerini sen doldurursun |

---

## ⭐ Sık yapılan hata

| Hata | Doğrusu |
|---|---|
| "Hatayı buldum, unuturum" | Buraya yaz — **sadece buraya** |
| Kanıt yazmadan madde açmak | Dosya + satır zorunlu |
| Düzeltip maddeyi **silmek** | `✅` işaretle, **satır kalsın** |
| 5 maddeyi birden kapatmak | Tek tek. Sırayla. |
| "Doğruladım" deyip geçmek | Komut/sayım **çalıştırılmalı** |

## Related
- `lint-report.md` — anlık durum raporu
- `ingest-manifest.md` §2 — bayrak defteri (ham kaynak odaklı)
- `CLAUDE.md` §7 `LINT`