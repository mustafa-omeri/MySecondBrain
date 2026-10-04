# NASIL KULLANILIR — sıfırdan, adım adım

> ⭐ Bu dosya **birine anlatır gibi** yazıldı. Acele eden `README.md`'ye,
> sabırlı olan buraya baksın.
>
> ⭐ **Toplam süre: ~10 dakika.** Sonrasında her şey otomatik.

---

## Bu vault ne?

Kendi bilgini tuttuğun bir klasör. İçine **3 tür şey** yazarsın:

| | |
|---|---|
| **Belgelerin** | PDF · Word · notlar · sohbet kayıtları |
| **Kararların** | *"bunu şöyle yaptım, şu sebeple"* |
| **Tepkilerin** | *"çok uzun"*, *"bunu yapma"*, *"görseli birebir yap"* |

Ve bu klasörü okuyan **yapay zekâ ajanları** bunlardan öğrenir:

```
Ajan: "Bu projede silme nasıl yapılır?"
  → vault'a bakar → "soft delete" kararını bulur → ÖYLE yapar
  → sen "ben öyle istemiyorum" dersin → bu sefer "yasak listesine" yazılır
  → bir daha sormaz
```

> ⭐ **Fikir:** Bir ajanın hafızası kapandığında biter. Bu klasör
> **diskte** durur. Ajan değişse de hafıza kalır.

---

# ⭐ BAŞLANGIÇ — 5 adım

## ADIM 1 — Bu klasörü bir yerden aç ⏱️ 1 dk

Klasörü bilgisayarında bir yere koy. En kolay yol: masaüstü ya da
Belgeler klasörü.

> ⚠️ **Önemli:** İçinde bazı dosyalarda **senin klasörünün tam yolu**
> yazıyor. Bu yüzden **sonradan taşıma**. Baştan doğru yere koy.

## ADIM 2 — Bir yapay zekâ ajanı aç ⏱️ 2 dk

Bu klasörde terminal (komut ekranı) aç ve şunu yaz:

```
cd <bu klasörün yolu>
claude
```

`claude` yoksa şunları deneyebilirsin: `codex` · `opencode` · Cursor'ın
terminali.

> 💡 **Ajan değişse de olur.** Bu klasör birden çok ajanla çalışmak için
> tasarlandı. Hepsi aynı dosyaları okur.

## ADIM 3 — Tek komutu yaz ⏱️ 5 dk

Ajan açıldıktan sonra şunu yaz:

```
hazırla
```

**Bu kadar.** Gerisini ajan yapar.

### Ajan ne yapacak?

| | Ne olacak | Süre |
|---|---|---:|
| 1 | Kuralları okur (klasörün içindeki anayasa dosyası) | ~10 sn |
| 2 | Sana **7 soru** sorar | senin cevapların |
| 3 | Cevaplarını profil dosyalarına yazar | ~1 dk |
| 4 | `<VAULT_YOLU>` yazan yerleri gerçek yolunla değiştirir | anında |
| 5 | Kurulumu doğrular | ~10 sn |

### ⭐ 7 soru ne?

Kısaca:

1. **Adın soyadın?**
2. **Ne iş yapıyorsun?** (rolün, sektörün, kaç yıldır)
3. **Hangi dilde konuşalım?**
4. **Cevaplar kısa mı olsun, uzun mu?**
5. **Hangi teknolojileri kullanıyorsun?** (dil, framework, veritabanı)
6. **Hangi yapay zekâ araçlarını kullanıyorsun?**
7. ⭐ **Bu ajana bir isim verir misin?** *(isteğe bağlı)*

> ⭐ **7. soruya isim verirsen** sonraki oturumlarda sadece o ismi
> yazman yeterli — ajan kaldığı yerden devam eder. Örnek:
> ```
> Selim
> ```
> Verirsen ajan `entities/` altına bu isim için bir sayfa açar ve
> ana yasaya bir satır ekler.

> ⚠️ **Ajan tahmin etmez.** "Muhtemelen Java kullanıyorsun" yazmaz —
> **sorar.** Bu bir hata değil, tasarım gereği.

## ADIM 4 — Doğrula ⏱️ 30 sn

Terminalde şunu çalıştır:

```powershell
pwsh -NoProfile -File tools\vault-baslangic-dogrula.ps1
```

Göreceğin çıktı:

| Satır | Anlamı |
|---|---|
| `TAMAM` | ✅ her şey yerinde |
| `UYARI` | ⚠️ sorun değil, gözden geçir |
| `HATA` | ❌ eksik var, yukarıya bak |

| | |
|---|---|
| `HATA: 0` + `UYARI: 0` | 🎉 Vault hazır |
| `HATA: 0` | ✅ çalışıyor, uyarılar önemsiz |
| `HATA > 0` | ❌ `HATA` yazanları düzelt |

> ⭐ **Kurulumdan sonra hep böyle kalacak:** `UYARI` yazanlar
> "`profile/` henüz dolmadı" ve "`<VAULT_YOLU>` kaldı" gibi şeylerdir —
> `hazırla` çalıştıysa bunlar kendiliğinden kaybolur.

## ADIM 5 — İlk işini yap ⏱️ 1 dk

Artık hazırsın. Aşağıdaki **Günlük Kullanım** bölümüne geç.

---

# Günlük Kullanım

## ⭐ Ne yapmak istersin?

| Sen şunu istersin | Bunu yap |
|---|---|
| ⭐ **Yeni bir proje** eklemek | Aşağıdaki **Yeni Proje** bölümü |
| Bir **belge** ekleyip işletmek | Aşağıdaki **Belge Ekleme** bölümü |
| Ajanın bir **hatasını** kaydetmek | Aşağıdaki **Tepki Kaydetme** bölümü |
| Bir **sır** saklamak | Aşağıdaki **Gizli Bilgi** bölümü |
| "Ne oldu?" diye bakmak | `log.md` dosyasının son 15 satırı |
| Kontrol yapmak | `lint-report.md` + `ACIK_ISLER.md` |

---

## ⭐ Yeni Proje — iki komut

Yeni bir kod projesi açtığında **iki adım** gerekir. Sırası önemli.

### Adım A — kod ajanına (proje klasöründe)

```
Bu projeyi second brain yapısına bağla.
<vault yolun>\PROJE_INIT_REPO.md dosyasındaki adımları uygula.
```

Ajan sana **bir soru** sorar (*"hangi stack?"*). Cevap ver. Sonra slug'ı
söyler — örneğin `benimUygulamam`.

> ⭐ **Neden ayrı?** Çünkü **iki farklı ajan** var:
> Projede çalışan ajan → kodu o yazar.
> Vault'taki ajan → bu klasörü yazar.
> Ayrım güveni mekanikleştirir.

### Adım B — vault'taki ajana (buraya dön)

```
Yeni proje vault tarafını hazırla: benimUygulamam · java
```

Bu komut `projects/benimUygulamam/` klasörünü açar ve projeyi kaydeder.

### Adım C — doğrula

```powershell
pwsh -NoProfile -File tools\proje-init-dogrula.ps1 -Repo "<proje yolu>" -Slug "benimUygulamam"
```

---

## Belge Ekleme

1. Belgeyi `raw/` altındaki uygun klasöre koy:

| Belge türü | Klasör |
|---|---|
| Sınıflandırmak bilmediğin her şey | `raw/inbox/` |
| Makale · PDF · sunum | `raw/articles/` |
| Konuşma kaydı · metin dökümü | `raw/transcripts/` |
| Projene ait spec · not | `raw/projects/<proje>/` |
| Kişisel teknik not | `raw/knowhow/` |

2. Bu klasördeki ajana yaz:

```
RAW_ISLEM_PROMPT.md dosyasındaki komutu uygula.
```

3. Ajan **5 maddelik özet** çıkarır ve **onay isler.**
   → Onaylarsan `sources/` altına işler.
   → ⭐ *"Önemli değil"* derse de **sessizce geçmez** —
     `ingest-manifest.md`'ye "değersiz" diye yazar.

> ⭐ **Neden onay istiyor?** Çünkü değeri olmayan bir şeyi de işlemek
> zaman kaybı. Ama "önemsiz" demek de kayıttır — sonra aynı soruyu
> tekrar sormaz.

---

## ⭐ Tepki Kaydetme (en değerli girdi)

Bu vault'u **özel yapan** şey budur. Ajana *"ne yapmışsın"* değil,
**senin neye tepki verdiğini** öğretir.

### Nasıl?

1. Aşağıdaki şablondan kopyala:
   `raw/chats/_SABLON/chat-sablonu.md`

2. Kaydet: `raw/chats/<ajtör>/YYYY-MM-DD-<konu>.md`
   (`<ajtör>` = `claude` · `opencode` · `chatgpt` · `gemini` · `diger`)

3. Sohbeti özetle:

| Blok | Kural |
|---|---|
| `<siz>` | ⭐ **Senin** mesajın. Etiketi atlama. |
| `<asistan>` | bağlam. Kısaltmak istersen kısalt — tamamı gerekmez |
| `cwd` | sohbetin geçtiği klasör → otomatik projeye bağlanır |

4. Ajan işler → sonuçlar şuraya düşer:
   - ⭐ **Reddettiklerin** → `profile/reactions.md` §**Ret edilenler**
     (= **yasak listesi**)
   - **3 kez tekrarlananlar** → kalıp sayılır

### Örnek

```markdown
<siz>
Çok uzun oldu. Özetle.
</siz>

<asistan>
...(kısaltılmış cevap)...
</asistan>

<siz>
Bunu yapma. Kod içinde düzenleme yapma.
</siz>
```

Bu iki mesajdan ajan şunu öğrenir:

| Mesaj | Öğrenilen |
|---|---|
| *"çok uzun"* | `kısa cevap ver` kuralı |
| *"yapma"* | ⛔ **yasak listesi** — bir daha yapmaz |

> ⛔ **Etiketsiz yazma.** Etiketsiz metin "senin söylemediğin bir şey"
> sayılır ve **işlenmez.** Etiketler kuralın parçası.

> ⭐ **Eski kaydı silme.** Aynı tepkiyi 3. kez verdiğinde kalıp sayılır.
> Yani **tekrarın kanıt** — bu yüzden ilk kaydın durmalı.

---

## ⭐ Gizli Bilgi

Parola, API anahtarı, kart/TC/vergi numarası gibi şeyler
`raw/`'a **düz metin** yazılmaz.

```powershell
cd tools\secret-vault
python ac.py
```

Giriş yap, metni yapıştır → **şifreli** olarak `_GIZLI/kayitlar/` altına
yazılır.

| | |
|---|---|
| `_GIZLI/INDEX.md` | hangi sır var, ne için → **serbest okunur** |
| ⛔ Şifreli dosyanın **içeriği** | çözülmez, okunmaz, loglanmaz |

> ⛔ **Ajan şifreyi çözmeye çalışmaz.** Sen onay verirsen **şifreli metni**
> sana verir, kendisi çözmez.

---

## Git — sürüm geçmişi

Bu klasör bir **git** deposudur. Yani **geçmişini tutar**: bir şeyi
bozarsan geri alabilirsin.

```powershell
git status                      # ne değişti?
git add -A
git commit -m "notun ne olduğunu yaz"
```

> 🤖 **Ajan commit atmaz.** Değişikliği gösterir, kararı **sen** verirsin.

> ⭐ **Ne versiyonda tutulur?** Bilgi katmanı — `sources/` `concepts/`
> `entities/` `profile/` `projects/` `log.md`. Hepsi.
> ⛔ `raw/`'ın ağır kısmı versiyona girmez — **yeniden üretilebilir.**

---

# Sorun mu var?

| Belirti | Sebep | Çözüm |
|---|---|---|
| Ajan seni **tanımıyor** | `profile/` boş | `hazırla` çalıştır |
| Ajan **çok soru** soruyor | `PROJE_INIT_REPO.md` "TEK SORU" kuralını uygulamıyor | Ajanı uyar |
| Ajan **hiç soru** sormuyor | `profile/reactions.md` boş → yasak listesi yok | Tepki kaydet (yukarıya bak) |
| Ajan **aynı hatayı** yapıyor | Hata `knowledge-base.md`'ye yazılmamış | Projede ajana söyle, sonra **2 projede de** olduysa `DEV_BRIEF.md` §3'e terfi eder |
| `<VAULT_YOLU>` yazıyor | `hazırla` ADIM 0 yapılmamış | `hazırla` komutunu tekrar çalıştır |
| `raw/` boş görünüyor | `.vaultignore` kuralı | `pwsh -File tools\vaultignore-dogrula.ps1` |
| "Kuralı yazdım ama ajan uymuyor" | Kural dosyada ama **terfi** edilmemiş | `preferences.md`'ye taşınması gerekiyordur |

---

# ⭐ 5 dakikalık özet

| Zaman | Ne |
|---|---|
| 1 dk | klasörü aç · ajan başlat |
| 5 dk | `hazırla` yaz · 7 soruyu cevapla |
| 30 sn | `vault-baslangic-dogrula.ps1` çalıştır |
| — | ⭐ **bitti** |

**Sonrası:** belge ekle → ajana `RAW_ISLEM_PROMPT.md` · yeni proje →
`PROJE_INIT_REPO.md` · tepkini kaydet → `raw/chats/`

---

## Related
- `README.md` — hızlı başlangıç
- `HAZIRLA.md` — ⭐ kurulum komutunun ajana verdiği tam talimat
- `MANUEL.md` — ayrıntılı rehber
- `CLAUDE.md` — ajanların anayasası
- `ACIK_ISLER.md` — ⭐ "sonra düzeltirim" listesi