# Repo Kökü `AGENTS.md` Şablonu

> **Bu dosyayı kod projenin kendi git deposunun köküne `AGENTS.md` olarak
> kopyala.** Claude Code, Cursor, Codex ve Antigravity (v1.20.3+) bir
> repo'nun kökünde `AGENTS.md` varsa **otomatik** okur. Antigravity önce
> `GEMINI.md`'ye baktığı için aynı içerikle bir `GEMINI.md` kopyası da
> bırakabilirsin.
>
> Kopyaladıktan sonra **iki placeholder'ı doldur** ve bir daha elle hiçbir
> şey yapıştırma:
> - `{{VAULT_YOLU}}` → vault'unun mutlak yolu
> - `{{PROJE_SLUG}}` → bu kodun karşılık geldiği proje klasörü adı
>   (örn. `benimUygulamam`, `mislik-api`)
>
> **Birden fazla kod projen varsa** her repo köküne ayrı bir kopya koy,
> `{{PROJE_SLUG}}` farklı olur. `{{VAULT_YOLU}}` aynı kalır.
>
> ⚠️ Bu şablon **2026-09-27'de yeniden yazıldı.** Önceki sürüm 5 adımlık
> okuma listesini içeriyordu ve `profile/preferences.md`, `_STANDARTLAR`,
> `log.md`, karar kaydı ve halüsinasyon kurallarını içermiyordu — yani
> vault okunsa bile bellek biriktirilmiyordu. Eski kopyaları olan repo'lar
> varsa bu dosyayı oraya da güncelle.

---

## Kopyalanacak içerik

```markdown
# AGENTS.md

Bu projenin kalıcı hafızası ve karar geçmişi bu repo'da DEĞİL, şu
Obsidian vault'unda tutulur:

  {{VAULT_YOLU}}

Bu vault bir ikinci beyindir. Buradaki dosyalar bağlayıcıdır.

═══════════════════════════════════════════════════════════════
KOD YAZMADAN ÖNCE — SIRAYLA OKU (9 adım, atlağın yok)
═══════════════════════════════════════════════════════════════

1) {{VAULT_YOLU}}/CLAUDE.md
   → Bölüm 8 (kod ajanı sözleşmesi) ve Bölüm 9 (kesin kurallar)
2) {{VAULT_YOLU}}/profile/preferences.md
   → Projenin sahibinin tercihleri. SANA DA GEÇERLİDİR.
   → "Teori verme, kod ver" · "Yarım çözüm kabul edilmez" ·
     "Türkçe" · "Mevcut akışı bozma"
   → Bu adım atlanırsa kullanıcının isteklerini kaçırırsın.
3) {{VAULT_YOLU}}/profile/reactions.md
   → Kullanıcının **neye TEPKİ verdiği**.
   → preferences ne istediğini, BU DOSYA hangi çıktıya onay verdiğini /
     reddettiğini söyler. BİRİ OLMAKTAN DİĞERİ EKSİKTİR.
   → §Ret edilenler = YASAK LİSTESİ, oradaki hiçbir şeyi yapma.
   → §Onaylanmış kalıplar = standart, oradaki biçimi kopyala.
4) {{VAULT_YOLU}}/projects/_STANDARTLAR/PROJECT.md
   → ve projects/_STANDARTLAR/decisions/ altındaki TÜM sayfalar
   → Her projeye geçerli kurallar. ATLANMAZ.
5) {{VAULT_YOLU}}/projects/{{PROJE_SLUG}}/PROJECT.md
6) {{VAULT_YOLU}}/projects/{{PROJE_SLUG}}/architecture.md
7) {{VAULT_YOLU}}/projects/{{PROJE_SLUG}}/decisions/ → TÜMÜ
8) {{VAULT_YOLU}}/projects/{{PROJE_SLUG}}/log.md → SON 10-15 SATIR
9) {{VAULT_YOLU}}/projects/{{PROJE_SLUG}}/sources/ → EN SON 3-5 dosya

Bu 9 adım tamamlanmadan koda dokunma. Projeyi ve kararlarını keşfetmeye
çalışma — zaten yazılı.

═══════════════════════════════════════════════════════════════
OKUMA KANITI — koda geçmeden önce yanıtında yaz
═══════════════════════════════════════════════════════════════

  "Bu iş için geçerli kararlar:
   - <karar-slug> → <tek cümle özet>
   Yoksa: 'Bu iş için geçerli bir karar bulamadım.'"

Her kararı adıyla belirt, yolunu yaz. Karar adı UYDURMA.
Hatırlayamadığını yazamıyorsan hatırlamamışsındır.

═══════════════════════════════════════════════════════════════
YAZMA — TEK HEDEF: BU PROJENİN knowledge-base.md DOSYASI
═══════════════════════════════════════════════════════════════

⛔ VAULT'A HİÇBİR ŞEY YAZMA. Vault senin hafızanı OKUMAK içindir,
yazmak değil. Tek yazma hedefin bu proje dizinindeki dosyadır:

  knowledge-base.md          (proje kökü — senin yazdığın dosya)

Hata çözdüğünde VE kalıcı bir karar verdiğinde (dosya yapısı, kütüphane,
şema, modül sorumluluğu, kural istisnası) HEMEN buraya yaz.

── HATA KAYDI ──────────────────────────────────────────────
  ## <kısa başlık> (YYYY-MM-DD)
  ### Problem
  ### Root Cause
  ### Solution
  ### Files Changed

── KARAR KAYDI ─────────────────────────────────────────────
  ## <karar adı> (YYYY-MM-DD)
  ### Karar
  ### Karar Gerekçesi
  ### Değerlendirilen Alternatifler
  ### Files Changed

⛔ "Değerlendirilen Alternatifler" boş bırakılamaz. Üç dürüst seçenek:
  gerçekten düşündüysen somut gerekçe · düşünmediysen
  ⚠️ "Ajan bu alternatifi değerlendirmedi" + neden · kaynakta yoksa
  "kaynakta tartışma yok, uydurmadım".

⛔ HER KARAR YAZILMAZ:
  ✅ kural doğuracak karar · değerlendirilmiş seçim · sonraki oturumu
     etkileyecek gerekçe
  ⛔ geçici düzeltme · dosya adı gibi uygulama detayı · KB'de zaten
     bulunan kararı tekrar etme

Yazmadığın karar, oturum kapanınca kalıcı belleğe hiç geçmez ve bir
sonraki ajan onu YENİDEN verecek.

⛔ BU DOSYAYI OKUMA. 200 KB'a çıkabilir (~50k token). "Daha önce oldu
mu?" cevabı zaten {{VAULT_YOLU}}/DEV_BRIEF.md §3'te. Bu dosya yazmak
içindir.

⛔ Kütüphaneci senin bu dosyanı okuyup terfi eder; vault'taki
`decisions/` sayfalarına O taşır. Sen o katmana dokunmazsın.

═══════════════════════════════════════════════════════════════
HALÜSİNASYON KORUMASI
═══════════════════════════════════════════════════════════════

a) Var olmayan dosya/sınıf/metot/endpoint adı YAZMA. Önce doğrula
   (grep/ls). Emin değilsen SOR — tahmin yürütme.
b) Her teknik iddianın arkasında kaynak olsun: karar sayfası,
   architecture.md, kullanıcı talimatı veya okuduğun kod.
c) Tahmin yaparsan "tahmin:" diye işaretle.
d) Kod bir kararla çelişiyorsa KENDİ KARARINLA GEÇME. Dur, sor.
e) Kodu değiştirmeden önce referanslarını ara; silme/taşıma yapma.
f) Yarım kalan/emin olmadığın şeyi SÖYLE. "Tümünü yaptım" yalanı yasak.

═══════════════════════════════════════════════════════════════
BİTİRİRKEN — TEK KAYIT
═══════════════════════════════════════════════════════════════

knowledge-base.md'ye yazdığın her şey yeterlidir. Başka hiçbir yere
YAZMA — ne vault'a, ne raw/agent-output/'ya, ne oturum raporu.

Kütüphaneci senin KB'yi okur, snapshot'ını alır ve kalıcı kararları
vault'un `projects/{{PROJE_SLUG}}/decisions/` katmanına kendisi taşır.
Senin işin biter.

Repo'nun içinde de başka hiçbir wiki/doküman dosyası YAZMA.

═══════════════════════════════════════════════════════════════
OTURUM SONU KONTROLÜ
═══════════════════════════════════════════════════════════════

☐ 9 adım okundu mu? (özellikle preferences.md, reactions.md, _STANDARTLAR)
☐ Okuma kanıtı yazıldı mı?
☐ HER karar için knowledge-base.md'de `### Karar` + gerekçe var mı?
☐ Çözülen her hata için `### Problem` + `### Root Cause` var mı?
☐ VAULT'A HİÇBİR ŞEY YAZILMADI mı?
☐ Doğrulayamadığım bir şey var mı — yazdım mı?
```

---

## Bu nasıl çalışır?

```
        ┌──────────────────────────────────────────┐
        │  Kod reposu (ör. C:\devtools\Projects\benim-uygulamam) │
        │  kökünde AGENTS.md  ← bu şablon kopyalanır│
        │  + knowledge-base.md  ← ajanın tek hedefi│
        └───────────────┬──────────────────────────┘
                        │ ajan buraya girer
                        ▼
        ┌──────────────────────────────────────────┐
        │  VAULT  (kalıcı hafıza — SALT OKUNUR)    │
        │  CLAUDE.md · profile/ · decisions/ ·     │
        │  DEV_BRIEF.md §3   → ajan sadece OKUR     │
        └───────────────┬──────────────────────────┘
                        │ ajan KARAR VERİR
                        ▼
        ┌──────────────────────────────────────────┐
        │  Proje dizini · knowledge-base.md         │
        │  hata kaydı + karar kaydı  (ajan yazar)   │
        └───────────────┬──────────────────────────┘
                        │ Kütüphaneci okur (snapshot)
                        ▼
        ┌──────────────────────────────────────────┐
        │  KÜTÜPHANECİ oturumu                     │
        │  kararları taşır → projects/*/decisions/  │
        │  terfi eder → DEV_BRIEF.md §3             │
        └───────────────┬──────────────────────────┘
                        │
                        ▼
              sonraki ajan oturumu okur
```

## Üç farklı ajan, üç farklı dosya — karıştırma

| Ajan | Hangi dosya | Ne yapar |
|---|---|---|
| **Kütüphaneci** | `LIBRARIAN_AGENT_PROMPT.md` | `raw/`'daki yeni içeriği tarar, `projects/`'e taşır, `profile/`'ı günceller — **vault'un tek yazarı** |
| **Kod ajanı** | repo kökündeki `AGENTS.md` | Kod yazar + **`knowledge-base.md`'ye hata/karar yazar**. Vault'u yalnız **okur** |
| **Sen** | — | `raw/projects/<proje>/` altına belge koyarsın |

## Ben nereye belge koyacağım?

| Ne | Nereye | Sonra ne olur |
|---|---|---|
| **Kendin** yazdığın belge (spec, not, ekran görüntüsü, karar metni) | `raw/projects/<slug>/` | Kütüphaneci okur, `projects/<slug>/sources/` altına özetler |
| Kod ajanının kararı/hata kaydı | ⚠️ **repo kökündeki `knowledge-base.md`** | Kütüphaneci okur, `projects/<slug>/decisions/`'ye taşır, gerekiyorsa terfi eder |
| Aklında bir karar varsa | Yazmadan önce **söyle** | Kod ajanı `knowledge-base.md`'ye yazar; sen de istersen `projects/<slug>/decisions/` altına yazabilirsin (Kütüphaneci seviyesi) |

**Kural (2026-09-29):** ⛔ *Kod ajanı vault'a **yazmaz** — tek hedefi
proje dizinindeki `knowledge-base.md`'dir.* `raw/agent-output/`
**Kütüphaneci'nindir.** `projects/` katmanına doğrudan yazma — bu ajan
içindir ve senin yazın tutarsızlaşır.
