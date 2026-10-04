---
title: Chat Şablonu
type: template
project: global
status: active
created: 2026-09-27
updated: 2026-09-27
---

# Chat Kayıt Şablonu

Bir sohbeti `raw/chats/<ajtör>/YYYY-MM-DD-<konu-slug>.md` olarak kaydet.
Bu klasör **elle** doldurulur (dönüştürücü betik yok).

**Kritik kural:** Sadece **`<siz>`** etiketli bloklar senin ifadendir.
`<asistan>` blokları **bağlamdır, kanıt değildir.** Kütüphaneci yalnızca
`<siz>` bloklarından tepki çıkarır. Bu yüzden etiketleri atlama — etiketsiz
metin "senin söylemediğin bir şey" sayılır ve işlenmez.

---

## Dosya adlandırma

```
raw/chats/opencode/2026-09-27-tailwind-arayuz.md
raw/chats/claude/2026-09-20-sprint-boot-mimari.md
raw/chats/chatgpt/2026-08-15-cv-rehberi.md
```

`<ajtör>` klasörleri: `opencode/` · `claude/` · `chatgpt/` · `diger/`

---

## Şablon

```markdown
---
title: <sohbetin konusu, kısa>
type: chat
source_ai: <opencode | claude | chatgpt | ...>
date: YYYY-MM-DD
cwd: <sohbetin geçtiği klasör yolu — proje bağlantısı için. Boş bırakılabilir>
project: <slug — cwd bir projeye denk geliyorsa>
review: false
---

# <konu>

<sohbetin neyle ilgili olduğuna dair 1-2 cümle — bu, sonradan hatırlamak
için. Kütüphaneci bunu kaynak başlığı olarak kullanır.>

---

## Konuşma

<siz>
Buraya kendi mesajını yaz.
</siz>

<asistan>
Asistanın cevabı. Gerekirse kısalt — tamamı gerekmiyor, sadece tepkinin
bağlamı lazım.
</asistan>

<siz>
Buraya tepkin. Örn: "Aynen böyle olsun" / "Çok uzun, özetle" /
"Bunu istemiyorum, şunu yap" / "Üslup hoşuma gitmedi".
</siz>

<asistan>
...
</asistant>

---

## Benim notum (isteğe bağlı)

<Asistanın neyi beğenmediğini/ değiştirmek istediğini anlatmıyorsan buraya
serbestçe yaz. Bu blok da senin ifaden sayılır.>
```

---

## Kaydetmeden önce 3 soru

1. **Bu sohbette bir şeyi beğendim mi, değiştirmek istedim mi, istemedim
   mi?** Sadece sohbeti arşivlemek istiyorsan yine de kaydet — işe yaramaz
   ama kaybolmaz. Ancak tepki yoksa Kütüphaneci boş döner.

2. **Aynı tepkiyi daha önce verdim mi?** Kütüphaneci bunu tekrar sayısıyla
   tutar. 3+ tekrar olursa `profile/preferences.md`'e terfi önerisi gelir.
   Bu yüzden **eskisini silme** — aynı tepki 3. kez görünmeli.

3. **Cwd yazdım mı?** Yazarsan sohbet otomatik projeye bağlanır ve
   `projects/<slug>/sources/` altına da gider. Yazmazsan sadece genel
   işlenir.

---

## Ne KAPILMAZ

`raw/chats/` altına yazdığın hiçbir şey **gizli veri muamelesi görür**
(CLAUDE.md §9, `raw-gizli-veri-kopyalanmaz` kararı). Yani:

- Parola, token, API anahtarı → kopyalanmaz
- IBAN, kart no, TC no → kopyalanmaz
- Müşteri/kurum sırları → kopyalanmaz
- Tıbbi kayıtlar → kopyalanmaz

Yine de sohbetlerde bunlar **sık geçer** (yapıştırdığın kod, ekran
görüntüsü, hata mesajı). Kaydetmeden önce bir göz at.

## Related
- [[profile/reactions]]
- [[concepts/tatmin-signali-islemi]]
- [[projects/_STANDARTLAR/decisions/raw-gizli-veri-kopyalanmaz]]
