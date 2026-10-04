# MANUEL — Vault Nasıl Kullanılır

> **Bu dosya, bu vault'u ilk kez açan biri için yazıldı.** Kod bilmene
> gerek yok. Sadece dosya düzenini ve "ne nereye yazılır" sorusunun
> cevabını bilmen yeterli.
>
> Kuralların **dayanağı** `CLAUDE.md`; ajanların **ne okuduğu**
> `CODING_AGENT_PROMPT.md`. Bu manuel ikisini de *pratik* hale getirir.

---

# 0. Bu vault ne işe yarıyor?

Soru: "6 ay önce neden `services/` yerine `service/` yazdım?"

Cevap: bu vault'ta o bilgi yoksa **yoktur**. Çünkü burada her şey ya
yazılıdır ya da hiç yazılmamıştır — **tahmin edilmez**.

Üç tür yazı vardır:

| Tür | Örnek | Nereden gelir |
|---|---|---|
| **Bilgi** | "Spring Boot 3 kullanıyoruz" | `sources/`, `entities/`, `concepts/` |
| **Karar** | "neden PostgreSQL seçtik" | `projects/*/decisions/` |
| **Sen** | "kısa olsun", "şunu istemiyorum" | `profile/` |

Sonuncusu en kıymetli ve en zor kazanılanıdır. Chat'lerden çıkarılır.

---

# 1. 60 saniyede harita

```
vault/
├── MANUEL.md                ← BU DOSYA
├── CLAUDE.md                ← anayasa. AJANLAR okur, sen okumak zorunda değilsin
├── AGENTS.md                ← CLAUDE.md'nin aynısı (kopya)
│
├── index.md                 ← içindekiler
├── ingest-manifest.md      ← hangi ham kaynaklar işlendi  ⭐
├── log.md                   ← ne oldu, ne zaman
├── network.md               ← projeler arası kararlar haritası
│
├── profile/                 ← "SEN" kimsin
│   ├── user.md              ← rolün, alanların, sabit tercihlerin
│   ├── preferences.md       ← nasıl çalışmak istiyorsun
│   ├── reactions.md         ← neye TEPKİ veriyorsun  ⭐
│   └── patterns.md          ← ajanın sezdiği örüntüler
│
├── raw/                     ← DOKUNULMAZ. Sadece buraya eklersin
│   ├── knowhow/             ← senin notların
│   ├── projects/<proje>/    ← projeye ait belgelerin (sen eklersin)
│   ├── chats/<ajtör>/       ← sohbet tepkilerin  ⭐
│   └── agent-output/        ← AJANLAR yazar
│
├── projects/                ← her proje ayrı
│   ├── <proje>/
│   │   ├── PROJECT.md       ← "bu proje ne" (tek bakışta)
│   │   ├── architecture.md  ← "nasıl kuruluyor"
│   │   ├── decisions/       ← "neler karar verildi"
│   │   └── log.md           ← "bu projede ne oldu"
│   ├── _STANDARTLAR/        ← HER projeye geçerli kurallar  ⭐
│   └── _TEMPLATE_PROJECT/   ← yeni proje şablonu
│
├── sources/                 ← kaynak özetleri (dünya bilgisi)
├── entities/                ← kişiler, araçlar, şirketler
├── concepts/                ← kavramlar (CQRS, MCP, OCAI...)
├── global/                  ← projeler arası ağ (sadece pointer)
└── archive/                 ← emekliye ayrılmış (asla silinmez)
```

## ⭐ = en çok ihtiyacın olan 4 yol

| Ne yapacaksın | Git |
|---|---|
| **Yeni projeye başlıyorum** | [[#4b. ⭐ Proje yaşam döngüsü — ⭐ TEK KOMUT]] ⭐ · tek komut + 14 kontrol |
| ⭐ **Belge ekledim, AI'ya işlet** | [[#İş 3 — `raw/`'daki belgeleri işletmek ⭐]] |
| Kod ajanı çalıştırmak (otomatik) | [[#İş 5 — Kod ajanı çalıştırmak (otomatik) ⭐]] |
| Sohbet tepkim eklemek | [[#İş 2 — Sohbet tepkim eklemek istiyorum ⭐]] |
| Genel Kütüphaneci (bakım · sorgu) | [[#İş 3b — Genel Kütüphaneci (tüm işler)]] |

---

# 2. Altın kurallar (5 madde, ihlal etme)

## Kural 1 — `raw/` dokunulmaz

**Ne yaparsan yap, `raw/` altındaki bir dosyayı düzenleme veya silme.**

Neden: oradaki her şey senin **ham malzemen**. Ajan onu özetler, senin
kendi kaydın bozulmaz. Bir notu düzeltmek istersen → yeni not ekle.

Bu kural `raw/knowhow/` altındaki **494 dosyanın sıfır değişiklikle**
ayakta kalmasını sağladı. Bir ajan oraya yazsaydı, kimse neyi ne zaman
değiştirdiğini bilemezdi.

> ⭐ **"Dokunulmadı" sözle değil, kanıtla sabitlenir.** Ajan işini
> bitirince `raw/`'ın **parmak izini** karşılaştırır:
>
> | Rapor | Anlamı |
> |---|---|
> | `raw/ dokunulmadı` | ✅ Size ait belgelere dokunulmamış |
> | `raw/ dokunulmadı (yeni ekleme var)` | ✅ Siz `raw/`'a yeni belge eklemişsiniz — normal |
> | `⛔ raw/ DEĞİŞMİŞ` | ⛔ Ajan bir ham dosyayı **değiştirmiş veya silmiş.** **Ajanı durdurun**, bana bildirin. |
>
> → [[RAW_ISLEM_PROMPT]] §ADIM 0 ve §ADIM 5

## Kural 2 — Gizli bilgi **şifreli** saklanır

> ⚠️ **2026-09-28'de değişti.** Eski kural: *"gizli bilgi hiç taşınmaz"*.
> Bu artık **geçersiz** — `raw-gizli-veri-kopyalanmaz` kararı **superseded**.
> Yeni kural: [[projects/_STANDARTLAR/decisions/gizli-bilgi-sifreli-saklanir]]

Parola, token, API anahtarı, IBAN, kart no, TC no, kripto seed ifadesi,
Wi-Fi şifresi, tıbbi kayıt → **`sources/`, `entities/`, `concepts/`,
`global/` katmanlarına düz metin YAZILMAZ.** Yerine
**`_GIZLI/kayitlar/`** altında **şifrelenir** (AES-256-GCM + scrypt).

```
Gizli bir şey buldun        →  1. python tools/secret-vault/secretvault.py add
                                     (parola sorar, şifreler, INDEX'e yazar)
Gizli bir şey lazım        →  2. python tools/secret-vault/secretvault.py blob <slug>
                                     (şifreli metni verir, SENİN parolanı çözmez)
Grafik arayüzle çöz         →  3. python tools/secret-vault/ac.py
                                     (yapıştır → çöz → 30 sn'de otomatik sil)
```

| Serbest okunur | Yasak |
|---|---|
| `_GIZLI/INDEX.md` — hangi sır var, ne için | Şifreli metni **çözüp** yazmak |
| Slug / tür / amaç | Parolayı istemek, tahmin etmek |

Ajan **şifreli metni çözemez** ve istemez — sen çözersin, şifreli hâli
kullanırsın. Test sorusu: *bu cümle gizli bilgi olmadan anlamlı mı?*

> 🔐 `_GIZLI/` klasörü `raw/`'ın **DIŞINDA** — yani `raw/`'ı Google Drive'a
> senkronlarsan gizli bilgi gitmez. Ancak `_GIZLI/`'yi **ayrı** senkronlama.


## Kural 3 — Silme, taşı

Sayfa silinmez, `archive/`'a taşınır. Karar değişirse eskisi
`status: superseded` olur.

Neden: 2 yıl sonra "bunu neden yapmıştık?" sorusu her zaman gelir.

## Kural 4 — Çelişkiyi silme, işaretle

İki sayfa birbirini tutmuyorsa → `## ÇELİŞKİ` başlığı ekle, ikisini de bırak.

Neden: çelişki genellikle **"aklımdan çıkmış bir şey"** demektir. Silmek
o hatırayı de siler.

## Kural 5 — Kaynaksız iddia yok

Her önemli cümle bir `source:` referansı taşır.

Neden: vault'a **senin** söylemediğin bir şey girdiyse, o artık
"senin tercihin" gibi görünür. Bu en tehlikeli hatadır.

---

# 3. Ne nereye yazılır? (En önemli tablo)

Bu tabloyu ezberleme, bak.

| Senin eklediğin şey | Nereye | Neden |
|---|---|---|
| Genel bilgi, not, tarif, link | `raw/knowhow/` | Kişisel bilgi deposu |
| Bir **projeye** ait belge (spec, PRD, ekran görüntüsü) | `raw/projects/<proje>/` | Projeye bağlanır, projeye özetlenir |
| **Sohbet tepkin** (beğendim / değiştir / istemedim) | `raw/chats/<ajtör>/TARIH-konu.md` | `reactions.md`'ye işlenir ⭐ |
| Karar (bir kod ajanına değil, **senin** kararın) | `projects/<proje>/decisions/` | Kalıcı karar |
| Hiçbir şey değişmiyorsa | — | Vault'a yazma |

| Ajanın eklediği şey | Nereye |
|---|---|
| Kod ajanının hata + karar kaydı | ⚠️ **repo kökündeki `knowledge-base.md`** (vault'a değil) |
| Kütüphaneci'nin çıktısı | `sources/`, `entities/`, `concepts/`, `profile/`, `projects/*/decisions/`, `raw/agent-output/` |

**Kural cümlesi (2026-09-29):** ⛔ *Kod ajanı vault'a **yazmaz** — tek
hedefi proje dizinindeki `knowledge-base.md`'dir. Vault onun için
**okunacak** bir hafızadır.* `projects/`, `sources/`, `entities/`,
`concepts/` katmanlarına **elle dokunma** — Kütüphaneci içindir.

---

# 4. Günlük işler — adım adım

## İş 1 — Bir belge / not ekliyorum

1. Ne olduğunu düşün: genel mi, projeye mi ait?
2. Genel → `raw/knowhow/`'a kopyala. Projeye ait →
   `raw/projects/<proje>/` altına kopyala.
3. **Gizli bilgi var mı kontrol et** (Kural 2).
4. Dosya adını anlaşılır koy: `2026-09-28-sprint-boot-migration.docx`
5. Bitti. Kütüphaneci'nin bir sonraki oturumunda işler.

> Aynı belgeyi iki yere koyma. Bir yere koy.

## İş 2 — Sohbet tepkim eklemek istiyorum ⭐

Bu, seni tanımayı sağlayan akış. Kod ajanları bunu okur.

1. `raw/chats/_SABLON/chat-sablonu.md` dosyasını aç, kopyala.
2. Şu adla kaydet: `raw/chats/opencode/2026-09-28-<konu>.md`
   (ajtör: `opencode` · `claude` · `chatgpt` · `diger`)
3. Frontmatter'da **`cwd:`** alanını doldur — hangi klasörde konuştuysan.
   Bu otomatik olarak projeye bağlanır.
4. Konuşmayı yaz. **Kritik:** kendi mesajlarını `<siz>` ile, asistanın
   cevaplarını `<asistan>` ile işaretle.

```markdown
<siz>
Aşırı detaylı oldu, özetle.
</siz>
```

5. **Tepkiyi açıkça yaz.** "Güzel" demek yeterli değil:
   - `"Aynen böyle olsun"` → onay
   - `"Çok uzun, özetle"` → değiştir + uzunluk
   - `"Bunu istemiyorum"` → ret
6. Kendi sorunu cevapla: *"Bu sohbette bir şeyi beğendim mi, değiştirmek
   istedim mi, istemedim mi?"* Hepsi hayırsa **kaydetme**.

> **Neden `<siz>` etiketi şart?** Çünkü asistan yanlış şeyleri emin
> söyleyebilir. Etiketsiz metin "senin söylemediğin bir şey" sayılır ve
> **atlanır**. Bu olmadan özellik zarar verir.

## İş 3 — `raw/`'daki belgeleri işletmek ⭐

> **Ne yapmak istediğiniz:** `raw/` altına belge koydunuz, bir AI'ın onları
> değerlendirip wiki'ye işlemesini istiyorsunuz.

### Adım 1 — Komutu kullanın ⭐

Vault yolu **prompt'un içine zaten yazılı.** Değiştirmeniz gerekmiyor.

**A) CLI ajanınız varsa (Claude Code, opencode, Codex…) — en kolay:**

```
<VAULT_YOLU>\RAW_ISLEM_PROMPT.md dosyasını oku.
" Kopyalanacak blok " altındaki talimatların tamamını uygula.
```

> Ajan dosyayı kendisi okur. Yapıştırma bile gerekmez.

> ⚠️ **Daha önce çalıştırdıysanız:** dosya değiştiyse ajan eskisini
> kullanır. *"YENİDEN oku"* deyin:
> ```
> <VAULT_YOLU>\RAW_ISLEM_PROMPT.md dosyasını
> YENİDEN oku (değişti). " Kopyalanacak blok "u uygula.
> ```

**B) Pano yöntemi — dosyayı açmadan:**

```powershell
$p = '<VAULT_YOLU>\RAW_ISLEM_PROMPT.md'
$t = Get-Content $p -Raw -Encoding UTF8
$i = $t.IndexOf('````'); $j = $t.IndexOf('````', $i+4)
Set-Clipboard -Value $t.Substring($i+4, $j-$i-4).Trim()
```

Sonra CLI'da `Ctrl+V` / `Cmd+V`.

**C) Doğrudan ajana besleyin:**

```powershell
Get-Clipboard | claude        # veya: opencode · codex · aider
```

**D) Web sohbeti (dosya erişimi yok) — siz kopyalayın:**

`RAW_ISLEM_PROMPT.md` dosyasını açın → **Kopyalanacak blok** bölümünü seç →
kopyalayıp yapıştırın. Bu blok ~**12.000 karakter**; sohbet penceresine sığar.

### Adım 2 — Onaylayın

Ajan dosyaları okur, işin sonunda **tek seferde** özetleri gösterir ve
`evet / hayır` diye sorar. Onaylamadıkça hiçbir şey yazılmaz.

> ⓘ Ajan **menü açmaz.** "Hangi klasöre yazayım?", "profil adayını ekleyeyim
> mi?" gibi süreç soruları kural gereği yasak — cevabı zaten bilir ve
> sormadan ilerler.
>
> ⭐ Tek istisna: kaynak mevcut bir kararı **çürütüyorsa** ajan **sorar**
> (karar sizin). Örnek: *"belge Boot 4 diyor, vault'ta Boot 3 kararı var —
> hangisi?"*

### Adım 3 — İki şeyi kontrol edin

| Kontrol | Doğru olan | Sorunlu |
|---|---|---|
| **İş yapıldı mı?** | Ajan `infos/` gibi klasörleri listeledi | *"Yeni dosya bulunamadı"* dediyse → ⛔ bana bildirin, prompt'ta hata var |
| **`raw/` korundu mu?** | `raw/ dokunulmadı` | `⛔ raw/ DEĞİŞMİŞ` → ajanı durdurun |

> ⓘ Parmak izi **yalnız** kanıtlama içindir. "Hangi dosya yeni?" sorusunu
> `ingest-manifest.md` cevaplar — parmak izi **değil.**

### ⓘ Sık yapılan 3 hata

| Hata | Sonuç | Doğrusu |
|---|---|---|
| Sadece *"şu klasörü işle"* yazmak | Ajan kendi kuralını uydurur | Prompt'un **tamamını** kullanın |
| ⛔ Aynı oturumda tekrar çalıştırmak | Eski dosyayı kullanır, işi yapmaz | *"YENİDEN oku"* deyin |
| Yapıştırırken **eksik** bırakmak | Kurallar bozulur | Tamamını seçin (~12.000 karakter) |

> 💡 **Hiç prompt yazmak zorunda değilsiniz.** `raw/`'a belge koyup
> Adım 1'deki **komutu** kullanmak yeterli — ajan kuralı, sırayı ve
> kanıtlamayı kendisi yapar.

---

## İş 3b — Genel Kütüphaneci (tüm işler)

Sadece `raw/` değil, **haftalık bakım · sorgu · kod ajanı raporu
entegrasyonu** gibi tüm işler için:

1. `LIBRARIAN_AGENT_PROMPT.md` dosyasını açın.
2. Ortadaki kopyalanacak bloğu kopyalayın.
3. `<VAULT_YOLU>` → `<VAULT_YOLU>`
4. Yapıştırın.

> ⭐ **Hangisini kullanacağım?** Yalnız belge mi eklediniz → **İş 3**.
> Başka bir şey de yapılacaksa → **İş 3b**.

**Ne yapar:** yeni ham kaynakları `sources/`'a özetler, `profile/`'ı
günceller, kod ajanı raporlarını projelere entegre eder, kararları
`decisions/`'e taşır, `log.md`'ye yazar.

> ⛔ **Artık olmayan bir şey:** Kod ajanları `raw/agent-output/`'a rapor
> bırakmaz. Tek yazma hedefleri kendi projelerindeki `knowledge-base.md`'dir.
> → [[global/decisions/kod-ajani-vaulta-yazmaz]]

## İş 4 — Kod ajanı çalıştırmak (elle)

1. Kod projenin klasörüne gir (ör. `C:\devtools\Projects\ornek-proje`).
2. Ajan oturumu aç.
3. `CODING_AGENT_PROMPT.md` dosyasını aç, içindeki kod bloğunu kopyala.
4. İki yeri doldur:
   ```
   <VAULT_YOLU>  →  <VAULT_YOLU>
   {{PROJE_SLUG}}  →  ornek-proje
   ```
5. Yapıştır, çalıştır.

## İş 5 — Kod ajanı çalıştırmak (otomatik) ⭐

Bir kez yapılır, sonra hiç yapıştırma.

1. `REPO_ROOT_AGENTS_STUB.md` dosyasını aç.
2. İçindeki kod bloğunu kopyala.
3. `<VAULT_YOLU>` ve `{{PROJE_SLUG}}` alanlarını doldur.
4. Kod reposunun köküne `AGENTS.md` adıyla kaydet:
   ```
   C:\devtools\Projects\ornek-proje\AGENTS.md
   ```
5. Artık o klasörde açtığın **her ajan** otomatik okur.

Birden fazla kod projen varsa **her birine ayrı kopya** koy —
`{{PROJE_SLUG}}` farklı olur, `<VAULT_YOLU>` aynı kalır.

> Antigravity kullanıyorsan aynı içerikle bir `GEMINI.md` de koy —
> önce onu okur.

## ⭐ İş 6 — Yeni projeye başlarken

> ⭐ **Tam akış için → [[#4b. ⭐ Proje yaşam döngüsü — ⭐ TEK KOMUT]]**
> (tek komut + doğrulama + günlük kullanım)

Kısaca:

```powershell
pwsh -NoProfile -File tools\proje-init.ps1 -Repo "C:\devtools\Projects\yeni-proje"
```

| # | Ne | Kime |
|---|---|---|
| 1️⃣ | `tools\proje-init.ps1` → repo 3 dosya + vault + 4 kayıt | **script** (senin çağırdığın) |
| 2️⃣ | aynı script içinde → 14 kontrol + `raw/` kanıtı | doğrulama |

⭐ **Tek komut.** Önceden iki ayrı komuttu. ⛔ *"Kod ajanı vault'a yazamaz"*
kuralı bozulmuyor — **yazan script, ajan değil**
([[global/decisions/kod-ajani-vaulta-yazmaz]]).

# Geliştirici Belleği (ZORUNLU ÖN OKUMA — kod yazmadan önce)

- **Bu geliştiricinin profili:** `DEV_BRIEF.md` (repo kökü) — mutlaka oku.
  Çalışma tarzı, karar prensipleri, **kanıtlı precedent kütüphanesi**, YAPMA listesi.
- **Ne zaman:** her görev başında, kod yazmadan önce. Ayrıntı gerektiğinde
  vault'a git: `<VAULT_YOLU>\`
- **Öncelik:** Bu dosyadaki kurallar geçerlidir. **Çelişmede bu dosya kazanır**
  (brif genel tercihtir, burası projeye özeldir). Brifte olmayan bilgiyi
  uydurma — sor.
- **ⓘ ZORUNLU VAULT ERİŞİMİ (brif §7):** Mimari karar · rol/yetki ·
  veri tabanı/şema · iş kuralı · çapraz proje kuralı konularında **karar
  vermeden önce** vault'taki dosyayı oku. Erişemiyorsan **açıkça söyle** ve sor.
- **✓ OKUMA KANITI (brif §8):** Her cevabının sonuna tek satır ekle —
  `Uyguladığım brif bölümleri: §3-B, §4` ve `Vault'tan okuduğum: <dosya> §<bölüm>`.
  **Yazamıyorsan brifi kullanmamışsın.**
- **📝 KB YAZMA ZORUNLULUĞU:** Çözdüğün her hatayı `knowledge-base.md`'ye yaz
  (Problem / Root Cause / Solution / Files Changed). **Bu dosyayı okuma, sadece
  yaz.** Aynı hatayı 2. kez bulursan tekrar yazma, terfi öner.
```

> ⚠️ **Neden EN ÜSTE?** Ajan önce en üstteki dosyayı okur. Injector'u sona
> eklersen, ajan kendi kurallarını okur ve brifi atlar.

### Kayıt (vault'a bildirme) — ✅ **otomatik, sen yapmazsın**

⭐ **Bu adımların hepsini `tools/proje-init.ps1` kendisi yapar.** Elle
ekleme — aynı kayıt ikinci kez düşer.

| # | İş | Nerede | Durum |
|---|---|---|---|
| 1 | Kurulum tablosuna satır ekle | `projects/_STANDARTLAR/DEV_BRIEF_YEREL_KOPYASI.md` | ✅ script |
| 2 | `index.md`'ye projeyi ekle | §Projeler | ✅ script |
| 3 | Ham klasörü kaydet | `ingest-manifest.md` Bölüm 1 (`🔄` = bekliyor) | ✅ script |
| 4 | Olayı logla | `log.md` → `## [tarih] schema-change \| ⭐ Yeni proje: <slug>` | ✅ script |
| 5 | Proje logunu aç | `projects/<slug>/log.md` | ✅ script |

> ⭐ Tekrar çalıştırırsan **ikinci kayıt düşmez** (idempotent) →
> `MANUEL.md` §4b *"Tekrar çalıştırırsan"*.

### Çalışırken (kurulumdan sonra)

1. Kod yazmadan önce **vault'u oku**
2. `DEV_BRIEF.md` §3 → aynı hatayı yapma
3. §7 konularına dokunuyorsan **vault'a git**
4. Her cevapta **okuma kanıtı** ver
5. İlk hatayı çözünce `knowledge-base.md`'ye yaz — **günlük değil, gerçek hata**
6. Kalıcı karar verdiysen aynı anda KB'ye `### Karar` yaz — bekleme
7. ⛔ Vault'a hiçbir şey yazma (oturum raporu da dahil)

### 📌 Sık yapılan hatalar

| Hata | Sonuç | Doğrusu |
|---|---|---|
| `_STANDARTLAR`'ı kopyalamak | iki gerçek kaynak | Kopyalama |
| `DEV_BRIEF.md`'yi koymayı unutmak | ajan seni tanımıyor | `proje-init.ps1` **kuruyor** — yine de kontrol et |
| Injector'u sona eklemek | ajan brifi atlar | **En üste** ekle |
| KB'ye günlük yazmak | terfi erken tetiklenir | sadece çözülmüş gerçek hatalar |
| `PUT`/`DELETE` kullanmak | standart ihlali | her mutasyon `POST` |
| fiziksel silme | standart ihlali | `status = DELETED` |

---

## İş 6b — Kod ajanı çalıştırmak (skill tabanlı projeler)

> 2026-09-28'de eklendi. Bazı projelerde kökte `AGENTS.md` **yoktur** ve
> ajan kuralı `.agent/AGENTS.md` + `.agents/skills/` içinden okur
> (ör. Ornek Online Sinav: backend `ornek-backend`, frontend `ornek-frontend`).
> Bu kalıbı kullanıyorsan:

1. `.agent/AGENTS.md` dosyasının **en üstüne** 3-5 satır ekle:
   ```
   ## Zorunlu Bellek Katmanı
   Bu geliştiricinin kararları ve çalışma prensipleri:
   <VAULT_YOLU>\DEV_BRIEF.md
   Kod yazmadan ÖNCE oku. Proje kuralları (bu dosya) önceliklidir.
   ```
2. `DEV_BRIEF.md`'yi de repo köküne kopyala.
3. Ajan `.agent/AGENTS.md`'yi okurken brife de uğrar.

**Neden ayrı isim:** `AGENTS.md` adı projelerde zaten kullanılıyor.
`DEV_BRIEF.md` hem karışmaz hem ajana "kurallarım" değil
"geliştiriciyi tanı" sinyali verir.

## İş 7 — Kod ajanı ne yaptı, kontrol ediyorum

⛔ **Kod ajanı vault'a yazmaz** (2026-09-29 kuralı). Onun çıktısı
**proje dizinindeki `knowledge-base.md`**'dir.

1. Proje reposundaki `knowledge-base.md`'ye git (salt okunur).
2. Ajanın verdiği **her karar** için `### Karar` + `### Karar Gerekçesi`
   bloğu vardır.
3. Çözülen **her hata** için `### Problem` + `### Root Cause` vardır.
4. Kütıphaneci oturumu bunları `projects/<proje>/decisions/`'e taşır —
   içeriğe dokunmadan. Gerekirse terfi de eder.

Senin işin: kaydı oku, **doğrula** (aşağıya bak), onayla veya
`staging/`'a at.

> ⓘ `raw/agent-output/` klasörü **Kütüphaneci'nindir**; ajan oraya
> dosya bırakmaz. Klasör boşsa normaldir.

---
# 4b. ⭐ Proje yaşam döngüsü — ⭐ TEK KOMUT

> **2026-10-01'de değişti.** Önceden **iki ayrı komut** + ayrı doğrulama
> gerekiyordu. Artık **tek komut** hepsini yapıyor ve **tek yerden
> doğruluyor.**
>
> ⛔ Neden hâlâ güvenli: yazan **ajan değil, script.** "Kod ajanı vault'a
> yazmaz" kuralı bozulmuyor.

---

## Tek komut

Boş proje klasörü aç, çalıştır:

```powershell
pwsh -NoProfile -File "<VAULT_YOLU>\tools\proje-init.ps1" `
  -Repo "C:\devtools\Projects\yeni-proje"
```

| | |
|---|---|
| **Ne yapar** | repo 3 dosya + vault klasörleri + 4 kayıt + doğrulama + `raw/` kanıtı |
| **Sana sorduğu tek şey** | stack (1–4) |
| **Kontrol** | **14** |
| **Süre** | ~2 saniye |

---

## Sana sorduğu tek soru

Klasör boş olduğu için stack'i kendisi göremez:

```
Bu proje hangi stack? (1 yazman yeterli)
  1) Java backend      — Java 21 · Spring Boot 4 · Maven
  2) React frontend    — React 18+ · Vite · npm
  3) Node backend      — Node · Prisma · PostgreSQL
  4) Başka / karma      — ne ise onu yaz
```

> ⭐ **Bu tek sorudur.** Kararları da sorar — **tek listeden**,
> `[x]` işaretli olanlar varsayılan gelir. Boş bırakırsan varsayılanı alır.

```
Bu projeye hangi standartlar geçerli? (1'den başlayarak virgulle yaz, boş = varsayılan)
  [x] 1) Kod ajanı vault'a yazmaz
  [x] 2) Frontend yığını React+Vite
  [x] 3) PostgreSQL tek veritabanı
  ...
```

---

## Ne yapar

```
┌─────────────────────────────────────────────────────────────┐
│  REPO TARAFI                     →  projeye yazılır          │
│    AGENTS.md          ← 9 adım okuma sırası + ⛔ yazma yönü │
│    DEV_BRIEF.md       ← senin profilin (vault kopyası)      │
│    knowledge-base.md  ← ⭐ ajanın TEK yazma hedefi          │
├─────────────────────────────────────────────────────────────┤
│  VAULT TARAFI                    →  vault'a yazılır          │
│    projects/<slug>/PROJECT.md · architecture.md · log.md    │
│    ⭐ projects/<slug>/decisions/index.md                    │
│      → "bu projeye hangi kararlar bağlı" — ajan 12 karar    │
│        okumak zorunda kalmaz                                  │
│    raw/projects/<slug>/          ← belgelerin geleceği yer   │
├─────────────────────────────────────────────────────────────┤
│  KAYIT                           →  4 dosya                  │
│    index.md · ingest-manifest.md · kurulum tablosu · log.md │
├─────────────────────────────────────────────────────────────┤
│  DOĞRULAMA                       →  14 kontrol + raw/ kanıtı │
└─────────────────────────────────────────────────────────────┘
```

### ⭐ Slug'ı sen doldurmazsın — **camelCase**

Klasör adından **türetilir** ve **camelCase** olur:

| Repo klasörü | Vault slug'ı |
|---|---|
| `SecondBrainVaultMCP` | `secondBrainVaultMCP` |
| `MyCoolApp` | `myCoolApp` |
| `MyFileSystemMCP` | `myFileSystemMCP` |

> ⭐ **Slug ile repo adı birebir örtüşür** (ilk harf hariç). Kebab-case
> **DEĞİLDİR** — slug farklı görününce vault'ta iki isim yaşar ve ajan
> hangisini arayacağını bilmez.
> ⭐ **camelCase yalnız proje kimliği içindir.** Kaynak/kavram/karar
> `.md` dosyaları **kebab-case** kalır.
> → [[global/decisions/proje-isimlendirmesi-camelcase]]

### Yeni proje = Spring Boot 4

Stack 1 seçersen **Boot 4** gelir; mevcut projelerde **Boot 3** kalır.
→ [[global/decisions/spring-boot-3-kalir-boot-4-sart-ile]]

---

## Sadece doğrulamak (hiçbir şey yazmaz)

```powershell
pwsh -NoProfile -File "<VAULT_YOLU>\tools\proje-init.ps1" `
  -Repo "C:\devtools\Projects\yeni-proje" -SadeceDogrula
```

## Etkileşimsiz (CI / tekrarlı)

```powershell
pwsh -NoProfile -File tools\proje-init.ps1 -Repo "..." -Stack 2 `
  -Kararlar "frontend-stack-react-vite,kod-ajani-vaulta-yazmaz"

pwsh -NoProfile -File tools\proje-init.ps1 -Repo "..." -Stack 4 `
  -StackAdi "D3.js + SQLite" -OnayGec
```

| Parametre | İşe yarar |
|---|---|
| `-Repo` | proje klasörü (**zorunlu**) |
| `-Stack` | 1–4 · yoksa sorar |
| `-StackAdi` | 4 için serbest metin |
| `-Kararlar` | virgüllü karar slug listesi |
| `-OnayGec` | karar listesini geç, varsayılanı al |
| `-SadeceDogrula` | hiçbir şey yazma |

---

## ⭐ Tekrar çalıştırırsan

**Güvenli.** 3 kez üst üste çalıştırıldı — hiçbir yere ikinci kayıt düşmüyor:

| Dosya | 3 çalıştırma sonrası |
|---|---|
| `AGENTS.md` | korunur (üstüne yazılmaz) |
| `index.md` | **1** satır |
| `ingest-manifest.md` | **1** satır |
| kurulum tablosu | **1** satır |
| `log.md` | **1** giriş |
| `raw/projects/<slug>/` | **0** dosya |

Zaten bağlı bir projeyi verirsen **onay ister**, sonra hiçbir mevcut
dosyaya dokunmaz.

---

## Doğrulama neye bakar

| ✅ yeşil | ⛔ kırmızı |
|---|---|
| 3 repo dosyası kuruldu mu | `knowledge-base.md` yok |
| Injector **1 kopya** mı | İki kez yazılmış |
| ⛔ *"vault'a yazma"* kuralı var mı | Kural yok — ajan vault'a yazabilir |
| Karar kaydı formatı tanmıklı mı | Yalnız hata yazar |
| `decisions/index.md` dolu mu | Karar listesi boş |
| `index.md` + manifest + kurulum tablosu | Bir kayıt eksik |

> ⭐ `manifest` kontrolü **2026-10-01'de eklendi.** Script manifest'e
> yazamadığı halde doğrulama **13/13 yeşil** veriyordu — yanlış yeşil.
> Bu yüzden 13 değil **14**.

---

## ⛔ `.vaultignore` — bazı şeyler HİÇ işlenmez

`.gitignore`'ın **sorduğu farklı bir soru** var:

| Dosya | Soru | Cevap "hayır" ise |
|---|---|---|
| `.gitignore` | commit **edilsin mi**? | git'e girmez |
| ⭐ `.vaultignore` | **açılıp okunacak mı**? | hiç işlenmez |

İçeriği `raw/` altında **sayılır, parmak izine girer** ama
**asla açılmaz.**

```powershell
pwsh -NoProfile -File tools\vaultignore-dogrula.ps1
```

Şu an **14 kural · 73 dosya** kapsıyor (60 `.git/` + 13 medya):

| Kural | Neden |
|---|---|
| `**/.git/**` | ⭐ 60 dosya. Gizli veri taramasında **16 yanlış alarm** üretiyordu (git SHA-1) |
| `**/node_modules/**` · `dist` · `build` · `target` | Yeniden üretilebilir — bugün 0, ama **önleyici** |
| `**/*.jpg` · `png` · `mp4` … | 13 dosya. Not eki; metni zaten `.json` karşılığında |

> ⚠️ **Bu bir kör nokta riskidir.** Bu yüzden **her kuralın gerekçesi
> zorunlu** (`# gerekçe:`) ve gerekçesiz kural doğrulama **reddeder**.
> ⛔ *"İlgimi çekmiyor"* gerekçe **değildir**. `raw/chats/` ve
> `raw/knowhow/Keep/` **asla** buraya girmez — doğrulama bunu denetler.

---

## 📅 Günlük kullanım — kurulumdan sonra

Artık **başka komut yok.** Proje kendi kendine çalışır.

## Kod ajanı otomatik yapar

| Ne | Nerede |
|---|---|
| ⭐ Vault okur | `CLAUDE.md` · `DEV_BRIEF §3` · `profile/` · `_STANDARTLAR` |
| ⭐ Hata + karar yazar | `knowledge-base.md` — **tek hedefi bu** |
| ⛔ Vault'a hiçbir şey | — |

> Kod ajanını **elle çalıştırmazsın** — `AGENTS.md` her oturumda kendini
> yükler. Sen sadece klasörde çalışırsın.

## Sen ne yaparsın

| | |
|---|---|
| Belge koyarsan | `raw/projects/<slug>/` altına → bana söyle |
| Soru sorarsan | ajan cevaplar, vault'a gider okur |
| Karar vermek istersen | ajan **sorar** (mevcut kararı çürütüyorsa) |

## Ben ne yaparım

| Ne | Ne zaman |
|---|---|
| `raw/`'daki belgeleri işler | istediğin zaman |
| ⭐ Ajanın KB'sini **terfi ettiririm** | KB büyünce → `DEV_BRIEF §3` (çapraz proje dersi) |
| Kararları taşırım | KB'den → `projects/<slug>/decisions/` |

### 📄 Belge eklediğinde

```
<VAULT_YOLU>\RAW_ISLEM_PROMPT.md dosyasını oku.
" Kopyalanacak blok " altındaki talimatların tamamını uygula.
```

> ⭐ Aynı komutu **başka bir AI ile** de deneyebilirsin — ⛔ vault'a
> yazmaz, `raw/`'a dokunmadığını **parmak iziyle kanıtlar.**

---

## ⚠️ Sık yapılan hatalar

| Hata | Sonuç |
|---|---|
| ⛔ Script'i **elle düzenlemek** | Ajan çalışmaz — script'i güncelle |
| Slug için **elle uydurmak** | Klasör adından türetilir |
| Stack'i **tahmin etmek** | Yanlış kurallar yazılır |
| `AGENTS.md`'yi **sona** eklemek | Ajan önce kendi kurallarını okur, brifi atlar |
| `knowledge-base.md`'ye **günlük** yazmak | Terfi döngüsü erken tetiklenir |
| `-SadeceDogrula`'yı atlama | ⭐ Yeşil yanlış olabilir — script çalıştır |

> ⛔ **Artık geçerli değil:** *"İki komutu tek komutta birleştirme"*
> hatası — `proje-init.ps1` tam olarak bunu yapar ve güvenli, çünkü
> **yazan script, ajan değil.**

---

## ⏳ Bekleyen

| Konu | Durum |
|---|---|
| `raw/chats/chatgpt/` | ⛔ 0 dosya — ekleyince işlenir |

---

## Related

- [[tools/proje-init.ps1]] — ⭐ tek komutun kendisi
- [[tools/proje-init-dogrula.ps1]] — 14 kontrol
- [[RAW_ISLEM_PROMPT]] — belge işletme prompt'u
- [[global/decisions/kod-ajani-vaulta-yazmaz]] — ⭐ neden yazan script
- [[global/decisions/spring-boot-3-kalir-boot-4-sart-ile]] — yeni proje = Boot 4
- [[global/decisions/frontend-stack-react-vite]] — yeni frontend = React + Vite
---
# 5. Ajanlar okurken ne görüyor (9 dosya)

Kod ajanı bir işe başlamadan önce **sırayla** şunları okur. Atlamaz.

| # | Dosya | Ne verir |
|---|---|---|
| 1 | `CLAUDE.md` | Bağlayıcı kurallar |
| 2 | `profile/preferences.md` | Nasıl çalışmak istiyorsun |
| 3 | `profile/reactions.md` | **Neye tepki verdiğin** ⭐ |
| 4 | `projects/_STANDARTLAR/` | Her projeye geçerli kurallar |
| 5 | `projects/<proje>/PROJECT.md` | Bu proje ne |
| 6 | `architecture.md` | Nasıl kuruluyor |
| 7 | `decisions/` (tümü) | Neler karar verildi |
| 8 | `log.md` (son satırlar) | Bu projede ne oldu |
| 9 | `sources/` (son 3-5) | Son eklenen kaynaklar |

**2 ve 3 birlikte okunur.** `preferences.md` *"kısa olsun"* der.
`reactions.md` *"şu raporda şunu yaptın, beğendim"* der — yani somut
vaka. Biri olmadan diğeri eksiktir.

Ajan kod yazmadan önce kararları **başlıklarıyla özetlemek** zorundadır.
Söylemezse "karar bulamadım" der — yani **uydurma karar uygulamaz.**

---

# 6. Sözlük

## Frontmatter alanları

| Alan | Değerler | Ne anlama gelir |
|---|---|---|
| `status` | `draft` · `reviewed` · `stale` | Kim onayladı? |
| `confidence` | `stated` | **Sen** söyledin — en güçlü |
| | `inferred` | Ajan çıkarımı, onaylanmadı |
| | `agent-generated-unreviewed` | Kod ajanı üretti, gözden geçirilmedi |
| `type` | `source` `entity` `concept` `decision` `project` `profile` | Sayfa türü |
| `project` | slug veya `global`/`personal` | Hangi projeye ait |
| `scope` | `project-only` · `cross-project` | Tek projeye mi, hepsine mi |
| `decided_by` | `user` · `code-agent` | Kararı kim verdi |

## Tepki sözlüğü (`reactions.md`)

| Tepki | Anlamı | Ajanın yapacağı |
|---|---|---|
| `onay` | beğendim, aynen kalsın | aynı kalıbı tekrarla |
| `degistir` | fikri iyi, şöyle olsun | verilen yönde revize et |
| `reddet` | istemiyorum | **bir daha tekrarlama** |
| `devam` | aynı yönde devam | genişlet |

| Boyut | Neyi ölçer |
|---|---|
| `icerik` | ne söylendi |
| `uslup` | nasıl söylendi |
| `uzunluk` | ne kadar |
| `yapi` | nasıl kurgulandı |
| `kapsam` | ne kadar derin |
| `hiz` | tempo |
| `gorsel` | görsel, renk, yerleşim |

---

# 7. Karar sistemi

## Karar nedir?

"X'i Y yaptık" cümleleri. Örnek: *"Controller'da iş mantığı yazmayacağız."*

## Nerede durur?

```
projects/<proje>/decisions/<slug>.md        ← ASIL karar (tek doğruluk kaynağı)
global/decisions/<slug>.md                 ← sadece POINTER (tek satır)
network.md                                 ← harita: hangi karar hangi projeleri etkiliyor
```

**Neden iki yerde?** İçeriği kopyalamak yanlış çünkü iki kopya zamanla
ayrışır. `global/` sadece "şu karar var" der, asıl içerik projede durur.

## Sahipsiz kararlar (hiçbir projeye ait değil)

AI kuralları, mimari sözleşmesi gibi her yere geçerli kararlar
`projects/_STANDARTLAR/decisions/` altında yaşar. Aynı pointer kuralı
geçerlidir.

## Karar değişirse

- **Yeni** karar dosyası aç
- Eski dosyaya `supersedes: <yeni-slug>` yaz
- Aynı dosyada `supersedes: <eski-slug>` yaz
- **Eskiyi silme.** Kütüphaneci `status: superseded` işaretler

---

# 8. Sık yapılan hatalar

Bu liste gerçekten olmuş hatalardan çıkarıldı.

| Hata | Sonuç | Doğrusu |
|---|---|---|
| Wiki katmanına parola yazdım | Gizli veri senkronize oldu | Kural 2 — servis adı yaz, parolayı yazma |
| `REPO_ROOT_AGENTS_STUB.md`'i kopyaladım, sonra güncellemedim | Ajan vault'u okudu ama **bellek biriktirmedi** | Stub'ı güncelle → `ingest-manifest.md` flag #7 |
| Kod ajanına `{{PROJE_SLUG}}` yazmayı unuttum | Yanlış projenin kararlarını okudu | 4. adımda doldur |
| `<siz>` etiketini atladım | Tepkilerin çoğu atlandı | İş 2, adım 4 |
| Belgeyi hem `raw/knowhow/` hem `raw/projects/x/`'e koydum | Aynı içerik iki yerde | Tek yere koy |
| Asistanın dediğini tercih sanıp yazdım | Vault, **senin söylemediğin** şeyi söylüyor gibi görünüyor | Yalnızca `<siz>` blokları kanıttır |
| Klasörü yeniden adlandırdım, linkleri güncellemedim | 17 dosyada kırık bağlantı | Taşıdıktan sonra `grep` ile kontrol |

---

# 9. Bakım

## Haftalık / aylık LINT

Ajan şunları kontrol eder ve `lint-report.md` yazar — **düzeltmez**:

- `network.md`'de görünmeyen cross-project karar var mı
- `ingest-manifest.md` ile `raw/`'ın gerçek durumu tutarlı mı
- `pending_review: true` rapor çok uzun bekliyor mu
- Kırık çift köşeli bağlantı referansı var mı
- Bu manuel gerçek yapıyla uyuşuyor mu

## Bu manuel bayatlar mı?

Bayatlayabilir. `REPO_ROOT_AGENTS_STUB.md` bayatladı (9/9 eksikti) ve
kimse fark etmedi — ta ki bir ajan okumaya çalışsam.

**Yapı değişirse bu dosyayı güncelle.** Yapı değiştiyse §1 (harita),
§3 (nereye yazılır) ve §5 (ajanların okuduğu dosyalar) etkilenir.

---

# 10. Hızlı sorular

| Soru | Cevap |
|---|---|
| Bu dosyayı silebilir miyim? | Hayır. Tüm kuralların dayanağı. |
| Kod ajanı neyi değiştirdi? | ⭐ Proje reposundaki **`knowledge-base.md`**'ye bak (vault'a yazmaz) |
| Bir ajan yanlış bir şey yazdı mı? | `git diff` ile kontrol et, düzelt, `log.md`'ye yaz |
| Ajan vault'a (`projects/`, `raw/`) yazarsa? | ⛔ **Normal değil.** Kural ihlali — `AGENTS.md`'yi kontrol et; ajanın tek hedefi `knowledge-base.md`'dir |
| Yeni not ekledim, hemen işlenir mi? | Hayır. Kütüphaneci'nin bir sonraki oturumunda |
| Chat'teki bilgi doğru mu? | Asistan mesajları kanıt değil. Sadece senin yazdıkların. |

---

## İlgili dosyalar

- `CLAUDE.md` — anayasa (kuralların tam metni)
- `ingest-manifest.md` — hangi ham kaynaklar işlendi
- `index.md` — içindekiler
- `log.md` — ne oldu
- `REPO_ROOT_AGENTS_STUB.md` — kod reposuna kopyalanacak şablon
- `LIBRARIAN_AGENT_PROMPT.md` · `CODING_AGENT_PROMPT.md` — ajan promptları
- [[profile/reactions]] · [[profile/preferences]] · [[profile/user]]
- [[concepts/tatmin-signali-islemi]] · [[concepts/kod-ajani-hafiza-protokolu]]
