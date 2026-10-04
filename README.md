# README — İkinci Beyin

> ⭐ **Kişisel ikinci beyin.** Kod ajanlarının okuduğu, senin yazdığın
> ve kararlarını saklayan bir bilgi tabanı.
>
> ⭐ **Bu bir şablondur — bilgiler boş.** Başlamak için tek komut:

```
hazırla
```

Bir ajan aç (Claude Code · opencode · Codex) ve bu kelimeyi yaz.

---

## Ne işe yarar?

| | |
|---|---|
| **Sen** | Kararlarını, tercihlerini, proje geçmişini bir yere yazarsın |
| **Kod ajanı** | O kararları **okur** → aynı hatayı tekrar yapmaz |
| **Kütüphaneci ajan** | Ham belgelerini işler, wiki'ye yazar |
| **Tatmin sinyali** | *"çok uzun"*, *"bunu yapma"* gibi tepkilerin **yasak listesine** dönüşür |

> ⭐ **Temel fikir:** bir ajanın hafızası oturumla birlikte biter.
> Bu vault'ta kararlar **diskte** durur. Ajan değişir, hafıza kalır.

## ⭐ Kurulum (3 adım)

### 1) Klasörü aç

Bu klasör senin vault'un. Nereye koyacağın sana kalmış — ama içinde
**mutlak yol** geçen dosyalar olduğu için sonradan taşımak
`hazırla` komutunun ADIM 0'ını tekrarlamayı gerektirir.

### 2) Ajanı başlat

```
cd <bu klasör>
claude      # ya da: codex / opencode / cursor
```

### 3) Tek komut

```
hazırla
```

Ajan anayasayı okur, sana **7 soru** sorar, `profile/` klasörünü senin
cevaplarınla doldurur. Bitti.

**Doğrulama:**
```powershell
pwsh -NoProfile -File tools\vault-baslangic-dogrula.ps1
```

---

## Günlük kullanım

| Ne yapmak istiyorum | Komut / dosya |
|---|---|
| ⭐ **Vault'u kurmak (bir kez)** | `hazırla` |
| ⭐ **Yeni proje bağlamak** | `pwsh -NoProfile -File tools\proje-init.ps1 -Repo "<proje klasörü>"` |
| ⭐ **Belge ekleyip işletmek** | `raw/` altına koy → `RAW_ISLEM_PROMPT.md` |
| **Sohbet tepkim kaydetmek** | `raw/chats/<ajtör>/` + `raw/chats/_SABLON/chat-sablonu.md` |
| **Ne olduğunu öğrenmek** | `log.md` (son 15 satır) |
| **Konsistenslik kontrolü** | `lint-report.md` |
| **Gizli bilgi şifrelemek** | `tools/secret-vault/` |
| **Sana ne olduğu** | `profile/reactions.md` ⭐ |

> ⭐ **Ajan adı verirsen** (`hazırla` sırasında sorulur) sonraki oturumlarda
> sadece o adı yazman yeterli — ajan kaldığı yerden devam eder.

## ⭐ Kurallar nerede?

| Dosya | Ne |
|---|---|
| `CLAUDE.md` = `AGENTS.md` | ⭐ **anayasa** — her ajan için bağlayıcı |
| `DEV_BRIEF.md` | kod ajanının profil brifi |
| `profile/reactions.md` | ⭐ **yasak listesi** — neyi reddettiğin |
| `MANUEL.md` | senin için: dosya nereye gider? |

> ⛔ `AGENTS.md` ve `CLAUDE.md` **birebir aynıdır** — farklı ajan araçları
> farklı adı arar. Ayrı tutulursar biri bayatlar.

## ⭐ Temel kurallar (3 madde)

1. **`raw/` dokunulmaz.** Sen eklersin, ajan okur. Dışarıdan dosya lazım
   olursa **önce `raw/`'a kopyala.**
2. **Kod ajanı vault'a yazmaz.** Tek yazma hedefi proje kökündeki
   `knowledge-base.md`.
3. **Sayfa silinmez.** Emekliye ayrılır → `archive/`. Çelişki silinmez,
   `## ÇELİŞKİ` başlığıyla **görünür** olur.

## Yapı

```
CLAUDE.md / AGENTS.md   anayasa          raw/            dokunulmaz ham kaynak
HAZIRLA.md              tek komut        sources/        kaynak özetleri
DEV_BRIEF.md            ajan brifi       entities/       kişiler, araçlar, şirketler
MANUEL.md               senin rehberin   concepts/       kavramlar
profile/                seni tanıma      projects/<proje>/   her proje izole
index.md                katalog          global/         çapraz ağ (sadece pointer)
ingest-manifest.md      ham kaynak takibi network.md      karar etki haritası
log.md                  olay kaydı       tools/          scriptler
```

## ⭐ Bilinçli olarak dışarıda tutulanlar

Kimlik no · adres · telefon · IBAN · kart/TC/vergi no · sağlık kaydı ·
parola · API anahtarı.

Bunlar `raw/`'a **şifreli** yazılır (`tools/secret-vault/`), wiki
katmanlarına **hiç** taşınmaz.

## Git

Bu klasör bir git reposudur. Ajan **commit atmaz** — değişikliği gösterir,
kararı sen verirsin.

```powershell
git status
git add -A
git commit -m "..."
```

## Related
- `NASIL_KULLANILIR.md` — ⭐ adım adım rehber
- `HAZIRLA.md` — ⭐ başlangıç
- `MANUEL.md` — ayrıntılı rehber
- `CLAUDE.md` — anayasa