---
name: second-brain-constitution
version: 1.0
updated: 2026-09-27
---

# CLAUDE.md — Bu Vault'un Anayasası

Bu dosya, bu Obsidian vault'unu işleyen HERHANGİ BİR AI ajanı için (Claude,
Codex, Claude Code, bir IDE eklentisi, vs.) bağlayıcıdır. `AGENTS.md` bu
dosyanın birebir kopyasıdır — sadece farklı ajan araçlarının varsayılan
olarak aradığı dosya adını karşılamak için var. İkisi senkron tutulur.

## 0) ZORUNLU OKUMA SIRASI (her oturumun ilk adımı)

Görev ne olursa olsun (ingest, query, lint, kod geliştirme, herhangi bir şey),
bir ajan bu vault'ta çalışmaya başlamadan önce SIRAYLA şunları okur:

0. ⭐⭐ **ADIM 0 — Ajan kim?** Kullanıcı seni **"GOKU"** diye çağırdıysa:
   bu ajanın **önceki oturumun devamı** sayılır — önceki ajan gibi
   davran, karar mantığını sürdür. Kurallar: **`entities/goku.md`**
   (okumazsan bu adın ne anlama geldiğini bilemezsin).
   ⓘ Yeni oturumun context'i boştur; bağlam **buradan** gelir.
   `log.md` son giriş + `bootstrap` MCP çağrısı = önceki oturumun özeti.
1. Bu dosya (`CLAUDE.md`) — baştan sona.
2. `index.md` — vault'un içerik kataloğu.
3. **`ingest-manifest.md`** — hangi ham kaynak zaten işlendi. Ham kaynak
   taraması yapacaksan (ingest, lint) **bu dosyayı atlayarak tarama**.
4. `profile/user.md` ve `profile/preferences.md` — kullanıcıyı ve çalışma
   tarzını tanımak için. Ajan bu ikisini `[[profile/reactions.md]]` ile
   birlikte okur.
5. `log.md`'nin SON 10-15 satırı (`tail -n 30 log.md` gibi) — yakın zamanda
   ne olmuş.
6. Eğer görev belirli bir projeyle ilgiliyse: önce
   `projects/<proje-adi>/PROJECT.md`, sonra
   **`projects/_STANDARTLAR/PROJECT.md`** (projeye ait olmayan ama her
   projeye uygulanan kurallar), sonra o projenin kendi `log.md`'sinin
   son satırları.

Bu sırayı atlayan bir ajan, önceden verilmiş kararları tekrar sorar veya
onlarla çelişir. Atlama.

## 1) Amaç

Bu vault iki şeyi aynı anda yapar:

- **Kişisel ikinci beyin**: sizin hakkınızda, tercihlerinizle, çalışma
  tarzınızla, kararlarınızla zamanla zenginleşen bir profil + genel bilgi
  arşivi.
- **Çoklu proje hafızası**: her biri kendi içinde izole, ama ortak/stratejik
  kararları paylaşılan bir ağ üzerinden görünür kılan proje alanları. AI
  kod geliştirme ajanları buraya hızlıca girip proje bağlamını okur, iş
  bitince ürettiği dokümanı bu yapıya uygun şekilde bırakır.

Wiki'yi sizin yerinize bir "Kütüphaneci Ajan" yazar ve bakımını yapar. Siz
kaynak sağlar, soru sorar, kararları onaylarsınız.

## 2) Roller

| Kim | Ne yapar |
|---|---|
| **Siz** | Kaynak/ham veri sağlar, projeleri başlatır, sorular sorar, profil/user.md'deki iddiaları onaylar. |
| **Kütüphaneci Ajan** (genel amaçlı, örn. bu sohbet) | `raw/` ve `raw/agent-output/` altındaki her şeyi işler, wiki'nin GERÇEK sahibi katmanına (sources, entities, concepts, decisions, global, profile) yazar. Tek yazar odur. ⛔ **Kod yazmaz, kod değiştirmez** — bkz. Bölüm 9 |
| **AI Kod Geliştirme Ajanı** (Claude Code, Codex, vs.) | Bir proje üzerinde çalışır. `projects/<proje>/` içindeki dosyaları HIZLICA okuyup bağlam alır. İş bitince wiki'nin ana katmanına DOĞRUDAN yazmaz — Vault'u **okur** (second brain: `CLAUDE.md` · `profile/` · `decisions/` · `DEV_BRIEF.md` §3) ve **proje dizinindeki `knowledge-base.md`'ye yazar** (hata + karar kaydı). ⛔ **Vault'a hiçbir şey yazmaz** (bkz. Bölüm 8). |
| **Sen (Kullanıcı)** | İki şey ekle: (a) belge → `raw/projects/<proje>/`, (b) **sohbet tepkisi** → `raw/chats/<ajtör>/` (şablon: `raw/chats/_SABLON/chat-sablonu.md`) |

## 3) Mimari (klasör ağacı)

```
vault/
├── CLAUDE.md / AGENTS.md   # bu dosya (anayasa)
├── index.md                 # tüm vault'un içerik kataloğu
├── ingest-manifest.md       # hangi ham kaynaklar işlendi — ajan önce buraya bakar
├── log.md                   # global, append-only, zaman damgalı olay kaydı
├── network.md                # projeler-arası / stratejik karar haritası
│
├── profile/                  # "sizi zamanla tanıma" katmanı
│   ├── user.md                 # sizin doğrudan söylediğiniz kalıcı gerçekler
│   ├── preferences.md           # çalışma tarzı, araç/stack tercihleri (siz söylediniz)
│   ├── reactions.md             # neye TEPKİ verdiğiniz (onay/ret/uslup/uzunluk) — ölçüm tarafı
│   └── patterns.md               # ajanın zamanla fark ettiği tekrarlayan örüntüler
│
├── raw/                        # DOKUNULMAZ ham kaynaklar — sadece siz eklersiniz
│   ├── inbox/                    # sınıflandırılmamış her şey önce buraya düşer
│   ├── articles/, transcripts/     # genel/kişisel okuma malzemesi
│   ├── chats/<ajtör>/                # AI sohbet kayıtları — TEPKI sinyali çıkarılır (ingest -- chat)
│   ├── knowhow/                     # ÖZEL: sizinle ilgili teknik know-how, notlar, kariyer bilgisi
│   ├── projects/<proje>/             # bir projeye ait, SİZİN eklediğiniz belgeler (spec, not, karar metni)
│   └── agent-output/<proje>/          # kod ajanlarının bıraktığı ham raporlar (henüz işlenmemiş)
│
├── staging/                     # işlenmeyi bekleyen / gözden geçirme gerektiren taslaklar
│
├── sources/                     # proje-bağımsız, genel/kişisel kaynak özetleri (raw/inbox, articles, transcripts, knowhow buraya akar)
│
├── projects/<proje-adi>/          # HER PROJE İZOLE
│   ├── PROJECT.md                    # tek bakışta özet — kod ajanının okuyacağı İLK dosya
│   ├── architecture.md
│   ├── decisions/                     # projeye özel, atomik kararlar
│   ├── sources/                        # bu projeye ait ingest özetleri (raw/projects/<proje> ve raw/agent-output/<proje> buraya akar)
│   └── log.md                           # projeye özel zaman çizelgesi
│
├── projects/_STANDARTLAR/       # SAHİPSİZ projeler arası kararların yaşadığı meta-proje
│   ├── PROJECT.md                    # buradaki kurallar her projeye uygulanır
│   ├── decisions/                     # asıl karar sayfaları burada durur
│   └── log.md
│
├── global/                       # PROJELER ARASI ORTAK AĞ (sadece pointer + yeni sentez)
│   ├── decisions/                   # >1 projeyi etkileyen kararların POINTER'ı (içerik değil)
│   ├── concepts/                     # projeler arası tekrar eden desenler ("RAG pipeline deseni" gibi)
│   └── syntheses/                     # büyük resim, evrilen tezler
│
├── entities/                    # kişiler, araçlar, şirketler, servisler (proje-bağımsız)
├── concepts/                    # genel/kişisel bilgi kavramları (proje-bağımsız)
└── archive/                     # emekliye ayrılmış sayfalar — ASLA silinmez
```

## 4) Sayfa Formatı (her wiki sayfası)

```yaml
---
title: <başlık>
type: source | entity | concept | decision | project | profile | synthesis
project: <proje-adi> | global | personal
status: draft | reviewed | stale
confidence: stated | inferred | agent-generated-unreviewed
created: YYYY-MM-DD
updated: YYYY-MM-DD
source: [[raw/dosya-yolu]]
tags: [...]
---

> ⓘ **Bu şablon WIKI SAYFALARI içindir.** Operasyonel dosyalar
> (anayasa · katalog · kayıt defteri) frontmatter **taşımaz**:
> `CLAUDE.md` / `AGENTS.md` · `index.md` · `network.md` ·
> `ingest-manifest.md` · `log.md` · `MANUEL.md` · `DEV_BRIEF.md` ·
> `lint-report.md` · `raw/` altındaki her şey.

# <Başlık>

<içerik>

## Sources
- [[...]]

## Related
- [[...]]
```

`confidence` alanı kritik: **stated** = siz veya bir ham kaynak doğrudan
söyledi. **inferred** = ajan örüntüden çıkardı, henüz onaylanmadı.
**agent-generated-unreviewed** = bir kod ajanının bıraktığı, Kütüphaneci
tarafından henüz gözden geçirilmemiş içerik. Bir sayfa gözden geçirilip
doğrulanınca `status: reviewed` olur; `confidence` kaynağına göre kalır.

## 5) Profil Katmanı — "Beni Zamanla Tanısın"

- `profile/user.md`: SADECE sizin doğrudan söylediğiniz, kalıcı gerçekler
  (rol, sektör, temel tercihler). Kütüphaneci burayı SİZİN onayınız
  olmadan asla değiştirmez.
- `profile/preferences.md`: açıkça belirttiğiniz çalışma tarzı tercihleri
  (ör. "kısa cevap isterim", "TDD kullanırım", "Türkçe yaz").
- `profile/patterns.md`: Kütüphaneci'nin ingest/query geçmişinden fark
  ettiği TEKRARLAYAN örüntüler. Her satır tarihli ve `(inferred, YYYY-MM-DD)`
  etiketli. Bu dosyadaki hiçbir satır otomatik olarak `user.md`'ye terfi
  etmez — bir örüntü 3+ kez doğrulanırsa Kütüphaneci size sorar: "Bunu
  kalıcı bir tercih olarak kaydedeyim mi?" Onaylarsanız `user.md`'ye
  taşınır ve `log.md`'ye kaydedilir.

Bu katman olmadan wiki sadece dış kaynakları biriktirir, sizi asla
öğrenmez — bu yüzden en kritik eklemedir.

## 6) Proje İzolasyonu + Ortak Ağ

- Her proje kendi `projects/<proje>/` klasöründe YAŞAR: kendi kararları,
  kendi log'u, kendi kaynak özetleri. Bir projenin ajanı başka bir
  projenin klasörüne asla yazmaz.
- Bir karar SADECE o projeyi ilgilendiriyorsa → `projects/<proje>/decisions/`
  içinde kalır.
- Bir karar birden fazla projeyi etkiliyorsa veya stratejikse → frontmatter'a
  `scope: cross-project` eklenir, ASIL sayfa yine `projects/<proje>/decisions/`
  içinde kalır (tek doğruluk kaynağı), ve `global/decisions/` altına sadece
  bir **pointer sayfası** (tek satır özet + geri link) düşer. Böylece
  içerik çoğaltılmaz, sadece işaretlenir.
- `network.md`, tüm `scope: cross-project` kararların ve hangi projeleri
  etkilediklerinin canlı bir haritasıdır. Format:
  `- [[global/decisions/xxx]] ← etkiler: [[projects/a/PROJECT]], [[projects/b/PROJECT]]`
- Hiçbir projeden doğmayan, doğrudan stratejik/ortak kararlar
  `projects/_STANDARTLAR/decisions/` altında yaşar; aynı pointer kuralı
  (Bölüm 6) buraya da uygulanır.
- LINT operasyonu, `cross-project` etiketli ama `network.md`'de görünmeyen
  kararları bulur ve raporlar.

## 7) Operasyonlar

### 7.0) Kaynak Nereye Gider? (Routing Tablosu)

> **⭐ Temel kural (2026-09-28, kullanıcı düzeltmesi):** *İkinci beyin
> yalnızca `raw/` üzerinden ilerler.* Başka hiçbir yerden doğrudan
> içerik okunmaz.

**Neden:** `raw/` dışından çalışınca **provenance kaybolur** — hangi
dosyanın kopyasıydı, orijinali nerede, değişti mi bilinmez. Ayrıca
**canlı proje dosyalarına** müdahale etme riski doğar.

> ⚠️ **2026-09-28'de yaşanan neredeyse-hata:** Vault'a `raw/` dışından
> (`ornek-backend/src/main/resources/application-dev.properties`) içerik alınması ve
> *"kaynak dosyayı silebilirsin"* denmesi. **O dosya canlı yapılandırmadır** —
> silinseydi geliştirme ortamı kırılırdı. Vault **kopyalar**, **sahiplenmez.**

**Kural:**

| | |
|---|---|
| **Okuma** | Yalnızca `raw/` altından. Dışarıdaki bir dosya lazımsa → **önce `raw/`'a kopyala**, sonra oradan oku |
| **Kopyalama** | `raw/` altına alırken **kendi kopyasını** oluşturur — orijinaline dokunmaz |
| **Silme** | ⛔ `raw/` dışında **hiçbir dosya silinmez** |
| **Canlı proje dosyası** | `.env` · `application-*.properties` · config · migration → **asla silinmez, asla düzenlenmez** |
| **Sır dosyası** | `raw/`'a alıp `_GIZLI/`'ye şifrelersin — **orijinali yerinde kalır** (canli olabilir) |

**Çelişki çözümü:** Aynı içeriğin `raw/` dışında bir kopyası varsa (canlı
proje dosyası, arşiv, yedek) ve `raw/`'da yoksa:
1. Önce `raw/`'a kopyala → 2. Manifest Bölüm 1'e yaz → 3. **Orijinaline dokunma**
4. Kaynak yolu sayfada `source:` olarak belirt → takip edilebilir kalır

> ⭐ **Tutarlılık notu:** `knowledge-base.md` taraması da bu kurala tabidir.
> `ornek-backend` KB'si `raw/knowledge-base/ornek-backend/` altına snapshot alındı ✅;
> `ornek-frontend` KB'si **alınmadı** ❌ (doğrudan canlı dosyadan okundu).
> Bu tutarsızlık giderilmeli → `ingest-manifest.md` B2 #27.

**Aşağıdaki routing tablosu** yalnızca `raw/` altındaki kaynaklar için
geçerlidir.

> `raw/` altında olmayan bir dizin için bu işlemleri yapmamalıyız.

**ADIM 0 — ⭐ Kaynak `raw/` mı?**
`raw/` altındaysa devam et. **Değilse dur ve `raw/`'a kopyala** —
sonra oradan oku. Hiçbir zaman canlı bir proje dosyasını doğrudan
okuyup işleme; kopyasıyla çalış. (Yukarıdaki temel kural.)

Bir ajan `raw/` altında yeni bir dosya gördüğünde, önce şu üç adımı
izler:

**ADIM a — Ne zaten işlenmiş?** `ingest-manifest.md` §Bölüm 1'e bak.
Klasörün dosya sayısı ve en yeni kaydı değişmemişse → **tamamı
işlenmiştir, o klasöre tekrar bakma.** Değişmişse sadece **yeni olanları**
işle.

**ADIM a0 — ⭐ `.vaultignore` var mı?** (2026-10-01) Ham kaynak taramaya
geçmeden **önce** `.vaultignore`'ı oku. Eşleşen yollar **hiç açılmaz**:
`Get-ChildItem` ile sayılır (varlığı bilinir) ama **içeriği okunmaz**,
özetlenmez, taranmaz. Doğrulama:
`tools\vaultignore-dogrula.ps1`.

> ⭐ `.gitignore` ile **karıştırma**: `.gitignore` = *commit edilsin mi?*
> `.vaultignore` = *hiç açılıp okunacak mı?*

**ADIM b — Bu içerik nereye gider?** Aşağıdaki routing tablosuna bak.

**ADIM c — Kapanmamış mı?** İşledikten sonra `ingest-manifest.md`
§Bölüm 2'ye (flag) ve gerekiyorsa §Bölüm 3'e (karar) yaz, Bölüm 1'i
güncelle.

**Teşhis kuralları:**
- Sayı/tarih değişimini tespit edemiyorsan **"yok" deme, emin olma.** Bir
  sonraki oturumda aynı belirsizlik tekrar doğar. Emin değilsen
  kullanıcıya sor.
- Bir klasör **`.gitkeep` dışında dosya içermiyorsa** işlenmemiş sayılır.
- Aynı dosya `.html` + `.json` ikilisi ise (Keep export'u) **tek kayıttır**,
  iki kez sayma.

> `raw/agent-output/` bu tabloda istisnadır: orada `pending_review: true`
> frontmatter'ı zaten bir işlenmemiş işaretidir, manifest'e gerek yoktur.
> ⛔ **2026-09-29'dan beri kod ajanı buraya dosya bırakmaz** — klasör
> Kütüphaneci'nin ara katmanıdır ve boş kalması normaldir.

#### Routing Tablosu

| Ham dosya nerede | Özet nereye yazılır | Hangi akış |
|---|---|---|
| `raw/projects/<proje>/...` | `projects/<proje>/sources/` | INGEST — proje kaynağı |
| `raw/agent-output/<proje>/...` | `projects/<proje>/*` (entegre edilir, kopyalanmaz) | INGEST — agent-output (Bölüm 7 devamı) |
| `raw/chats/<ajtör>/...` | **`profile/reactions.md`** + varsa `projects/<proje>/sources/` | INGEST — chat |
| `raw/knowhow/...` | `sources/` (özet) + **profil adayı** (bkz. altı) | INGEST — know-how |
| `raw/inbox/`, `raw/articles/`, `raw/transcripts/` | `sources/` (genel) + ilgili `entities/`/`concepts/` | INGEST — genel kaynak |

- ⭐ **`raw/` gizli kalıp taraması — ADIM b, "nereye gider"den ÖNCE**
  > **2026-09-29'de 3. kez aynı tuzak yakalandı** → kalıcı kural olur.

  Bir ham kaynak dosyasını özetlemeden **önce** otomatik taramadan
  geçir. **Gözle arama yeterli değildir** — kanıt:

  | Tur | Gözle arama ne kaçırdı? |
  |---|---|
  | 1 | `OCAI Prompt History.md` → 6 JWT yazıldı, taramada **7** çıktı |
  | 2 | `users.json` / `login_history.json` → PII, dosya adından anlaşılmıyordu |
  | 3 | 2 CV PDF → adı geçtiği için değil, **taranarak** bulundu |

  Taranacak kalıplar (en az): `eyJ…` (JWT) · `["']password["']\s*:`
  · `$2[aby]$` (bcrypt) · `\b[0-9a-fA-F]{32,}\b` (api key) ·
  `BEGIN … PRIVATE KEY` · `AKIA[0-9A-Z]{16}` (AWS) · `jdbc:`

  ⛔ **Bulunan değerler asla `sources/` `entities/` `concepts/`
  `global/` katmanına yazılmaz.** Yazılan yalnızca **satır no + tür**
  olur. ⛔ Değeri buraya da yazma, `log.md`'ye de yazma.

  Bulunan gizli veri **kalıcı bir sır değilse** (geliştirme token'ı gibi)
  `_GIZLI/` kası **gerekmez** — kas aranmayan değerler içindir.
  Kanıt: [[projects/ornek-proje/sources/ornek-backend-prompt-history-gizli-veri]]

- `raw/ projects/<proje>/` altındaki bir dosyada bir proje ismi geçiyorsa
  (dosya yolu yanlış yere düşmüşse), Kütüphaneci onu ilgili projeye özgü
  kabul edip `projects/<proje>/sources/` altına yazabilir — ama bunu ingest
  özetinde açıkça belirtir ("bu dosya Keep'te `Project` etiketiyle duruyordu,
  X projesiyle ilgili olduğu için oraya yönlendirildi").
- `raw/knowhow/` içeriği her zaman `sources/` + profil adayı üretir; **bu
  klasördeki notların çoğu tek satırlık veya etiketsizdir** (Keep export'u
  gibi toplu kaynaklarda bu oran %45'e çıkabilir). Toplu kaynaklarda her
  notu ayrı sayfalamak yerine **kategori bazlı kaynak sayfaları** açılır;
  tek satırlık/gizli içerikli notlar sınıflandırma tablosuyla envanterlenir.

**`raw/knowhow/` özel kuralı**: bu klasördeki içerik sizinle ilgili özel/
teknik bilgi olduğu için, Kütüphaneci normal özete ek olarak şunu yapar:
içerikten `profile/user.md` veya `profile/preferences.md`'ye uygun,
doğrudan sizin ifadenize dayanan bir aday cümle çıkarırsa, bunu ekleme
önerisi olarak size gösterir ("Bunu profile/preferences.md'ye ekleyeyim
mi: '...'") — asla sormadan doğrudan yazmaz (Bölüm 9 ile aynı kural).

- ⭐ **`raw/` gizli kalıp taraması — ADIM b, "nereye gider"den ÖNCE**
  > **2026-09-29'de 3. kez aynı tuzak yakalandı** → kalıcı kural olur.

  Bir ham kaynak dosyasını özetlemeden **önce** otomatik taramadan
  geçir. **Gözle arama yeterli değildir** — kanıt:

  | Tur | Gözle arama ne kaçırdı? |
  |---|---|
  | 1 | `OCAI Prompt History.md` → 6 JWT yazıldı, taramada **7** çıktı |
  | 2 | `users.json` / `login_history.json` → PII, dosya adından anlaşılmıyordu |
  | 3 | 2 CV PDF → adı geçtiği için değil, **taranarak** bulundu |

  Taranacak kalıplar (en az): `eyJ…` (JWT) · `["']password["']\s*:`
  · `$2[aby]$` (bcrypt) · `\b[0-9a-fA-F]{32,}\b` (api key) ·
  `BEGIN … PRIVATE KEY` · `AKIA[0-9A-Z]{16}` (AWS) · `jdbc:`

  ⛔ **Bulunan değerler asla `sources/` `entities/` `concepts/`
  `global/` katmanına yazılmaz.** Yazılan yalnızca **satır no + tür**
  olur. ⛔ Değeri buraya da yazma, `log.md`'ye de yazma.

  Bulunan gizli veri **kalıcı bir sır değilse** (geliştirme token'ı gibi)
  `_GIZLI/` kası **gerekmez** — kas aranmayan değerler içindir.
  Kanıt: [[projects/ornek-proje/sources/ornek-backend-prompt-history-gizli-veri]]

- ⭐⭐ **KEŞİF SIRASI + ZAMAN KONTROLÜ — iki hatanın ortak kuralı**
  > **2026-09-29'da iki kez aynı sonuçla hata yapıldı.** İkisi de
  > birbirinin aynı belirtisiydi: **"buldum" deyip yanlış yere yazmak.**

  Bir konuda *"bulunamadı"* dendiğinde **şu sırayla** tara:

  | # | Katman | Neden |
  |---|---|---|
  | 1 | `raw/` — ham kaynak | Metnin **ne dediği** buradadır |
  | 2 | ⭐ `projects/*/decisions/` | **Cevap burada olabilir** |
  | 3 | `log.md` · `sources/` | Daha önce **çözülmüş** olabilir |

  > ⛔ **Yalnızca `raw/`'a bakmak kararı gözden kaçırır.**
  > Kanıt: *"online exam + adaptif sınav"* 3 gün ⛔ **"türetilemez"**
  > sayıldı; cevap `decisions/online-exam-ve-adaptif-sinav-birlesik-yapi`
  > sayfasında **2 gündür** duruyordu.
  > → [[projects/ornek-proje/sources/ornek-kaynak]]

  **Zaman kontrolü** — her bulguda kaynağın tarihini **bugünle** karşılaştır:

  | Bulgu | Doğru sonuç | Yanlış sonuç |
  |---|---|---|
  | Hafıza kaydı `2026-09-25`, bugün `09-29` | ⭐ **bayat** — bugün ne oldu diye bak | "yeni proje buldum" → **kopya proje** |

  > ⭐ **Aynı iş, iki isimle konuşulmuş olabilir** (`adaptive-exam-app` =
  > `adaptif-sinav-uygulamasi`). ⛔ Yeni bir şey bulduğunda **önce
  > `projects/` klasörlerini** kontrol et — zaten varsa **bu bir
  > tespit değil, tekrar**tır.
  >
  > ⭐ Kuralın özeti: **"bulamadım" demek için üç katman da taranmış
  > ve hiçbiri eşleşmemiş olmalıdır.** Tek katmana bakıp *"yok"* demek
  > **kanıtsız tespittir.**
**Bu kural 2026-09-27'de gevşetildi**: 3+ gözleme ulaşan örüntüler
kullanıcıya soruldu ve onay alınınca `user.md`/`preferences.md`'ye
taşınabilir. Tek oturumda doğrulanan örüntüler `patterns.md`'de kalır.

### INGEST — chat (`raw/chats/<ajtör>/`)

Bir sohbet kaydı. Kaynak: `raw/chats/_SABLON/chat-sablonu.md`

1. **Yalnızca `<siz>` bloklarını oku.** Asistan mesajları bağlamdır,
   **kanıt değildir.** Bkz. `concepts/tatmin-signali-islemi` — bu kural
   atlanırsa vault kullanıcının söylemediği şeylerle dolar.
2. Sözlüğe göre her tepkiyi sınıflandır:
   **valans** (`onay` / `degistir` / `reddet` / `devam`) ·
   **boyut** (`icerik` / `uslup` / `uzunluk` / `yapi` / `kapsam` / `hiz`
   / `gorsel`) · **genellik** (`genel` / `baglamli` / `proje`)
3. Aynı konuya ait **tekrar sayacını** artır. Silme — sayaç büyür.
4. Yerleştir:
   - `reddet` → `profile/reactions.md` §**Ret edilenler** (yasak listesi)
   - ilk kez görülen `onay`/`degistir`/`devam` → §**Tek seferlik sinyaller**
   - **3+ aynı tepki** → §**Tekrarlayan tepkiler** + terfi önerisi
   - **3+ `onay`** → §**Onaylanmış kalıplar**
5. Chat içinde **dünya bilgisi** de varsa (bir kütüphane, bir komut, bir
   pattern) → ilgili `entities/` veya `concepts/` sayfasına ayrıca yaz.
   Yani bir chat'ten **iki tür** bilgi çıkabilir.
6. `cwd` alanı bir proje klasörüne denk geliyorsa → o projenin
   `sources/`'una da kısa bir kayıt düş ve `log.md`'ye giriş ekle.
7. Profil terfi önerisi: 3+ tekrar eden tepki varsa kullanıcıya sor, onay
   alırsan `profile/preferences.md`'ye taşı. Asla doğrudan yazma.

### INGEST — ham kaynak (`raw/inbox`, `raw/articles`, `raw/knowhow`, `raw/projects/<proje>`, vb.)
1. ⭐ **DEĞER KAPISI** — okumadan önce aşağıdaki testi uygula. Geçmezse
   **işleme**; gerekçesini `ingest-manifest.md`'ye "değersiz" diye yaz.
2. Kaynağı oku, ana konuyu/bulguları/bahsedilen entity-kavram-kararları çıkar.
3. 5 maddelik özeti kullanıcıya göster, onay iste (aksi belirtilmedikçe).
4. Onaydan sonra: `sources/` altına özet sayfası (frontmatter dahil),
   ilgili `entities/`, `concepts/`, `decisions/` sayfalarını oluştur/güncelle,
   `index.md`'yi güncelle, `log.md`'ye `## [YYYY-MM-DD] ingest | <slug>` ekle.
5. `raw/`'a ASLA yazma.

#### ⭐ Değer kapısı — her şey işlenmez

> **Kullanıcı kararı (2026-09-30), birebir:**
> *"eğer bilgi işlenmeye değer değilse işlemeyelim. yani kullanıcı bir
> dosya attı diye her bilgi kıymetli olmak zorunda değil."*
>
> ⭐ *"önemli değil demek kıymetlidir."*

**Test — en az biri doğruysa İŞLE:**

| # | Sinyal | Örnek |
|---|---|---|
| 1 | **Örüntü** — tekrar edebilir | "hep şunu tercih ediyorum" |
| 2 | **Karar / sonuç** — bir şey değiştirdi | "Bunu seçtim, şu sebeple" |
| 3 | **Sen** — kimlik, tercih, kariyer, çalışma tarzı | "Java + Boot kullanıyorum" |
| 4 | **Bağlantı** — mevcut bir sayfaya değer katıyor | RFC, karar, hata kaydı |
| 5 | **Gelecek eylem** — ileride karar için gerek | "X ileride lazım olacak" |

**Test — hiçbiri doğru değilse İŞLEME, gerekçesini yaz:**

> ⭐ Kanonik örnek (kullanıcıdan): *"3 yıl önce 4'cü haftanın 2'ci günü
> hangi kahvaltıyı yaptım"* sorusunun yanıtı. **Doğru olabilir, yanlış
> olabilir, hatırlanmayabilir** — hiçbiri önemli değil. Ve ⭐ **önemli
> olmaması da bir bilgidir.**

| Değersiz örnekleri | Neden |
|---|---|
| Tek seferlik kişisel ayrıntı | Örüntü yok, eylem yok |
| Karşılığını verdiği karşılaştırma | Bağlantı yok |
| Zaten kaynakta duran tekrar | Yeni bilgi yok |
| Üçüncü taraf tanıtım metni | Senin malzemen değil |

> ⓘ **Bu bir filtre değil, bir kayıt yükümlülüğüdür.** "Önemli değil"
> cevabı da `ingest-manifest.md`'ye yazılır — ⛔ **sessizce geçilmez.**
> Aksi halde sonraki ajan aynı dosyayı yeniden değerlendirip aynı soruyu
> tekrar sorar.
>
> ⏳ **Sınır:** değerlendirmeyi **Kütüphaneci** yapar. Ajan kullanıcının
> niyetini tahmin edip içeriği **elemez** — elemesi de kaydeder.

### INGEST — agent-output (`raw/agent-output/<proje>/`)
Bu klasörde **iki tür dosya** olur ve **işlemleri farklıdır.**

> ⓘ **2026-09-29 kullanıcı kararı:** Kod ajanları **artık vault'a
> yazmaz** (tek hedefleri proje dizinindeki `knowledge-base.md`).
> Aşağıdaki akış **Kütüphaneci'nin kendi** bıraktığı karar/rapor dosyaları
> ve kullanıcının `raw/agent-output/`'ye koyduğu belgeler içindir.
> ⭐ Kararlar **doğrudan** proje KB'sinden okunur: `raw/agent-output/`
> beklenmeden `projects/<proje>/decisions/`'ye terfi edilebilir.

**A) Karar dosyaları — `kararlar/*.md` → MEKANİK taşıma**

Karar dosyası içerik yorum gerektirmez:
kopyala, konumunu değiştir, meta alanları güncelle.

1. `projects/<proje>/decisions/<slug>.md` konumuna taşı (dosya adı
   kebab-case'e normalize edilir).
2. Frontmatter: `confidence: agent-generated-unreviewed` → Kütüphaneci'nin
   kendi değerlendirmesi (`stated` / `inferred` /
   `agent-generated-unreviewed` kalabilir). `decided_by: code-agent`
   alanı **kalır** — kararın ajan tarafından verildiği tarihçe olarak
   değerlidir.
3. `supersedes: <eski-slug>` varsa: eski karar sayfasına
   `status: superseded` + `superseded_by: <yeni-slug>` ekle. **Silme.**
4. `scope: cross-project` ise Bölüm 6 pointer akışı + `network.md`.
5. Proje `log.md`'ye `## [YYYY-MM-DD] decision | <slug>` düş.
6. Ham dosya `raw/agent-output/` altında **kalır** (o da ham kaynaktır).

**B) Oturum raporları — `YYYY-MM-DD-<konu>.md` → YORUM gerektirir**

1. Raporu oku. `pending_review: true` frontmatter'ı doğrula.
2. İçeriği projenin `PROJECT.md`, `architecture.md`, `decisions/`,
   `sources/` sayfalarına entegre et (yeni sayfa aç veya mevcudu güncelle).
3. Rapordaki `decisions: [<slug>]` listesini kontrol et — o slug'lar A
   adımında zaten taşındıysa burada tekrar işleme.
4. Rapor `scope: cross-project` işaretli bir karar içeriyorsa Bölüm 6'daki
   pointer akışını uygula.
5. Kaynak raporun frontmatter'ını `pending_review: false, status: reviewed`
   olarak güncelle (raporun kendisi `raw/agent-output/` içinde, **DEĞİŞTİRME**,
   kalır — o da bir ham kaynaktır).
6. Projenin `log.md`'sine ve global `log.md`'ye giriş ekle.

### QUERY (arama ve yanıtlama)
Kullanıcı bir soru sorar veya bir konu açar:
1. Önce `index.md` + `network.md` oku → hangi katman ilgili?
2. `CLAUDE.md` §3 klasör ağacına bak → dosya nerede olmalı?
3. İlgili `projects/<proje>/` varsa → `PROJECT.md` → `log.md` (son) →
   `decisions/` → `sources/`
4. Kullanıcının **tercihi veya tepkisi**yle ilgiliyse → `profile/user.md` +
   `profile/preferences.md` + **`profile/reactions.md`** (biri diğerinin
   yerine geçmez, üçü birlikte okunur)
5. Yoksa ilgili `concepts/` veya `entities/` sayfasını aç.
6. Cevap ver. Her iddianın yanında `[[bağlantı]]` ver.
7. Yeni bir karar çıkarsa → `decisions/` altında atomik sayfa aç.
8. `query` girişini `log.md`'ye yaz.

### LINT (haftalık/aylık)
Kontrol eder: çelişkiler, eskimiş iddialar, yetim sayfalar, eksik kavram
sayfaları, tek-yönlü cross-referanslar, `network.md`'de eksik cross-project
kararlar, `staging/`'de X günden uzun bekleyen taslaklar. `lint-report.md`
yazar, OTOMATİK DÜZELTME YAPMAZ.

**Ek kontrol — lessons-learning terfi taraması:**
Her projedeki `knowledge-base.md` taranır. Aynı kök nedenden doğan ders
**2+ projede** geçiyorsa `DEV_BRIEF.md` §3'e terfi adayıdır → kullanıcıya
tek seferde sor. Ajan terfi etmez, **Kütüphaneci terfi eder** →
bkz. §7 `LEARN — lessons-learning terfi döngüsü`.

**Ek kontrol — `knowledge-base.md` snapshot'ı:**
`raw/knowledge-base/<slug>/` altındaki son snapshot'ın satır sayısı ile
repodaki `knowledge-base.md` satır sayısı karşılaştırılır. Fark varsa
**yeni veri var** → snapshot alınır ve işlenir. Fark yoksa o klasöre
**tekrar bakılmaz.** Ajan tetiklemez, LINT tetikler.

**Ek kontrol — `DEV_BRIEF.md` senkron:**
`projects/_STANDARTLAR/DEV_BRIEF_YEREL_KOPYASI.md` tablosundaki `v`
sütunu ile vault kökündeki `DEV_BRIEF.md` sürümü karşılaştırılır.
Bayat **yerel kopya** varsa uyarı verir (brif güncellendi, repodaki kopya
eski kaldı).

**Ek kontrol — ham kaynak takibi:**
`ingest-manifest.md` ile `raw/`'ın gerçek durumu tutarlı mı? Manifest'te
✅ yazan ama sayısı artmış bir klasör, ya da hiç yazılmamış bir `raw/` alt
klasörü. **Manifest'in Bölüm 1'ini düzeltmek otomatik düzeltme değildir** —
o bir kayıt dosyasıdır, karar dosyası değil.

**Ek kontrol — doküman bayatlığı:**

Yapı değiştiğinde şu dosyaların **yeniden yazılmış olması** gerekir.
Aksi halde sistem sessizce bozulur. LINT bunları raporlar:

| Dosya | Bayatlarsa ne olur |
|---|---|
| `REPO_ROOT_AGENTS_STUB.md` | Ajan vault'u okur ama **bellek biriktirmez**; kullanıcı "hafıza yok" sanır. *2026-09-27'de 9/9 eksikti, gerçekleşti.* |
| `CODING_AGENT_PROMPT.md` + §8 | Ajan `preferences.md` / `reactions.md`'yi hiç okumaz |
| `MANUEL.md` | İlk kez açan kişi **yanlış klasöre** yazar, kuralları bilmez |
| `README.md` | "Kurulum adımları" bölümü yalan söyler |
| `LIBRARIAN_AGENT_PROMPT.md` | Kütüphaneci yeni klasörü taramaz |

Kontrol noktaları:
- `CLAUDE.md` §0 okuma sırası ↔ `CODING_AGENT_PROMPT.md` Katman 1 ↔
  `REPO_ROOT_AGENTS_STUB.md` ↔ `MANUEL.md` §5 — **dördü aynı sayıyı ve
  aynı dosyaları göstermeli.**
- `MANUEL.md` §1 haritası gerçek klasör ağacıyla uyuşmalı.
- `MANUEL.md` §3 tablosu `CLAUDE.md` §7.0 routing tablosuyla uyuşmalı.
- `index.md` §Operasyon dosyaları gerçek kök dosyaları göstermeli.

### LEARN (profil güncelleme — periyodik veya lint ile birlikte)
Son log/query/ingest geçmişini tara, tekrarlayan bir kullanıcı örüntüsü
var mı bak (tercih ettiği teknoloji, çalışma saatleri, karar verme tarzı).
`profile/patterns.md`'ye tarihli ve `(inferred, YYYY-MM-DD, N. gözlem)`
etiketli satır olarak ekle. 3+ gözleme ulaşan örüntü için kullanıcıya
sor, onay verirse `user.md` / `preferences.md`'ye taşı. **Asla doğrudan
yazma.**

Sohbetlerden gelen tepkiler için ayrı akış: `INGEST — chat` →
`profile/reactions.md`. 3+ tekrar eden tepki terfi adayıdır.

### LEARN — lessons-learning terfi döngüsü (`DEV_BRIEF.md`)

> **2026-09-28'de eklendi.** Kullanıcının amacı: her projede aynı hatayı
> tekrar etmeyelim. `knowledge-base.md` = projenin hata geçmişi,
> `DEV_BRIEF.md` = kişinin çapraz proje brifi. Aradaki köprü budur.

**İki katman ayrıdır ve karıştırılmaz:**

| Katman | Sahibi | Yaşam süresi | Değişiklik |
|---|---|---|---|
| `<proje>/knowledge-base.md` | **ajan** | proje ömrü | anında yazar |
| `DEV_BRIEF.md` | **Kütüphaneci** | sınırsız | sıkıştırarak yeniden yazar |

> Bu ayrım bozulursa ajan bir gün `knowledge-base.md`'yi yeniden yazarken
> geliştirici profilini de ezer. Vault'ta RFC 002 ↔ karar çatışmasının
> dosya seviyesindeki hali budur.

**Terfi ölçütü — kanıt sayısı, kapsamı:**

| Durum | Terfi? |
|---|---|
| Aynı ders **bir projede** 3+ kez | ❌ o projede kalır |
| Aynı ders **2+ projede** geçiyor | ✅ terfi adayı |
| Bir **kalıcı karar** (teknik tercih) | ✅ terfi adayı |
| Bir kerelik olay | ❌ |

> **⭐ Sayım kuralı (2026-09-28):** Kanıt sayılırken **gerçek hata
> kayıtları** sayılır. `knowledge-base.md`'de bir başlık üç şekilde olabilir:
>
> | Başlık tipi | Örnek | Sayılır mı |
> |---|---|---|
> | **Hata kaydı** — `### Problem` + `### Root Cause` + `### Solution` | `Vite Build Hatası: Could not resolve…` | ✅ **sayılır** |
> | ⭐ **Karar kaydı** — `### Karar` + `### Karar Gerekçesi` | `Mutasyonlarda POST kullanımı` | ⛔ **sayılmaz** — kendi taramasında değerlendirilir |
> | **İş kaydı** — ne yapıldı, ne eklendi | `✅ Confirmation Modal Standardı`, `QuestionList Modern Tasarım` | ⬜ **sayılmaz** |
> | **Günlük** — debug/ekleme/temizleme | `🔍 Debug Logları Eklendi!`, `✅ Debug Logları Temizlendi!` | ⬜ **sayılmaz** |
>
> ⭐ **Karar kayıtları neden sayılmaz?** (2026-09-29) Karar kaydı
> eklenince terfi ölçümü **yapay olarak şişerdi** — kararlar zaten
> terfi ediyorsa kanıt iki kez sayılırdı. ⛔ **Hata kanıtı = yalnız
> `Problem` + `Root Cause`.** Kararın kendi terfi yolu ayrıdır:
> 2+ projede aynı karar → **cross-project karar** + `network.md`
> (§7 *Snapshot adımı*, §6).
>
> **Gerekçe (diğer ayrım):** `ornek-frontend` KB'de 71 başlığın ~16'sı
> hata değil günlüktü. Ham sayımla kanıt **yapay olarak şişer** ve terfi
> **erken tetiklenir.** Gerçek oran: **71 başlık ≈ 55 sorun.**
> FE kanıtlarının bir kısmı (`E` UI standartları 12) bu yüzden **tek
> projede** sayıldı.
>
> **İstisna:** Bir kalıp yalnızca "iş kaydı" olarak geçiyorsa (ör. bir UI
> standardı, hata üretmemiş ama tutarlılık için konmuşsa), o zaman
> kanıt sayısı **1** kabul edilir ve terfi için bekler.

**Terfi adımı (LINT tetikler, kullanıcı da elle tetikleyebilir):**

1. Her projedeki `knowledge-base.md`'yi tara (bir ajanın okuması gerekmez;
   **Kütüphaneci tarar**).
2. Aynı/aynı kök nedene dayanan dersleri grupla.
3. Bir ders **2+ projede** geçiyorsa → terfi adayı.
   *(Sayıma yalnızca `Problem` + `Root Cause` içeren kayıtlar girer —
   "✅ Eklendi" / "🔍 Debug" gibi günlükler **sayılmaz.** Bkz. yukarıdaki
   sayım kuralı tablosu.)*
4. Kullanıcıya tek seferde sor: *"şunu `DEV_BRIEF.md`'ye ekleyeyim mi:
   '…'?"* → Onay verirse `DEV_BRIEF.md` §3'e **kanıt sayısıyla** yazılır.
5. `log.md`'ye kaydedilir.

### Snapshot adımı — `knowledge-base.md` → `raw/` ⭐

> **2026-09-28'de eklendi (kullanıcı kararı).** Ajan KB'ye **yazar,
> okumaz.** Kütüphaneci periyodik olarak **snapshot** alır.

**Akış:**

```
ajan knowledge-base.md'ye yazar      (izin yok, hızlı, yerel)
        ↓  tetikleyici: boyut eşiği · LINT · kullanıcı komutu
Kütüphaneci raw/knowledge-base/<slug>/<tarih>-<slug>-kb.md alır
        ↓  manifest watermark: satır sayısı
sadece YENİ satırlar işlenir → kaynak sayfa → terfi adayı
        ↓
DEV_BRIEF.md §3 ← ajan bunu okur (bir sonraki oturumda)
```

**Snapshot neden, güncelleme değil?** Yerel KB değişmeye devam eder.
Snapshot o andaki halini korur. Tarihli isim geçmişi silmez — LINT
istediğinde eski sürümü görebilir. `raw/` immutable olduğu için
dosya bir kez yazılır, sonra değişmez.

**Watermark:** manifest Bölüm 1'de **satır sayısı** tutulur.
`ornek-backend: 903 → 1204` ise 903'ten sonrası yeni veridir. Bu, zaten var olan
su seviyesi mantığının yeni bir kaynağa uygulanmasıdır — yeni mekanizma
icat edilmez.

**Tetikleyici — otomatik zamanlayıcı YOK.** Ajan bu vault'ta yaşamıyor;
tetikleyici ya kullanıcı komutu ya LINT olmalı. Eşik önerisi: **+500
satır** ya da proje başına 4-6 hafta.

**Kurallar:**

| | |
|---|---|
| Snapshot = ham veri | `raw/`'a girer, **kaynak sayfası olmaz** |
| Yerel KB = çalışma günlüğü | ajanın yaşayan dosyası, değişmeye devam eder |
| Tek doğruluk kaynağı | **snapshot** (vault'taki tarihli kopyadır) |
| Ajan okumaz | yalnızca yazar |
| Ajan vault okur | brif §3 + §7 konuları |

**İlk ingest notu (2026-09-28):** `ornek-backend` KB'si 903 satır / 20 case
içeriyor. `ornek-frontend` KB'si 6032 satır / ~80 case. **İkisi aynı anda
işlenmez** — küçükten başlanır, Kütüphaneci'nin kapasitesi kadar.
İşlenmemiş KB'ler manifest Bölüm 1'de `🔄` ile bekler.

**Kural:** Ajan `knowledge-base.md`'ye yazar, **Kütıphaneci** terfi eder.
Ajan `DEV_BRIEF.md`'yi **kendi başına düzenlemez** — bu dosya kullanıcının
profilidir, ajanın çalışma alanı değildir.

**Brif her zaman ince kalmalı (~200 satır).** `knowledge-base.md` şişer,
`DEV_BRIEF.md` **sıkıştırılır**. 10 ayrı case tek bir kurala indirgenir.
Şişerse brif de okunmaz hale gelir ve amacını yitirir.

**Çapraz-proje kanıt kaynakları** (terfi ölçümünde bunlar taranır):
- ⭐ Her projenin `knowledge-base.md`'si — **depo kökünde**. Örnek yol:
  `C:\devtools\...\ornek-backend\knowledge-base.md`
- `projects/_STANDARTLAR/decisions/` · `profile/*` · `log.md`


## 8) AI Kod Geliştirme Ajanları için Sözleşme

Ayrıntılı çalışma protokolü: `CODING_AGENT_PROMPT.md`. Bu bölüm
kısadır; ikisi birlikte geçerlidir.

**Bellek modeli:** Bu vault bir ikinci beyindir. Kod ajanı kod yazmadan
önce **okur**, karar verirken **anında yazar**, bitince **raporlar**.

### Okuma (9 adım — sıra, atlağın yok)


1. `CLAUDE.md` (Bölüm 8-9)
2. **`profile/preferences.md`** ← kullanıcının tercihleri, ajana da geçerli
3. **`profile/reactions.md`** ← kullanıcının **neye tepki verdiği**.
   `preferences.md` ne istediğini, bu dosya hangi çıktıya onay verdiğini
   ya da reddettiğini söyler. **Biri olmadan diğeri eksiktir.**
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

> **Kullanıcı kararı (2026-09-29):** *"repo ile çalışan kod ajanları
> **yazmak için vault'a gelemez**. Ancak **second brain yapısı için
> vault'a gelir** — okumak için."*

| | Nereye | Kim |
|---|---|---|
| **Yazma** | ⭐ **`<proje>/knowledge-base.md`** (proje dizini) | **kod ajanı** |
| **Yazma** | `raw/agent-output/` · `sources/` · `decisions/` · `log.md` | **Kütüphaneci** |
| **Okuma** | vault (`CLAUDE.md` · `profile/` · `decisions/` · `DEV_BRIEF` §3) | **kod ajanı** ✅ |

> ⭐ **Ajanın vault'taki tek yazma yetkisi yoktur.** `raw/agent-output/`
> **Kütüphaneci'nindir** — ajan ulaşmaz, yazmaz.

**KAYIT 1 — `knowledge-base.md` (tek yazma hedefi, proje dizininde)** ⭐

| | |
|---|---|
| **Ne zaman yazılır** | Hata çözüldüğünde **ve** kalıcı karar verildiğinde |
| **Nerede** | ⭐ **proje kökünde** — `C:\devtools\...\ornek-backend\knowledge-base.md` |
| **Ne okunur** | ⛔ **Ajan okumaz** — 200 KB'a çıkabilir (~50k token) |

> ⭐ **Neden okunmuyor?** Ajanın *"daha önce oldu mu?"* sorusunun cevabı
> zaten `DEV_BRIEF.md` §3'te. Bu dosya **kayıt içindir**, komut değil.

**KAYIT 2 — Karar, KB'ye de yazılır** ⭐

> **Kullanıcı kararı (2026-09-29):** *"daha önce kod ajanına
> `knowledge-base.md` yaz dediğimiz yere **kullanıcının kararlarını da**
> yaz demek sadece."*

Bu dosya **iki kayıt türü** taşır:

| | Hata kaydı | ⭐ **Karar kaydı** |
|---|---|---|
| **Bloklar** | `Problem` · `Root Cause` · `Solution` · `Files Changed` | `Karar` · `Karar Gerekçesi` · `Değerlendirilen Alternatifler` · `Files Changed` |
| **Terfi sayımı** | ✅ sayılır | ⛔ **sayılmaz** — ayrı kanıt türüdür |

> ⭐ **Ayırma nedeni:** Karar kaydı eklenince terfi ölçümü **yapay olarak
> şişerdi** — kararlar zaten terfi ediliyorsa kanıt iki kez sayılırdı.
> ⛔ Kural: **hata kanıtı = yalnız `### Problem` + `### Root Cause`
> birlikte.** Kararın kendi terfi yolu ayrıdır: 2+ projede aynı karar →
> **cross-project karar** + `network.md` (§6).

> ⭐ **Aynı olayda ikisi de olabilir.** Hata çözümü kalıcı kural
> doğuruyorsa **tek kayıtta** hem `Root Cause` hem `Karar` açılır.
> Bölme — bağ kopar.

**⛔ Her karar yazılmaz:**

| | Yaz | Yazma |
|---|---|---|
| ✅ | Kural doğuracak karar (enum değeri, katman sınırı, kütüphane, convention) | ⛔ O an için çözülen, kalıcı olmayan düzeltme |
| ✅ | Alternatifleri **değerlendirilmiş** seçim | ⛔ *"Zorunda kaldım"* — bu `Root Cause`'dur |
| ✅ | Gerekçesi **bir sonraki oturumu etkileyecekse** | ⛔ Dosya/fonksiyon adı gibi uygulama detayı |
| | | ⛔ Bu KB'de **bulunan** kararı tekrar etme — `DEV_BRIEF.md` §3 taşır |

> ⛔ **"Değerlendirilen alternatifler" boş bırakılamaz.** Ajan
> `"değerlendirilmedi"` diyemez. Üç dürüst seçenekten biri yazılır:
>
> | Durum | Nasıl yazılır |
> |---|---|
> | Gerçekten düşünüldü | Alternatif + **somut** gerekçe |
> | Ajan düşünmedi | ⚠️ *"Ajan bu alternatifi değerlendirmedi"* + nedeni — **utanç değil, dürüstlük** |
> | Kaynakta yok | *"KB kararı — kaynakta alternatif tartışması yok, ajan **uydurmadı**"* |
>
> ⭐ Boş bölüm *"tek seçenek vardı"* anlamına gelmez, **"gözden
> kaçırıldı"** anlamına gelir. (Kanıt: 2026-09-28, iki KB kararında
> boş kalmıştı — `ingest-manifest` #34.)


### Otomatik yükleme (elle yapıştırmadan)

Kullanıcı, kod reposunun köküne `AGENTS.md` kopyalayarak bu protokolü
**her oturumda otomatik** yükletebilir. Şablon:
`REPO_ROOT_AGENTS_STUB.md` — içinde `<VAULT_YOLU>` ve `{{PROJE_SLUG}}`
placeholder'ları vardır; kullanıcı doldurur.

> ⚠️ Bu stub **kendi kural dosyasıyla senkron olmalıdır.** `AGENTS.md`
> içeriği bayatlarsa (eski okuma listesi, karar kaydı olmadan) ajan vault'u
> okur ama **bellek biriktirmez** — ve kullanıcı "hafıza yok" diye
> düşünür. LINT, stub'ı da kontrol etmelidir.

### Mevcut bir kararı değiştirmek

Ajan eski sayfayı değiştirmez. Yeni karar dosyası yazar,
`supersedes: <eski-slug>` doldurur. Kütüphaneci taşırken
`status: superseded` işaretler.

### Halüsinasyon koruması

- Var olmayan dosya/sınıf/metot/endpoint **uydurulmaz** — önce doğrulanır.
- Her teknik iddianın arkasında kaynak olur.
- Tahmin **"tahmin:"** diye işaretlenir.
- Kod ile karar çelişirse ajan **kendi kararıyla geçmez**, sorar.
- Yarım kalan varsa **söylenir** ("tümünü yaptım" yalanı yasak).

### Kütüphaneci'nin taşıma işi (mekanik)

`INGEST — agent-output` akışında **iki ayrı iş** vardır:

1. **Karar dosyaları** → `projects/<proje>/decisions/<slug>.md` konumuna
   **taşınır**. Kaynak iki yerden olabilir:
   - `raw/agent-output/<proje>/kararlar/*.md` (klasör varsa)
   - ⭐ **doğrudan proje `knowledge-base.md`'nin `### Karar` blokları**
     — kod ajanı artık vault'a yazmadığı için **bu asıl kaynaktır.**
   İçerik değişmez; yalnızca:
   - `decided_by: code-agent` → `confidence: stated`e karşılık gelen
     değerlendirme yapılır (Kütüphaneci kendi değerlendirmesi)
   - `scope: cross-project` ise `global/decisions/` pointer'ı düşülür ve
     `network.md` güncellenir
   - eski kararın yerine geçiyorsa `status: superseded` + `superseded_by`
   - dosya adı kebab-case'e normalize edilir
   - sonra proje `log.md`'ye `## [YYYY-MM-DD] decision | <slug>` düşülür

2. **Oturum raporları** → `projects/<proje>/*` altına **entegre edilir**
   (yorum gerektirir: hangi sayfalara ne yazılacak, hangi entity/concept
   doğdu). Bu zaten mevcut akıştır.

## 9) Kesin Kurallar

- ⛔ **KOD REPOSUNDAKİ KODU DÜZENLEME.** Kütüphaneci (bu ajan)
  **hiçbir kod dosyasını değiştirmez** — `.java`, `.ts`, `.tsx`, `.js`,
  `.sql`, config dosyası, ne olursa olsun. Kod ajanlarının işidir.
  > **2026-09-28'de kullanıcı hatırlattı:** *"öncelikle şunu anlamak
  > istiyorum; kod içinde bir düzenleme mi yapıyorsun? eğer öyle ise
  > yapmanı istemiyorum. sadece second brain yapısı için ilerleyelim."*
  > Ajan, vault okurken ve bulgu raporlarken kod değiştirmemelidir —
  > **bulgu kaydı, kod değişikliği değildir.**
  >
  > **Kütüphaneci ne yapar:** bulur, kanıtını (dosya yolu + satır) toplar,
  > karar sayfasına yazar, kullanıcıya sunar. Kod ajanı uygular.
  > **Kütüphaneci ne yapmaz:** düzenleme, refactor, migration, build.
  >
  > **İstisna:** kullanıcı açıkça "bunu uygula" derse. O zaman da
  > commit öncesi onay alınır ve değişiklik `log.md`'ye yazılır.
- ⭐ **Bu vault bir git reposudur** (2026-09-29). Kaynak belge:
  *"Wiki bir git repo. Versiyon tarihi, branch'leme bedava."*
  → `[[sources/llm-wiki-deseni-kaynak-belge]]`
  - **Kütüphaneci commit atmaz.** Değişiklik yaptıktan sonra
    `git status` ile neyin değiştiğini **kullanıcıya gösterir**;
    commit kararı kullanıcıya aittir.
  - `.gitignore`'a **asla** dokunma — özellikle `_GIZLI/` satırı.
    Şifreli kasa git geçmişine **giremez**; geçmiş kalıcıdır.
  - Wiki katmanı (`sources/` `concepts/` `entities/` `global/`
    `projects/` `profile/` `log.md` `index.md` `CLAUDE.md`) **her zaman**
    versiyondadır. `raw/`'ın ağır kısımları dışarıdadır — yeniden
    üretilebilir.
- `raw/` immutable — sadece kullanıcı (veya kod ajanı `agent-output`
  altına) ekler; hiçbir ajan buradaki mevcut dosyayı değiştirmez/silmez.
  - ⭐ **Açık istisna (2026-09-30, manifest #78):** `raw/` altındaki
    **yeniden üretilebilir** içerik ajan tarafından yönetilebilir —
    `_SABLON/` şablonları ve `raw/knowledge-base/` snapshot'ları bunlar
    dış kaynaktan tazelenir. Bunlar **kullanıcının malzemesi değildir.**
    Yine de: **dosya yok edilmez, `archive/`'a taşınır** ve
    `ingest-manifest.md`'ye kaydedilir. İstisna **varsayılan değil,
    adıyla yazılır** — yukarıdaki yasak bu üç konum dışında geçerlidir.
  - ⛔ **Kanıt:** `raw/` parmak izi (`RAW_ISLEM_PROMPT.md` ADIM 0/5)
    `COUNT` düşüşünü otomatik yakalar. 2026-09-30'da bu yolla
    Kütüphaneci'nin kendi ihlali bulundu.
  - ⛔ **Kanıt 2 (2026-10-01): `raw/` içinde `git` ÇALIŞTIRMA.**
    `raw/projects/MyFileSystemMCP/` altında `git log` çalıştırmak
    `.git/index` (stat-cache) dosyasının **baytlarını değiştirdi.**
    Parmak izi `A313297076C14817` → `0663F61FB3E682F7` oldu ve
    ihlali **otomatik yakaladı** — mekanizma çalışıyor.
    ⭐ Bir `raw/` altındaki repoda `git status/log/diff` çalıştırman
    gerekirse: **canlı repodan** çalıştır, ya da `--no-optional-locks`
    ile `GIT_OPTIONAL_LOCKS=0` ver.
- **`raw/` gizli veri: ŞİFRELİ kutuya yaz, düz metne asla**
  (2026-09-28 değişikliği →
  `[[projects/_STANDARTLAR/decisions/gizli-bilgi-sifreli-saklanir]]`,
  eski kural `raw-gizli-veri-kopyalanmaz` **iptal**):
  Parola, token/API anahtarı, IBAN, kart/TC/vergi no, seed ifadesi,
  ağ şifresi gibi `raw/` gizli verileri `sources/`, `entities/`,
  `concepts/`, `global/` katmanlarına **aktarılmaz.** Bunun yerine
  **şifreli** olarak `_GIZLI/kayitlar/<slug>.gizli` altına yazılır
  (aracı: `tools/secret-vault/`).
  - `_GIZLI/INDEX.md` (hangi sır var, ne için, nerede) → **serbest okunur**
  - Başlık (`slug`/`tur`/`amac`) → **serbest okunur**
  - ⛔ **Değeri çözme.** `decrypt`/`coz` komutunu **çalıştırma**,
    parolayı isteme, tahmin etme, varsayma. Kullanıcı onay verirse sana
    **şifreli metni** verir; çözmene gerek yok.
  - ⛔ Şifreli metni çözüp **hiçbir yere yazma** (kod, log, cevap, KB).
  - Kural: [[_GIZLI/README]]
- Kaynaksız iddia yasak — her önemli cümle bir `source:` referansı taşır.
- Sayfa silinmez, `archive/`'a taşınır.
- Çelişkiler silinmez, `## ÇELİŞKİ` başlığıyla görünür şekilde işaretlenir.
- `profile/user.md` ve `profile/preferences.md` yalnızca kullanıcının
  **açık onayıyla** değişir. `patterns.md`'deki bir örüntü 3+ gözleme
  ulaştığında ajan terfi teklifi sunar; onay gelirse taşır.
- Bir kararın tek doğruluk kaynağı vardır (proje-lokal); `global/` sadece
  pointer tutar, kopya değil. Sahipsiz projeler arası kararlar
  `projects/_STANDARTLAR/decisions/` altında yaşar.
- ⭐ **Kod ajanları vault'a hiçbir şey yazmaz.** Tek yazma hedefi
  **proje dizinindeki `knowledge-base.md`**'dir (hata + karar kaydı).
  Vault'a yazan tek ajan **Kütüphaneci**'dir: `raw/` · `sources/` ·
  `projects/` · `global/` · `entities/` · `concepts/` · `log.md`.
  Kod ajanı vault'u **okumak** için kullanır — second brain.
- Her operasyon (ingest/query/lint/learn) ilgili `log.md`'ye kaydedilir.
- Dosya adları **kebab-case** — ⛔ **istisna: proje kimliği camelCase.**
  Kebab-case yalnız **wiki sayfaları** içindir (kaynak · kavram · karar ·
  entity · synthesis `.md` dosyaları). Proje klasörü adı ve ondan türeyen
  slug **camelCase**'dir ve repo adıyla **birebir** örtüşür.
  → [[projects/_STANDARTLAR/decisions/proje-isimlendirmesi-camelcase]]
  ⭐ Sebep: slug repo adından farklı görününce vault'ta **iki isim** birden
  yaşar ve ajan hangisini arayacağını bilmez. 2026-10-01'de kebab-case
  slug üretiliyordu, bu yüzden oluştu.

## 10) Şemanın Evrimi

Bu dosya sabit değildir. Bir kural pratikte çalışmıyorsa, güncelleyin;
değişiklik `log.md`'ye `## [YYYY-MM-DD] schema-change | <özet>` olarak
düşülür ki sonraki oturumlar neyin neden değiştiğini bilsin.
