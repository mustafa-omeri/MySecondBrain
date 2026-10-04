---
title: Tepkilerim
type: profile
project: global
status: draft
confidence: stated
created: 2026-10-04
updated: 2026-10-04
source: []
tags: [profil, tepki, onay, ret]
---

# Tepkilerim

> ⭐ **BOŞ ŞABLON — ve bu doğru.**
>
> Bu dosya **senin ölçülmüş tepkilerindir.** Ajan tahmin edemez,
> uyduramaz. `raw/chats/` klasörüne sohbet kaydı koyup
> `profile/reactions.md`'yi işlediğinde dolar.
>
> ⛔ **Şablonda örnek satır bile yok.** Çünkü örnek satır, kullanıcının
> tepkisi olmadığı halde "onay" gibi görünür → ajan **uydurmuş** olur.

## Ölçüm katmanı

`preferences.md` ne **istediğimi** tutar; bu dosya **hangi çıktıya onay
verdiğimi / neyi reddettiğimi** tutar. **Biri olmadan diğeri eksiktir.**

## Sözlük

| Valans | Anlamı |
|---|---|
| `onay` | beğendim, tekrarla / böyle devam |
| `degistir` | fikrimi değiştirdim, revize et |
| `reddet` | yanlış / istemediğim — **yasak listesi** |
| `devam` | tamam, sıradakine geç |

| Boyut | Anlamı |
|---|---|
| `icerik` · `uslup` · `uzunluk` · `yapi` · `kapsam` · `hiz` · `gorsel` | neye tepki verdiğim |

| Genellik | Anlamı |
|---|---|
| `genel` | her konuda böyleyim |
| `baglamli` | bu projede böyleyim |
| `proje` | sadece şu projede |

## Tekrarlayan tepkiler (terfi adayları)

3+ kez tekrarlananlar.

| # | Ne üzerinde | Tepki | Boyut | Genellik | Tekrar | İlk | Kanıt (kullanıcı ifadesi) |
|---|---|---|---|---|---:|---|---|
| _(boş — sohbetler işlendikçe dolar)_ | | | | | | | |

## ⛔ Ret edilenler (yasak listesi)

`reddet` tepkileri. **Bu bir yasak listesidir — ajan bunları tekrarlamaz.**

| # | Yapma | Boyut | Neden (kullanıcı ifadesi) | Tarih |
|---|---|---|---|---|
| _(boş)_ | | | | |

## Tek seferlik sinyaller

Bir kez söylenmiş, henüz kural değil. Sayı yükseldikçe üstteki tabloya
taşınır. **Satırlar silinmez.**

| Tarih | Ne üzerinde | Tepki | Boyut | Genellik | Tetikleyen (kısa) | Chat |
|---|---|---|---|---|---|---|

## Onaylanmış kalıplar

3+ `onay` biriken bir şey artık **tesadüf değil, standarttır.**

| # | Standart | Boyut | Kaç kez | Terfi |
|---|---|---|---:|---|

## Nasıl dolar?

```
Sen sohbeti  raw/chats/<ajtör>/YYYY-MM-DD-<konu>.md  olarak kaydedersin
        ↓
Kütüphaneci oturumu açar (LIBRARIAN_AGENT_PROMPT.md)
        ↓
Her chat'te YALNIZCA <siz> blokları okunur   ⛔ asistan mesajı kanıt değil
        ↓
Tepki + boyut + genellik çıkarılır, tekrar sayacı artırılır
        ↓
3+ tekrar  →  "Tekrarlayan tepkiler"
reddet     →  "Ret edilenler" (yasak listesi)
3+ onay    →  "Onaylanmış kalıplar" → preferences.md'ye terfi önerisi
```

## ⭐ Boş bırakmanın maliyeti

Bu dosya boşken ajan *"kısa cevap ister, Türkçe ister"* diye tahmin eder
(hepsi `preferences.md`'den gelir). Ama **neyi reddettiğini** bilmez.

Sonuç: ajan aynı hatayı tekrar yapar, kullanıcı **aynı cümleyi** tekrar
söyler. Yasağın değeri **o cümleyi bir daha duymamakta.**

## Related
- [[profile/preferences]] — ne istiyorum
- [[concepts/tatmin-signali-islemi]] — neden yalnız `<siz>`
- [[raw/chats/_SABLON/chat-sablonu]] — kayıt şablonu
- [[HAZIRLA]]