# MANUEL — senin rehberin

> ⭐ **Bu dosya senin için.** Ajan değil. Kod ajanları `CLAUDE.md` okur;
> bu dosya "dosyayı nereye atıyorum?" sorusuna cevap verir.

## ⭐ 1) Dosya nereye gider? (tek bakışta)

| Attığın şey | Nereye |
|---|---|
| Bir klasör | `raw/` altında **bir yer** — ajan yerleştirir |
| Ajanın hata/çözüm dokümanı | `raw/agent-output/<proje>/` |
| Projeye ait spec · not · karar metni | `raw/projects/<proje-adi>/` |
| Genel okuma malzemesi (makale · PDF) | `raw/articles/` · `raw/transcripts/` |
| Sınıflandırmak bilmediğin her şey | `raw/inbox/` |
| Kişisel teknik not (know-how) | `raw/knowhow/` |
| ⭐ **Bir sohbet** | `raw/chats/<ajtör>/YYYY-MM-DD-<konu>.md` |
| Şifrelenmesi gereken sır | `tools/secret-vault/` → `_GIZLI/kayitlar/` |

**Ajan adı klasörleri:** `opencode/` · `claude/` · `chatgpt/` · `gemini/` · `diger/`

---

## ⭐ 2) Üç komut — ne zaman hangisi?

| Komut | Ne zaman | Kime |
|---|---|---|
| ⭐ **`hazırla`** | **bir kez**, bu vault'u ilk açtığında | bu klasördeki ajan |
| `PROJE_INIT_REPO.md` | **her yeni projede** | kod ajanına |
| `PROJE_INIT_VAULT.md` | **her yeni projede** (repo'dan sonra) | bu vault'taki ajana |
| `RAW_ISLEM_PROMPT.md` | `raw/`'a yeni belge koyduğunda | bu vault'taki ajana |

### Yeni proje akışı (iki komut neden iki?)

```
1. Proje klasöründeki kod ajanına:
   "Bu projeyi second brain yapısına bağla.
    <vault>\PROJE_INIT_REPO.md adımlarını uygula."

2. Sonra burada:
   "Yeni proje vault tarafını hazırla: <slug> · <stack>"
```

> ⛔ **Ajanın vault'a yazma yetkisi yoktur.** Bu ikiyi ayırmak kuralı
> mekanikleştirir — güvene gerek kalmaz.

---

## 3) Sohbet kaydı — tatmin sinyali ⭐

Bu vault'un **en değerli** girdisi sohbetlerdir. Çünkü bir ajanın
*"ne yapmışsın"* bilgisi değil, **senin neye tepki verdiğin** bilgisi
kendisini geliştirir.

### Adım 1 — kaydet

```
raw/chats/<ajtör>/YYYY-MM-DD-<konu>.md
```

Şablon: `raw/chats/_SABLON/chat-sablonu.md`

### Adım 2 — doldur

| Blok | Kural |
|---|---|
| `<siz>` | ⭐ **senin** mesajın. Etiketi atlama. |
| `<asistan>` | bağlam. Kısaltmak istersen kısalt — **tamamı gerekmez** |
| `cwd` | sohbetin geçtiği klasör → otomatik projeye bağlanır |
| `project` | `cwd` bir projeye denk geliyorsa |

> ⭐ **Etiketsiz metin "senin söylemediğin bir şey" sayılır** ve işlenmez.

### Adım 3 — ajan işler

Ajan **yalnız `<siz>` bloklarını** okur. Çıkan sonuç:

| Ne çıkarsa | Nereye |
|---|---|
| `reddet` tepkisi | `profile/reactions.md` §**Ret edilenler** = ⭐ **yasak listesi** |
| 3+ aynı tepki | §**Tekrarlayan tepkiler** → `preferences.md`'ye terfi |
| ilk kez görülen | §**Tek seferlik sinyaller** |

### Kaydetmeden önce 3 soru

1. **Bir şeyi beğendim mi, değiştirmek istedim mi, istemedim mi?**
2. **Aynı tepkiyi daha önce verdim mi?** → 3+ ise terfi olur.
   ⛔ **Eskisini silme** — aynı tepkinin 3. kez görünmesi gerekir.
3. **`cwd` yazdım mı?** → yoksa sadece genel işlenir.

### ⭐ Toplu içe aktarma

Çok sayıda sohbetin varsa ajana toplu ithal yaptırabilirsin. Her aracın
kendi dökümü vardır (`export` komutu, JSON, SQLite…). Ajan `raw/`'a
kopyalar, sonra bu akış işler.

---

## 4) `raw/` kuralları — ⭐ en sık ihlal edilen

| | |
|---|---|
| **Okuma** | Yalnızca `raw/` altından |
| **Dışarıdan dosya lazımsa** | ⛔ doğrudan işleme → **önce `raw/`'a kopyala** |
| **Kopyalama** | Kendi kopyasını yapar → **orijinaline dokunmaz** |
| **Silme** | ⛔ `raw/` dışında **hiçbir dosya silinmez** |
| **Canlı proje dosyası** | `.env` · config · migration → **asla silinmez, asla düzenlenmez** |
| **`raw/` içinde `git`** | ⛔ çalıştırma — `.git/index` bozulur |

> ⚠️ Bu kural bir tuzaktan doğdu: bir projedeki canlı config dosyası
> için işlem yapıldı, sonra *"silebilirsin"* denildi. O dosya
> **yapılandırmadır** — silinseydi geliştirme ortamı kırılırdı.

### ⭐ Gizli kalıp taraması

Ham kaynak özetlenmeden **önce** otomatik taranır:
JWT · `password:` · bcrypt · 32+ hex (api key) · private key · AWS · `jdbc:`

⛔ Bulunan **değerler** hiçbir wiki katmanına yazılmaz — yalnız
**satır no + tür**. `log.md`'ye de yazılmaz.

---

## 5) Bir belge ekledim, ne olur?

```
Sen: raw/ altına dosya atarsın
        ↓
Ajan: ADIM 0 — kaynak raw/ mı?  (değilse → kopyala)
        ↓
     ADIM a — ingest-manifest'e bak: yeni var mı? (yoksa BİT)
        ↓
     ADIM a0 — .vaultignore: bu yol taranıyor mu? (hayırsa BİT)
        ↓
     ⭐ Gizli kalıp taraması
        ↓
     ADIM b — routing tablosu: nereye gider? (CLAUDE.md §7.0)
        ↓
     ⭐ DEĞER KAPISI — işlenmeye değer mi?
        ↓
     5 maddelik özet → sana göster → onay iste
        ↓
     sources/ + entities/ + concepts/ + index.md + log.md
```

### ⭐ Değer kapısı

Her bilgi işlenmez. Şu 5'inden **en az biri** doğruysa işlenir:

**Örüntü** · **Karar** · **Sen** · **Bağlantı** · **Gelecek eylem**

Hiçbiri değilse → **işlenmez**, ama ⛔ **sessizce de geçilmez** —
`ingest-manifest.md`'ye "değersiz" diye yazılır.

> *"3 yıl önce 4'cü haftanın 2'ci günü hangi kahvaltıyı yaptım" sorusunun
> yanıtı. Doğru da olabilir yanlış da. **Hiçbiri önemli değil — ve bu
> önemli bir bilgi.***

---

## 6) Karar yazma

| | |
|---|---|
| **Nerede** | `projects/<proje>/decisions/<slug>.md` (atomik, tek konu) |
| **Slug** | kebab-case |
| **Cross-project** | `scope: cross-project` + `network.md`'ye satır + `global/`'a **sadece pointer** |
| **Bir kararı değiştirmek** | Yeni sayfa + `supersedes:` · eski → `status: superseded` |

> ⭐ **İki yerde tutma.** Asıl sayfa `projects/*/decisions/`, `global/`
> sadece gösterge. Aynı karar iki yerde yaşarsa biri bayatlar ve ajan
> bayat olanı okur.

---

## 7) Kod ajanı neye dokunabilir?

| | |
|---|---|
| ⛔ Vault'a **hiçbir şey** | Yazma yetkisi yok |
| ✅ `<proje>/knowledge-base.md` | **tek** yazma hedefi |
| ✅ Vault **okuma** | anayasa · profil · kararlar |

### ⭐ `knowledge-base.md`'ye ne yazılır?

| Kayıt | Bloklar |
|---|---|
| **Hata** | `Problem` · `Root Cause` · `Solution` · `Files Changed` |
| **Karar** | `Karar` · `Karar Gerekçesi` · `Değerlendirilen Alternatifler` · `Files Changed` |

⛔ *"Değerlendirilen alternatifler" boş bırakılamaz* — *"değerlendirmedim"*
yazmak dürüstlüktür, boş bırakmak değil.

---

## 8) Bakım

| Ne | Ne zaman |
|---|---|
| `lint-report.md` | haftalık/aylık |
| `ingest-manifest.md` §2 bayrakları | her işlemde |
| `log.md` | **her** işlemde |
| `profile/patterns.md` | örüntü görünce |
| `.vaultignore` | taranmasını istemediğin yol olunca |

**Ajan otomatik düzeltme yapmaz** — bulur, raporlar, sen karar verirsin.

---

## 9) Sorun mu var?

| Belirti | Kontrol |
|---|---|
| Ajan seni **tanımıyor** | `profile/` boş mu? `hazırla` çalıştırıldı mı? |
| Ajan **aynı hatayı** yapıyor | o hata `knowledge-base.md`'ye yazıldı mı? 2 projede de mi geçti? (`DEV_BRIEF.md` §3) |
| Ajan **çok soru** soruyor | `PROJE_INIT_REPO.md`'daki "TEK SORU" kuralına uymuyor |
| Ajan **hiç soru** sormuyor | `profile/reactions.md` boş → yasak listesi yok → sınır yok |
| `<VAULT_YOLU>` kaldı | `hazırla` ADIM 0 tamamlanmamış |
| `raw/` boş görünüyor | `.vaultignore` kurallarını kontrol et |

---

## Related
- `README.md` — hızlı başlangıç
- `HAZIRLA.md` — ⭐ kurulum komutu
- `CLAUDE.md` — ajanların anayasası