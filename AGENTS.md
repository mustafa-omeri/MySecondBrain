---
name: second-brain-constitution
version: 1.0
updated: 2026-10-04
---

# CLAUDE.md — Bu Vault'un Anayasası

> ⭐ **Bu bir şablondur.** İçinde **kimsenin bilgisi yok.**
> İlk iş: `HAZIRLA.md` dosyasındaki `hazırla` komutunu çalıştır.
> O komut bu vault'u senin için kurar; sen de doldurursun.

Bu dosya, bu Obsidian vault'unu işleyen **HERHANGİ BİR AI ajanı** için
(Claude Code, Codex, opencode, bir IDE eklentisi, vs.) bağlayıcıdır.
`AGENTS.md` bu dosyanın birebir kopyasıdır — sadece farklı ajan araçlarının
varsayılan olarak aradığı dosya adını karşılamak için vardır. İkisi senkron
tutulur.

## 0) ZORUNLU OKUMA SIRASI (her oturumun ilk adımı)

Görev ne olursa olsun (ingest, query, lint, kod geliştirme, herhangi bir şey),
bir ajan bu vault'ta çalışmaya başlamadan önce SIRAYLA şunları okur:

1. **Bu dosya** (`CLAUDE.md`) — baştan sona.
2. `index.md` — vault'un içerik kataloğu.
3. **`ingest-manifest.md`** — hangi ham kaynak zaten işlendi. Ham kaynak
   taraması yapacaksan (ingest, lint) **bu dosyayı atlayarak tarama**.
4. `profile/user.md` ve `profile/preferences.md` — kullanıcıyı ve çalışma
   tarzını tanımak için. Ajan bu ikisini `[[profile/reactions.md]]` ile
   birlikte okur.
5. `log.md`'nin SON 10-15 satırı — yakın zamanda ne olmuş.
6. Eğer görev belirli bir projeyle ilgiliyse: önce
   `projects/<proje-adi>/PROJECT.md`, sonra
   **`projects/_STANDARTLAR/PROJECT.md`** (projeye ait olmayan ama her
   projeye uygulanan kurallar), sonra o projenin kendi `log.md`'sinin
   son satırları.

Bu sırayı atlayan bir ajan, önceden verilmiş kararları tekrar sorar veya
onlarla çelişir. Atlama.

## 1) Amaç

Bu vault iki şeyi aynı anda yapar:

- **Kişisel ikinci beyin**: senin hakkında, tercihlerinle, çalışma
  tarzınla, kararlarınla zamanla zenginleşen bir profil + genel bilgi arşivi.
- **Çoklu proje hafızası**: her biri kendi içinde izole, ama ortak/stratejik
  kararları paylaşlanan bir ağ üzerinden görünür kılan proje alanları. AI
  kod geliştirme ajanları buraya hızlıca girip proje bağlamını okur, iş
  bitince ürettiği dokümanı bu yapıya uygun şekilde bırakır.

Wiki'yi senin yerine bir "Kütüphaneci Ajan" yazar ve bakımını yapar. Sen
kaynak sağlarsın, soru sorarsın, kararları onaylarsın.

## 2) Roller

| Kim | Ne yapar |
|---|---|
| **Sen** | Kaynak/ham veri sağlarsın, projeleri başlatırsın, sorular sorarsın, `profile/user.md`'deki iddiaları onaylarsın. |
| **Kütüphaneci Ajan** (genel amaçlı) | `raw/` altındaki her şeyi işler, wiki'nin GERÇEK sahibi katmanına (sources, entities, concepts, decisions, global, profile) yazar. Tek yazar odur. ⛔ **Kod yazmaz, kod değiştirmez** — bkz. Bölüm 9 |
| **AI Kod Geliştirme Ajanı** (Claude Code, Codex, opencode, vs.) | Bir proje üzerinde çalışır. `projects/<proje>/` içindeki dosyaları HIZLICA okuyup bağlam alır. İş bitince wiki'nin ana katmanına DOĞRUDAN yazmaz — Vault'u **okur** (second brain) ve **proje dizinindeki `knowledge-base.md`'ye yazar** (hata + karar kaydı). ⛔ **Vault'a hiçbir şey yazmaz** (bkz. Bölüm 8). |
| **Sen (Kullanıcı)** | İki şey ekle: (a) belge → `raw/projects/<proje>/`, (b) **sohbet tepkisi** → `raw/chats/<ajtör>/` (şablon: `raw/chats/_SABLON/chat-sablonu.md`) |

## 3) Mimari (klasör ağacı)

```
vault/
├── CLAUDE.md / AGENTS.md   # bu dosya (anayasa)
├── HAZIRLA.md              # ⭐ "hazırla" komutu — ilk çalıştırma
├── index.md                # tüm vault'un içerik kataloğu
├── ingest-manifest.md      # hangi ham kaynaklar işlendi — ajan önce buraya bakar
├── log.md                  # global, append-only, zaman damgalı olay kaydı
├── network.md              # projeler-arası / stratejik karar haritası
│
├── profile/                  # "seni zamanla tanıma" katmanı
│   ├── user.md                 # doğrudan söylediğin kalıcı gerçekler
│   ├── preferences.md           # çalışma tarzı, araç/stack tercihleri
│   ├── reactions.md             # neye TEPKİ verdiğin (onay/ret) — YASAK LİSTESİ
│   └── patterns.md               # ajanın fark ettiği tekrarlayan örüntüler
│
├── raw/                        # DOKUNULMAZ ham kaynaklar — sadece sen eklersin
│   ├── inbox/                    # sınıflandırılmamış her şey önce buraya
│   ├── articles/, transcripts/     # genel/kişisel okuma malzemesi
│   ├── chats/<ajtör>/                # AI sohbet kayıtları — TEPKİ sinyali
│   ├── knowhow/                     # ÖZEL: seninle ilgili teknik know-how
│   ├── projects/<proje>/             # bir projeye ait belgeler (spec, not, karar)
│   └── agent-output/<proje>/          # ajan raporları (Kütüphaneci'nin katmanı)
│
├── staging/                     # işlenmeyi bekleyen taslaklar
│
├── sources/                     # proje-bağımsız, genel/kişisel kaynak özetleri
│
├── projects/<proje-adi>/          # HER PROJE İZOLE
│   ├── PROJECT.md                    # tek bakışta özet — kod ajanının okuyacağı İLK dosya
│   ├── architecture.md
│   ├── decisions/                     # projeye özel, atomik kararlar
│   ├── sources/                        # bu projeye ait ingest özetleri
│   └── log.md                           # projeye özel zaman çizelgesi
│
├── projects/_STANDARTLAR/       # SAHİPSİZ projeler arası kararların meta-projesi
│   ├── PROJECT.md                    # buradaki kurallar her projeye uygulanır
│   ├── decisions/                    # asıl karar sayfaları burada durur
│   └── log.md
│
├── global/                       # PROJELER ARASI ORTAK AĞ (sadece pointer + yeni sentez)
│   ├── decisions/                   # >1 projeyi etkileyen kararların POINTER'ı
│   ├── concepts/                     # projeler arası tekrar eden desenler
│   └── syntheses/                     # büyük resim, evrilen tezler
│
├── entities/                    # kişiler, araçlar, şirketler, servisler
├── concepts/                    # genel bilgi kavramları
└── archive/                     # emekliye ayrılmış sayfalar — ASLA silinmez
```

## 4) Sayfa Formatı (her wiki sayfası)

```yaml
---
title: <başlık>
type: source | entity | concept | decision | project | profile | synthesis
project: <proje-adi> | global | personal
status: draft | reviewed | stale | superseded
confidence: stated | inferred | agent-generated-unreviewed
created: YYYY-MM-DD
updated: YYYY-MM-DD
source: [[raw/dosya-yolu]]
tags: [...]
---

# <Başlık>

<içerik>

## Sources
- [[...]]

## Related
- [[...]]
```

> ⓘ **Bu şablon WIKI SAYFALARI içindir.** Operasyonel dosyalar
> (anayasa · katalog · kayıt defteri) frontmatter **taşımaz**:
> `CLAUDE.md` / `AGENTS.md` · `HAZIRLA.md` · `index.md` · `network.md` ·
> `ingest-manifest.md` · `log.md` · `MANUEL.md` · `DEV_BRIEF.md` ·
> `lint-report.md` · `raw/` altındaki her şey.

`confidence` alanı kritik: **stated** = sen veya bir ham kaynak doğrudan
söyledi. **inferred** = ajan örüntüden çıkardı, henüz onaylanmadı.
**agent-generated-unreviewed** = bir ajanın bıraktığı, henüz gözden
geçirilmemiş içerik. Sayfa gözden geçirilip doğrulanınca `status: reviewed`
olur.

## 5) Profil Katmanı — "Beni Zamanla Tanısın"

- `profile/user.md`: SADECE senin doğrudan söylediğin, kalıcı gerçekler.
  Kütüphaneci burayı **senin onayın olmadan** asla değiştirmez.
- `profile/preferences.md`: açıkça belirttiğin çalışma tarzı tercihleri.
- `profile/reactions.md`: **neye tepki verdiğin.** ⭐ `preferences.md` ne
  istediğini tutar; bu dosya hangi çıktıya onay verdiğini / neyi reddettiğini
  tutar. **Biri olmadan diğeri eksiktir.**
- `profile/patterns.md`: Kütüphaneci'nin fark ettiği TEKRARLAYAN örüntüler.
  Her satır tarihli ve `(inferred, YYYY-MM-DD)` etiketli. Bu dosyadaki hiçbir
  satır otomatik olarak `user.md`'ye terfi etmez — bir örüntü 3+ kez
  doğrulanırsa Kütüphaneci sana sorar. Onaylarsan taşınır ve `log.md`'ye
  yazılır.

Bu katman olmadan wiki sadece dış kaynakları biriktirir, **seni asla
öğrenmez** — bu yüzden en kritik ekle.

## 6) Proje İzolasyonu + Ortak Ağ

- Her proje kendi `projects/<proje>/` klasöründe YAŞAR: kendi kararları,
  kendi log'u, kendi kaynak özetleri. Bir projenin ajanı başka bir projenin
  klasörüne asla yazmaz.
- Karar SADECE o projeyi ilgilendiriyorsa → `projects/<proje>/decisions/`.
- Karar birden fazla projeyi etkiliyorsa veya stratejikse → frontmatter'a
  `scope: cross-project` eklenir, ASIL sayfa yine `projects/<proje>/decisions/`
  içinde kalır (tek doğruluk kaynağı), ve `global/decisions/` altına yalnız
  bir **pointer sayfası** (tek satır özet + geri link) düşer. İçerik
  çoğaltılmaz, sadece işaretlenir.
- `network.md`, tüm `scope: cross-project` kararların ve hangi projeleri
  etkilediklerinin canlı haritasıdır.
- Hiçbir projeden doğmayan, doğrudan stratejik/ortak kararlar
  `projects/_STANDARTLAR/decisions/` altında yaşar; aynı pointer kuralı
  burada da uygulanır.
- LINT, `cross-project` etiketli ama `network.md`'de görünmeyen kararları
  bulur ve raporlar.

## 7) Operasyonlar

### 7.0) Kaynak Nereye Gider? (Routing Tablosu)

> **⭐ Temel kural:** *İkinci beyin yalnızca `raw/` üzerinden ilerler.*
> Başka hiçbir yerden doğrudan içerik okunmaz.

**Neden:** `raw/` dışından çalışınca **provenance kaybolur** — hangi
dosyanın kopyasıydı, orijinali nerede, değişti mi bilinmez. Ayrıca **canlı
proje dosyalarına** müdahale etme riski doğar.

> ⚠️ **Bu tuzaktan bir kez yakalanıldı:** `ocai/src/main/resources/`
> altındaki dosya için işlem yapıldı, sonra *"silebilirsin"* denildi. O
> dosya **canlı yapılandırmadır** — silinseydi geliştirme ortamı kırılırdı.

**Kural:**

| | |
|---|---|
| **Okuma** | Yalnızca `raw/` altından. Dışarıdaki bir dosya lazımsa → **önce `raw/`'a kopyala**, sonra oradan oku |
| **Kopyalama** | `raw/` altına alırken **kendi kopyasını** oluşturur — orijinaline dokunmaz |
| **Silme** | ⛔ `raw/` dışında **hiçbir dosya silinmez** |
| **Canlı proje dosyası** | `.env` · `application-*.properties` · config · migration → **asla silinmez, asla düzenlenmez** |
| **Sır dosyası** | `raw/`'a alıp `_GIZLI/`'ye şifrelersin — **orijinali yerinde kalır** |

**Çelişki çözümü:** Aynı içeriğin `raw/` dışında bir kopyası varsa ve
`raw/`'da yoksa: 1. `raw/`'a kopyala → 2. Manifest Bölüm 1'e yaz →
3. **Orijinaline dokunma** 4. Kaynak yolu sayfada `source:` olarak belirt.

**Aşağıdaki routing tablosu yalnızca `raw/` altındaki kaynaklar için
geçerlidir.**

**ADIM 0 — ⭐ Kaynak `raw/` mı?** `raw/` altındaysa devam et. **Değilse
dur ve `raw/`'a kopyala.** Asla canlı bir proje dosyasını doğrudan okuyup
işleme.

**ADIM a — Ne zaten işlenmiş?** `ingest-manifest.md` §Bölüm 1'e bak.
Klasörün dosya sayısı ve en yeni kaydı değişmemişse → **tamamı
işlenmiştir, o klasöre tekrar bakma.** Değişmişse sadece **yeni olanları**
işle.

**ADIM a0 — `.vaultignore` var mı?** Ham kaynak taramaya geçmeden **önce**
`.vaultignore`'ı oku. Eşleşen yollar **hiç açılmaz**: sayılır (varlığı
bilinir) ama **içeriği okunmaz**, özetlenmez, taranmaz.

> ⭐ `.gitignore` ile **karıştırma**: `.gitignore` = *commit edilsin mi?*
> `.vaultignore` = *hiç açılıp okunacak mı?*

**ADIM b — Bu içerik nereye gider?** Aşağıdaki routing tablosuna bak.

**ADIM c — Kapanmamış mı?** İşledikten sonra `ingest-manifest.md`
§Bölüm 2'ye (flag) ve gerekiyorsa §Bölüm 3'e (karar) yaz, Bölüm 1'i
güncelle.

> **Teşhis kuralları:**
> - Sayı/tarih değişimini tespit edemiyorsan **"yok" deme, emin olma.**
>   Emin değilsen kullanıcıya sor.
> - Bir klasör `.gitkeep` dışında dosya içermiyorsa işlenmemiş sayılır.
> - Aynı dosya `.html` + `.json` ikilisi ise (Keep export'u) **tek kayıttır.**
>
> `raw/agent-output/` bu tabloda istisnadır: orada `pending_review: true`
> frontmatter'ı zaten bir işlenmemiş işaretidir, manifest'e gerek yoktur.

#### Routing Tablosu

| Ham dosya nerede | Özet nereye yazılır | Hangi akış |
|---|---|---|
| `raw/projects/<proje>/...` | `projects/<proje>/sources/` | INGEST — proje kaynağı |
| `raw/agent-output/<proje>/...` | `projects/<proje>/*` (entegre edilir, kopyalanmaz) | INGEST — agent-output |
| `raw/chats/<ajtör>/...` | **`profile/reactions.md`** + varsa `projects/<proje>/sources/` | INGEST — chat |
| `raw/knowhow/...` | `sources/` (özet) + **profil adayı** | INGEST — know-how |
| `raw/inbox/`, `raw/articles/`, `raw/transcripts/` | `sources/` + ilgili `entities/`/`concepts/` | INGEST — genel kaynak |

- ⭐ **`raw/` gizli kalıp taraması — ADIM b, "nereye gider"den ÖNCE**

  Bir ham kaynak dosyasını özetlemeden **önce** otomatik taramadan geçir.
  **Gözle arama yeterli değildir** — kanıt: bir turda 6 JWT yazıldı,
  tarama **7** çıkardı; iki tur PII dosya adından anlaşılmadı.

  Taranacak kalıplar (en az): `eyJ…` (JWT) · `["']password["']\s*:` ·
  `$2[aby]$` (bcrypt) · `\b[0-9a-fA-F]{32,}\b` (api key) ·
  `BEGIN … PRIVATE KEY` · `AKIA[0-9A-Z]{16}` (AWS) · `jdbc:`

  ⛔ **Bulunan değerler asla `sources/` `entities/` `concepts/` `global/`
  katmanına yazılmaz.** Yazılan yalnızca **satır no + tür** olur. ⛔ Değer
  `log.md`'ye de yazılmaz.

  Bulunan gizli veri **kalıcı bir sır değilse** (geliştirme token'ı gibi)
  `_GIZLI/` kası **gerekmez.**

- ⭐ **`raw/` projects/<proje>/ altında yanlış yere düşen dosya:** Kütüphaneci
  onu ilgili projeye özgü kabul edip `projects/<proje>/sources/` altına
  yazabilir — ama bunu ingest özetinde açıkça belirtir.
- **`raw/knowhow/` içeriği** her zaman `sources/` + profil adayı üretir.
  Toplu kaynaklarda her notu ayrı sayfalamak yerine **kategori bazlı kaynak
  sayfaları** açılır.

**⭐⭐ KEŞİF SIRASI + ZAMAN KONTROLÜ**

Bir konuda *"bulunamadı"* dendiğinde **şu sırayla** tara:

| # | Katman | Neden |
|---|---|---|
| 1 | `raw/` — ham kaynak | Metnin **ne dediği** buradadır |
| 2 | ⭐ `projects/*/decisions/` | **Cevap burada olabilir** |
| 3 | `log.md` · `sources/` | Daha önce **çözülmüş** olabilir |

> ⛔ **Yalnızca `raw/`'a bakmak kararı gözden kaçırır.**
> ⭐ **Aynı iş iki isimle konuşulmuş olabilir.** Yeni bir şey bulduğunda
> **önce `projects/` klasörlerini** kontrol et.

**Zaman kontrolü** — her bulguda kaynağın tarihini **bugünle** karşılaştır.
3 günlük bir hafıza kaydına *"yeni proje buldum"* demek **koptu** demektir.

> ⭐ ⭐ **Bir istisna unutma:** **"yok" bulguları da zaman damgalıdır.**
> 2026-09-29'da bir aracın deposu ölçüldü: *"neredeyse hiçbir şey yok,
> dönüştürücü betiği yazma."* ⛔ 5 gün sonra **tam tersi** doğru çıktı —
> araç **sürüm değiştirmişti.** Bayrak `✅` idi, gerçek bayat olmuştu.
> ⭐ Bir aracın "boş" bulgusu **araç sürümüyle birlikte** geçersiz olur.

#### ⭐ Değer kapısı — her şey işlenmez

> **Temel kural:** *eğer bilgi işlenmeye değer değilse işlemeyelim.
> kullanıcı bir dosya attı diye her bilgi kıymetli olmak zorunda değil.*
> *önemli değil demek kıymetlidir.*

**Test — en az biri doğruysa İŞLE:**

| # | Sinyal | Örnek |
|---|---|---|
| 1 | **Örüntü** — tekrar edebilir | "hep şunu tercih ediyorum" |
| 2 | **Karar / sonuç** — bir şey değiştirdi | "Bunu seçtim, şu sebeple" |
| 3 | **Sen** — kimlik, tercih, kariyer | "Java + Boot kullanıyorum" |
| 4 | **Bağlantı** — mevcut bir sayfaya değer katıyor | RFC, karar, hata kaydı |
| 5 | **Gelecek eylem** — ileride karar için gerek | "X ileride lazım olacak" |

**Test — hiçbiri doğru değilse İŞLEME, gerekçesini yaz:**

> ⓘ **Bu bir filtre değil, bir kayıt yükümlülüğüdür.** "Önemli değil"
> cevabı da `ingest-manifest.md`'ye yazılır — ⛔ **sessizce geçilmez.**

### INGEST — chat (`raw/chats/<ajtör>/`)

1. **Yalnızca `<siz>` bloklarını oku.** Asistan mesajları bağlamdır,
   **kanıt değildir.** Bkz. `concepts/tatmin-signali-islemi`.
2. Sözlüğe göre her tepkiyi sınıflandır:
   **valans** (`onay` / `degistir` / `reddet` / `devam`) ·
   **boyut** (`icerik` / `uslup` / `uzunluk` / `yapi` / `kapsam` / `hiz` /
   `gorsel`) · **genellik** (`genel` / `baglamli` / `proje`)
3. Aynı konuya ait **tekrar sayacını** artır. Silme — sayaç büyür.
4. Yerleştir:
   - `reddet` → `profile/reactions.md` §**Ret edilenler** (yasak listesi)
   - ilk kez görülen `onay`/`degistir`/`devam` → §**Tek seferlik sinyaller**
   - **3+ aynı tepki** → §**Tekrarlayan tepkiler**
   - **3+ `onay`** → §**Onaylanmış kalıplar**
5. Chat içinde **dünya bilgisi** de varsa → ilgili `entities/` veya
   `concepts/` sayfasına ayrıca yaz.
6. `cwd` alanı bir proje klasörüne denk geliyorsa → o projenin
   `sources/`'una da kısa bir kayıt düş ve `log.md`'ye giriş ekle.
7. Profil terfi önerisi: 3+ tekrar eden tepki varsa **sor**, onay alırsan
   `profile/preferences.md`'ye taşı. **Asla doğrudan yazma.**

### INGEST — ham kaynak (`raw/inbox`, `raw/articles`, `raw/knowhow`, `raw/projects/<proje>`, vb.)
1. ⭐ **DEĞER KAPISI** — okumadan önce yukarıdaki testi uygula. Geçmezse
   **işleme**; gerekçesini `ingest-manifest.md`'ye yaz.
2. Kaynağı oku; ana konuyu, bulguları, bahsedilen entity/kavram/karar
   çıkar.
3. 5 maddelik özeti kullanıcıya göster, onay iste (aksi belirtilmedikçe).
4. Onaydan sonra: `sources/` altına özet sayfası (frontmatter dahil),
   ilgili `entities/`, `concepts/`, `decisions/` sayfalarını oluştur/güncelle,
   `index.md`'yi güncelle, `log.md`'ye giriş ekle.
5. `raw/`'a ASLA yazma.

### INGEST — agent-output (`raw/agent-output/<proje>/`)

> ⓘ Bu klasör **Kütüphaneci'nin** ara katmanıdır. Kod ajanları buraya
> dosya bırakmaz — tek hedefleri proje dizinindeki `knowledge-base.md`.
> ⭐ Kararlar **doğrudan** proje KB'sinden okunur:
> `raw/agent-output/` beklenmeden `projects/<proje>/decisions/`'ye terfi
> edilebilir.

**A) Karar dosyaları — `kararlar/*.md` → MEKANİK taşıma**
İçerik yorum gerektirmez: kopyala, konumunu değiştir, meta alanlarını
güncelle. `supersedes:` varsa eski sayfaya `status: superseded` +
`superseded_by:` ekle. **Silme.** `scope: cross-project` ise pointer akışı
+ `network.md`. Proje `log.md`'ye giriş düş.

**B) Oturum raporları — `YYYY-MM-DD-<konu>.md` → YORUM gerektirir**
Raporu oku; `pending_review: true` doğrula; içeriği projenin `PROJECT.md`,
`architecture.md`, `decisions/`, `sources/` sayfalarına entegre et. Raporun
kendi frontmatter'ını `pending_review: false, status: reviewed` yap.
Proje `log.md`'sine ve global `log.md`'ye giriş ekle.

### QUERY (arama ve yanıtlama)
1. Önce `index.md` + `network.md` oku → hangi katman ilgili?
2. `CLAUDE.md` §3 klasör ağacına bak → dosya nerede olmalı?
3. İlgili `projects/<proje>/` varsa → `PROJECT.md` → `log.md` (son) →
   `decisions/` → `sources/`
4. Kullanıcının **tercihi veya tepkisi**yle ilgiliyse → `profile/user.md` +
   `profile/preferences.md` + **`profile/reactions.md`** (üçü birlikte)
5. Yoksa ilgili `concepts/` veya `entities/` sayfasını aç.
6. Cevap ver. Her iddianın yanında `[[bağlantı]]` ver.
7. Yeni bir karar çıkarsa → `decisions/` altında atomik sayfa aç.
8. `query` girişini `log.md`'ye yaz.

### LINT (haftalık/aylık)
Kontrol eder: çelişkiler, eskimiş iddialar, yetim sayfalar, eksik kavram
sayfaları, tek-yönlü cross-referanslar, `network.md`'de eksik cross-project
kararlar, `staging/`'de X günden uzun bekleyen taslaklar. `lint-report.md`
yazar, **OTOMATİK DÜZELTME YAPMAZ.**

Ek kontroller:
- **Lessons-learning terfi taraması:** her projedeki `knowledge-base.md`
  taranır. Aynı kök nedenden doğan ders **2+ projede** geçiyorsa
  `DEV_BRIEF.md` §3'e terfi adayıdır → kullanıcıya **tek seferde** sor.
- **`knowledge-base.md` snapshot'ı:** `raw/knowledge-base/<slug>/` altındaki
  son snapshot satır sayısı ile repodaki KB satır sayısı karşılaştırılır.
- **DEV_BRIEF senkron:** yerel kopyadaki `v` sütunu ile vault kökündeki
  sürüm karşılaştırılır.
- **Ham kaynak takibi:** `ingest-manifest.md` ile `raw/`'ın gerçek durumu
  tutarlı mı?
- **Doküman bayatlığı:** aşağıdaki dosyalar yapı değişince yeniden
  yazılmış olmalı. Kontrol noktası: `CLAUDE.md` §0 okuma sırası ↔
  `CODING_AGENT_PROMPT.md` Katman 1 ↔ `REPO_ROOT_AGENTS_STUB.md` ↔
  `MANUEL.md` §5 — **dördü aynı sayıyı göstermeli.**
- ⭐ **"Yok" bulgularının tazeliği** — yukarıdaki zaman-kontrolü kuralı.

### LEARN (profil güncelleme — periyodik veya lint ile birlikte)
Son log/query/ingest geçmişini tara, tekrarlayan bir örüntü var mı bak.
`profile/patterns.md`'ye tarihli ve `(inferred, YYYY-MM-DD, N. gözlem)`
etiketli satır ekle. 3+ gözleme ulaşan örüntü için **sor**; onay verirse
`user.md` / `preferences.md`'ye taşı. **Asla doğrudan yazma.**

Sohbetlerden gelen tepkiler için ayrı akış: `INGEST — chat` →
`profile/reactions.md`.

### LEARN — lessons-learning terfi döngüsü (`DEV_BRIEF.md`)

> **İki katman ayrıdır ve karıştırılmaz:**

| Katman | Sahibi | Yaşam süresi |
|---|---|---|
| `<proje>/knowledge-base.md` | **ajan** | proje ömrü |
| `DEV_BRIEF.md` | **Kütüphaneci** | sınırsız |

**Terfi ölçütü:**

| Durum | Terfi? |
|---|---|
| Aynı ders **bir projede** 3+ kez | ❌ o projede kalır |
| Aynı ders **2+ projede** geçiyor | ✅ terfi adayı |
| Bir **kalıcı karar** (teknik tercih) | ✅ terfi adayı |
| Bir kerelik olay | ❌ |

> ⭐ **Sayım kuralı:** Gerçek **hata kayıtları** sayılır (`### Problem` +
> `### Root Cause`). ⛔ **Karar kayıtları sayılmaz** — kararlar zaten
> terfi ediliyorsa kanıt iki kez sayılırdı. ⛔ **İş/günlük kayıtları da
> sayılmaz** (*"✅ Eklendi"*, *"🔍 Debug"*) — ham sayımla kanıt **yapay
> olarak şişer** ve terfi **erken tetiklenir.**
> ⭐ İstisna: bir kalıp yalnızca "iş kaydı" olarak geçiyorsa (UI standardı
> gibi) kanıt **1** sayılır ve terfi için bekler.

**Terfi adımı (LINT tetikler, kullanıcı da elle tetikleyebilir):**
1. Her projedeki `knowledge-base.md`'yi tara.
2. Aynı/aynı kök nedene dayanan dersleri grupla.
3. 2+ projede geçen ders → terfi adayı.
4. Kullanıcıya **tek seferde** sor. Onay verirse `DEV_BRIEF.md` §3'e
   **kanıt sayısıyla** yazılır.
5. `log.md`'ye kaydedilir.

> **Brif her zaman ince kalmalı (~200 satır).** `knowledge-base.md` şişer,
> `DEV_BRIEF.md` **sıkıştırılır.** 10 ayrı case tek kurala indirgenir.

### Snapshot adımı — `knowledge-base.md` → `raw/` ⭐

```
ajan knowledge-base.md'ye yazar         (izin yok, hızlı, yerel)
        ↓  tetikleyici: boyut eşiği · LINT · kullanıcı komutu
Kütüphaneci raw/knowledge-base/<slug>/<tarih>-<slug>-kb.md alır
        ↓  manifest watermark: satır sayısı
sadece YENİ satırlar işlenir → kaynak sayfa → terfi adayı
        ↓
DEV_BRIEF.md §3 ← ajan bunu okur (bir sonraki oturumda)
```

| | |
|---|---|
| Snapshot = ham veri | `raw/`'a girer, **kaynak sayfası olmaz** |
| Yerel KB = çalışma günlüğü | ajanın yaşayan dosyası, değişmeye devam eder |
| Tek doğruluk kaynağı | **snapshot** |
| Ajan okumaz | yalnızca yazar |
| Ajan vault okur | brif §3 + §7 konuları |

**Tetikleyici otomatik zamanlayıcı değildir.** Ajan bu vault'ta yaşamıyor;
tetikleyici ya kullanıcı komutu ya LINT olmalı. Eşik: **+500 satır** ya da
proje başına 4-6 hafta.

**Ajan `knowledge-base.md`'ye yazar, Kütüphaneci terfi eder.** Ajan
`DEV_BRIEF.md`'yi **kendi başına düzenlemez** — o kullanıcının profilidir.

## 8) AI Kod Geliştirme Ajanları için Sözleşme

> **Bellek modeli:** Bu vault bir ikinci beyindir. Kod ajanı kod yazmadan
> önce **okur**, karar verirken **anında yazar**, bitince **raporlar**.

### Okuma (9 adım — sıra, atlağın yok)

1. `CLAUDE.md` (Bölüm 8-9)
2. **`profile/preferences.md`** ← kullanıcının tercihleri, ajana da geçerli
3. **`profile/reactions.md`** ← kullanıcının **neye tepki verdiği.**
   `preferences.md` ne istediğini, bu dosya hangi çıktıya onay verdiğini ya
   da reddettiğini söyler. **Biri olmadan diğeri eksiktir.**
4. **`projects/_STANDARTLAR/PROJECT.md`** + `decisions/` → **atlanmaz**
5. `projects/<proje>/PROJECT.md`
6. `architecture.md`
7. `projects/<proje>/decisions/` → tümü
8. `projects/<proje>/log.md` → son 10-15 satır
9. `sources/` → son 3-5 dosya

**Okuma kanıtı:** koda geçmeden önce ajan, geçerli kararları
**başlıklarıyla ve tek cümle özetle** — ya da "karar bulamadım" der.
Hatırlayamadığı kararı uydurmasın diye bu zorunludur.

### ⭐ Yazma — **TEK hedef, ve o proje dizinindedir**

| | Nereye | Kim |
|---|---|---|
| **Yazma** | ⭐ **`<proje>/knowledge-base.md`** | **kod ajanı** |
| **Yazma** | `raw/agent-output/` · `sources/` · `decisions/` · `log.md` | **Kütüphaneci** |
| **Okuma** | vault (`CLAUDE.md` · `profile/` · `decisions/` · `DEV_BRIEF` §3) | **kod ajanı** ✅ |

> ⭐ **Ajanın vault'taki tek yazma yetkisi yoktur.**

**KAYIT 1 — `knowledge-base.md` (tek yazma hedefi)**

| | |
|---|---|
| **Ne zaman** | Hata çözüldüğünde **ve** kalıcı karar verildiğinde |
| **Nerede** | ⭐ **proje kökünde** |
| **Ne okunur** | ⛔ **Ajan okumaz** — çok büyüyebilir |

> ⭐ **Neden okunmuyor?** Ajanın *"daha önce oldu mu?"* sorusunun cevabı
> zaten `DEV_BRIEF.md` §3'te. Bu dosya **kayıt içindir**, komut değil.

**KAYIT 2 — Karar, KB'ye de yazılır**

Bu dosya **iki kayıt türü** taşır:

| | Hata kaydı | ⭐ **Karar kaydı** |
|---|---|---|
| **Bloklar** | `Problem` · `Root Cause` · `Solution` · `Files Changed` | `Karar` · `Karar Gerekçesi` · `Değerlendirilen Alternatifler` · `Files Changed` |
| **Terfi sayımı** | ✅ sayılır | ⛔ sayılmaz |

> ⭐ **Aynı olayda ikisi de olabilir.** Hata çözümü kalıcı kural doğuruyorsa
> **tek kayıtta** hem `Root Cause` hem `Karar` açılır. Bölme — bağ kopar.

**⛔ Her karar yazılmaz:**

| | Yaz | Yazma |
|---|---|---|
| ✅ | Kural doğuracak karar (enum değeri, katman sınırı, kütüphane, convention) | ⛔ O an için çözülen, kalıcı olmayan düzeltme |
| ✅ | Alternatifleri **değerlendirilmiş** seçim | ⛔ *"Zorunda kaldım"* — bu `Root Cause`'dur |
| ✅ | Gerekçesi **bir sonraki oturumu etkileyecekse** | ⛔ Dosya/fonksiyon adı gibi uygulama detayı |
| | | ⛔ KB'de **bulunan** kararı tekrar etme |

> ⛔ **"Değerlendirilen alternatifler" boş bırakılamaz.** Üç dürüst
> seçenekten biri: (a) gerçekten düşünüldü — somut gerekçe,
> (b) ajan düşünmedi — *"Ajan bu alternatifi değerlendirmedi"* + neden
> (utanç değil, **dürüstlük**), (c) kaynakta yok — *"ajan uydurmadı"*.

### Otomatik yükleme (elle yapıştırmadan)

Kullanıcı, kod reposunun köküne `AGENTS.md` kopyalayarak bu protokolü **her
oturumda otomatik** yükletebilir. Şablon: `REPO_ROOT_AGENTS_STUB.md` —
içinde `{{VAULT_YOLU}}` ve `{{PROJE_SLUG}}` placeholder'ları vardır.

### Mevcut bir kararı değiştirmek

Ajan eski sayfayı değiştirmez. Yeni karar dosyası yazar,
`supersedes: <eski-slug>` doldurur. Kütüphaneci taşırken `status: superseded`
işaretler.

### Halüsinasyon koruması

- Var olmayan dosya/sınıf/metot/endpoint **uydurulmaz** — önce doğrulanır.
- Her teknik iddianın arkasında kaynak olur.
- Tahmin **"tahmin:"** diye işaretlenir.
- Kod ile karar çelişirse ajan **kendi kararıyla geçmez**, sorar.
- Yarım kalan varsa **söylenir** ("tümünü yaptım" yalanı yasak).

### Kütüphaneci'nin taşıma işi (mekanik)

1. **Karar dosyaları** → `projects/<proje>/decisions/<slug>.md` konumuna
   taşınır. Kaynak iki yerden olabilir: `raw/agent-output/<proje>/kararlar/`
   ya da ⭐ **doğrudan proje `knowledge-base.md`'nin `### Karar` blokları**
   (kod ajanı vault'a yazmadığı için bu asıl kaynaktır). İçerik değişmez;
   yalnızca meta alanları güncellenir, `scope: cross-project` ise pointer +
   `network.md`, eski kararın yerine geçiyorsa `status: superseded`.

2. **Oturum raporları** → `projects/<proje>/*` altına **entegre edilir**
   (hangi sayfalara ne yazılacak, hangi entity/concept doğdu — yorum
   gerektirir).

## 9) Kesin Kurallar

- ⛔ **KOD REPOSUNDAKİ KODU DÜZENLEME.** Kütüphaneci (vault ajanı)
  **hiçbir kod dosyasını değiştirmez** — `.java`, `.ts`, `.tsx`, `.js`,
  `.sql`, config dosyası, ne olursa olsun.
  > **Kütüphaneci ne yapar:** bulur, kanıtını (dosya yolu + satır) toplar,
  > karar sayfasına yazar, kullanıcıya sunar. Kod ajanı uygular.
  > **Kütüphaneci ne yapmaz:** düzenleme, refactor, migration, build.
  >
  > **İstisna:** kullanıcı açıkça *"bunu uygula"* derse. O zaman da commit
  > öncesi onay alınır ve değişiklik `log.md`'ye yazılır.
- ⭐ **Bu vault bir git reposudur.** → Wiki katmanı (`sources/` `concepts/`
  `entities/` `global/` `projects/` `profile/` `log.md` `index.md`
  `CLAUDE.md`) **her zaman** versiyondadır. `raw/`'ın ağır kısımları
  dışarıdadır — yeniden üretilebilir.
  - **Kütüphaneci commit atmaz.** Değişiklik yaptıktan sonra `git status`
    ile neyin değiştiğini **kullanıcıya gösterir**; commit kararı
    kullanıcıya aittir.
  - `.gitignore`'a **asla** dokunma — özellikle `_GIZLI/` satırı.
    Şifreli kasa git geçmişine **giremez**; geçmiş kalıcıdır.
- **`raw/` immutable** — sadece kullanıcı (ve Kütüphaneci'nin
  `agent-output` katmanı) ekler; hiçbir ajan buradaki mevcut dosyayı
  değiştirmez/silmez.
  - ⭐ **Açık istisna:** `raw/` altındaki **yeniden üretilebilir** içerik
    yönetilebilir — `_SABLON/` şablonları ve `raw/knowledge-base/`
    snapshot'ları bunlar dış kaynaktan tazelenir. Bunlar **kullanıcının
    malzemesi değildir.** Yine de: **dosya yok edilmez, `archive/`'a taşınır**
    ve `ingest-manifest.md`'ye kaydedilir. İstisna **varsayılan değil,
    adıyla yazılır.**
  - ⛔ **`raw/` içinde `git` ÇALIŞTIRMA.** Bir `raw/` altındaki repoda
    `git log` çalıştırmak `.git/index` (stat-cache) dosyasının baytlarını
    değiştirir. Gerekiyorsa: **canlı repodan** çalıştır ya da
    `GIT_OPTIONAL_LOCKS=0` ver.
- **`raw/` gizli veri: ŞİFRELİ kutuya yaz, düz metne asla.**
  Parola, token/API anahtarı, IBAN, kart/TC/vergi no, seed ifadesi, ağ
  şifresi gibi `raw/` gizli verileri `sources/`, `entities/`, `concepts/`,
  `global/` katmanlarına **aktarılmaz.** Bunun yerine **şifreli** olarak
  `_GIZLI/kayitlar/<slug>.gizli` altına yazılır.
  - `_GIZLI/INDEX.md` (hangi sır var, ne için, nerede) → **serbest okunur**
  - Başlık (`slug`/`tur`/`amac`) → **serbest okunur**
  - ⛔ **Değeri çözme.** `decrypt`/`coz` komutunu **çalıştırma**, parolayı
    isteme, tahmin etme, varsayma. Kullanıcı onay verirse sana **şifreli
    metni** verir; çözmene gerek yok.
  - ⛔ Şifreli metni çözüp **hiçbir yere yazma** (kod, log, cevap, KB).
- Kaynaksız iddia yasak — her önemli cümle bir `source:` referansı taşır.
- Sayfa silinmez, `archive/`'a taşınır.
- Çelişkiler silinmez, `## ÇELİŞKİ` başlığıyla görünür şekilde işaretlenir.
- `profile/user.md` ve `profile/preferences.md` yalnızca kullanıcının **açık
  onayıyla** değişir. `patterns.md`'deki bir örüntü 3+ gözleme ulaştığında
  ajan terfi teklifi sunar; onay gelirse taşır.
- Bir kararın tek doğruluk kaynağı vardır (proje-lokal); `global/` sadece
  pointer tutar, kopya değil. Sahipsiz projeler arası kararlar
  `projects/_STANDARTLAR/decisions/` altında yaşar.
- ⭐ **Kod ajanları vault'a hiçbir şey yazmaz.** Tek yazma hedefi proje
  dizinindeki `knowledge-base.md`'dir. Vault'a yazan tek ajan
  **Kütüphaneci**'dir: `raw/` · `sources/` · `projects/` · `global/` ·
  `entities/` · `concepts/` · `log.md`.
- Her operasyon (ingest/query/lint/learn) ilgili `log.md`'ye kaydedilir.
- Dosya adları **kebab-case** — ⛔ **istisna: proje kimliği camelCase.**
  Kebab-case yalnız **wiki sayfaları** içindir (kaynak · kavmak · karar ·
  entity · synthesis `.md` dosyaları). Proje klasörü adı ve ondan türeyen
  slug **camelCase**'dir ve repo adıyla **birebir** örtüşür — iki isim
  birden yaşarsa ajan hangisini arayacağını bilemez.

## 10) Şemanın Evrimi

Bu dosya sabit değildir. Bir kural pratikte çalışmıyorsa, güncelleyin;
değişiklik `log.md`'ye `## [YYYY-MM-DD] schema-change | <özet>` olarak
düşülür ki sonraki oturumlar neyin neden değiştiğini bilsin.