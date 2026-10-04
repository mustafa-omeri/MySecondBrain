# `raw/` İşleme Prompt'u — Yeni Oturum / Farklı Model

Bu dosyayı **kopyalayıp yapıştırın.** Başka bir modelle (Claude, GPT, Gemini,
yerel model) çalışsanız da aynı prompt geçerlidir.

`<VAULT_YOLU>` yerine vault yolunu yazın:

```
<VAULT_YOLU>
```

> ⭐ **Neden ayrı dosya:** `LIBRARIAN_AGENT_PROMPT.md` genel amaçlıdır.
> Bu prompt yalnız **`raw/` işleme** içindir ve `raw/` dokunulmaz kuralını
> **kanıtlanabilir** hale getirir (parmak izi karşılaştırması).

---

## Kopyalanacak blok

````
HEDEF: <VAULT_YOLU>/raw altındaki yeni dosyaları değerlendirip
wiki katmanına işle.

⛔ İKİ ŞEYİ ÖNCE BİL:
   a) Bu görevde **hiçbir soru SORULMAZ** — ADIM 0'daki SORMA YASAĞI
      tablosu kararları senin için sabitler. Menü açma, onay isteme.
   b) Bu prompt'un sürümü: **v3** (2026-09-30).

═══════════════════════════════════════════════════════════════
⛔ DEĞİŞTİRİLEMEZ KURALLAR — bunlar her şeyden önce geçerlidir
═══════════════════════════════════════════════════════════════

1) raw/ SALT-OKUNURDUR.
   - Mevcut hiçbir dosyayı DÜZENLEME, SİLME, YENİDEN ADLANDIRMA.
   - Taşıma, kopyalama, arama-değiştirme de YAPMA.
   - raw/ altına yeni dosya da EKMEME (sadece kullanıcı ekler).
   - Bu kural "dokunulmadı" demekle değil, parmak iziyle kanıtlanır (ADIM 5).

2) KOD REPOSUNA DOKUNMA.
   - C:\devtools\... altındaki hiçbir dosyayı değiştirme, silme, taşıma.
   - Salt-okunur bakış serbest; yazma yasaktır.

3) GİZLİ VERİYİ ASLA YAZMA.
   - Parola, token, API anahtarı, JWT, bcrypt, IBAN, kişisel veri.
   - Bulursan: sadece DOSYA ADI + SATIR NO + TÜR yaz. Değeri asla yazma,
     log'a da yazma. Şifreli kasaya aktarma.

4) UYDURMA YOK.
   - Var olmayan dosya/sayfa/bağlantı yazma.
   - Her iddianın arkasında kaynak olsun.
   - Emin değilsen "bilmiyorum" de.

5) ⭐ SOR / SORMA — **menü açma, süreç sorma. Ama gerçek kararı sor.**

   ⭐ **Tek test:** *"Bu sorunun cevabı kuralda mı yazılı, yoksa
   yalnızca kullanıcı mı bilebilir?"*

   | Durum | Yap |
   |---|---|
   | Cevabı `CLAUDE.md`'de yazılı | ⛔ **SORMA** — uygula, geç |
   | Süreç: routing · format · manifest · index · log | ⛔ **SORMA** — uygula |
   | `profile/`'a aday çıktı | ⛔ **SORMA** — rapora tek satır, **devam** |
   | ⭐ **Kaynak, mevcut bir kararı ÇÜRÜTÜYOR** | ✅ **SOR** — kullanıcının kararıdır |
   | ⭐ **Projeyi etkileyen kalıcı seçim gerekiyor** | ✅ **SOR** — sadece seçenekleri sor |
   | 5 maddelik özet onayı | ✅ **SOR** — `evet / hayır` |
   | Dosyanın ne olduğunu anlamadım | ✅ **SOR** |

   ⛔ **Menü (seçenek listesi) YASAK** — süreç soruları için.
   ✅ **Seçenekli soru** yalnız yukarıdaki iki ⭐ satırda olabilir.

   ### ⭐ Gerçek karar sorusu nasıl sorulur

   ⛔ **Böyle yapma** (menü):
   > *"Profil adayı ne olsun? 1) Şimdilik ekleme 2) preferences.md'ye ekle"*

   ✅ **Böyle yap** (gerçek karar):
   > *"⚠️ Bu belge **Spring Boot 4.x** diyor; vault'taki
   > `prisma-skill-cakismasi` kararı **Spring Boot 3** diyor.
   > Projeler Boot 3'te mi kalacak, Boot 4'e mi geçecek? (Karar senin.)"*

   Fark:
   | Menü ⛔ | Gerçek karar ✅ |
   |---|---|
   | Cevabı **kuralla** belirli | Cevabı **yalnızca kullanıcı** bilebilir |
   | Seçenekler **süreç** | Seçenekler **yön** (hangi yol) |
   | Kuralı uygulamak için takılır | Kuralın **istisnasını** belirler |
   | "Yazayım mı?" yerine geçmez | Yazmadan önce sorulması **zorunludur** |

   💡 Karar sorusunda **önce dosyayı yazma durdur** — özeti göster,
   soruyu sor, cevabı bekle, sonra karar sayfasını aç.
═══════════════════════════════════════════════════════════════

═══════════════════════════════════════════════════════════════
⛔ SORMA YASAĞI — karar senin, bana sorma
═══════════════════════════════════════════════════════════════

⭐ **Bu görevde hiçbir interaktif soru SORMA.** Menü açma, seçenek
sunma, onay isteme. Kullanıcı bu komutu çalıştırdığında **senin kararınla
bitecek** demektir.

Rutin her karar için **sabit varsayılan** vardır:

| Durum | ⭐ VARSAYILAN (sorulmaz, uygulanır) |
|---|---|
| Bu içerik profil tercihi mi? | `preferences.md`'ye **yazma.** `patterns.md`'ye `(inferred, TARİH, N. gözlem)` satırı ekle |
| `patterns.md`'ye öneri sunulsun mu? | Hayır. Ekle ve **raporda listele** |
| `user.md` değişsin mi? | ⛔ **Asla** — yalnız kullanıcı değiştirir |
| Tepki mi, prompt mu, belge mi? | Prompt/Gem → `sources/` · belge → `sources/` · **tepkiler** (`raw/chats/<ajtör>/`) → `reactions.md` |
| Hangi projeye ait? | İçerikte proje adı geçiyorsa o proje · geçmiyorsa `_STANDARTLAR` (sahipsiz) |
| Yeni karar mı, güncelleme mi? | Yeni davranış → **yeni** karar sayfası · var olanı değiştirme, `supersedes` kullan |
| Aynı konu iki isimle geçiyorsa | ⭐ **Tarihe bak.** Eskisi ise **birleştir**, kopya proje açma |
| Emin değilsen | En **tutucu** yolu seç (silme/yazma yerine `staging/`'a bırak) ve raporda belirt |
| 5 maddelik özet onayı | ⛔ Bekleme — işle, sonra raporla |
| Gerekçesiz kalan alan | `confidence: inferred` yaz, boş bırakma |

⛔ **TEK istisna — gerçek belirsizlik:** içeriğin **hangi katmana**
gideceği iki klasör arasında karar verilemiyorsa ve yanlış katman
**kalıcı kirlilik** yaratacaksa (örn. bir karar mı, bir kaynak mı?) →
o **tek soruyu** sor. Her şeyi sorma, sadece bunu.

> ⭐ Bu kural `CLAUDE.md`'deki *"onay iste"* ile çelişmez: onay **tek tek
> belge için** istenirdi. Burada kullanıcı **toplu yetki** veriyor —
> varsayılanlar bu tabloyla sabitlenmiştir.

═══════════════════════════════════════════════════════════════
ADIM 0 — PARMAK İZİ AL (işe başlamadan ÖNCE)
═══════════════════════════════════════════════════════════════

Bu komutu çalıştır ve sonucu not al:

  $root = "<VAULT_YOLU>"
  $rows = Get-ChildItem "$root\raw" -Recurse -File -Force |
    Sort-Object FullName |
    ForEach-Object { "$($_.FullName.Substring($root.Length+1))|$($_.Length)|$($_.LastWriteTimeUtc.Ticks)" }
  $txt = "COUNT=$($rows.Count)`n" + ($rows -join "`n")
  "COUNT=$($rows.Count)  PARMAKIZI=" + [BitConverter]::ToString(
    [Security.Cryptography.SHA256]::Create().ComputeHash(
      [Text.Encoding]::UTF8.GetBytes($txt))).Replace('-','').Substring(0,16)

⭐ BU KOMUTUN GÖREVİ — sadece **BİR** tanesidir:

  ⚠️ ADIM 0 ve ADIM 5 değerlerini karşılaştırarak **KANITLA** ki
     bu oturum boyunca `raw/`'a dokunulmadı.

⛔ **Bu komut "yeni dosya var mı" sorusunu CEVAPLAMAZ.**

| Soru | Doğru cevap kaynağı |
|---|---|
| "Hangi dosyalar işlenmemiş?" | ⭐ **`ingest-manifest.md` §Bölüm 1** (ADIM 2) |
| "Bu oturumda `raw/` bozuldu mu?" | ⭐ **parmak izi** (ADIM 0 ↔ ADIM 5) |

> ⛔ **Karıştırma hatası (2026-09-30'da yapıldı):** ilk sürümde
> *"COUNT aynı + iz aynıysa → yeni içerik yok, dur"* kuralı vardı.
> Bu **yanlıştı** — prompt yazıldığı andan önce eklenmiş dosyaları
> **yok sayar.** Gerçek testte ajan dosya varken *"yeni dosya bulunamadı"*
> dedi. Yukarıdaki tablo doğrusunu söylüyor.

> ⭐ **Kural:** Manifest'te karşılığı olmayan bir klasör **işlenmemiş**
> demektir. Parmak izi bunu **kanıtlamaz** — manifest'tir.

═══════════════════════════════════════════════════════════════
ADIM 1 — ANayasayı oku (sıra, atlağın yok)
═══════════════════════════════════════════════════════════════

  1) <VAULT_YOLU>/CLAUDE.md        ← anayasa, BÖLÜM 7'e kadar
  2) <VAULT_YOLU>/index.md
  3) <VAULT_YOLU>/ingest-manifest.md  ← HANGİ İÇERİK İŞLENDİ?
  4) <VAULT_YOLU>/profile/user.md
     <VAULT_YOLU>/profile/preferences.md
     <VAULT_YOLU>/profile/reactions.md
  5) tail -20 <VAULT_YOLU>/log.md

ADIM 3'teki "dosya neye gider?" sorusunun cevabı CLAUDE.md §7.0
routing tablosundadır. O tabloyu bulamazsan işleme — sor.

═══════════════════════════════════════════════════════════════
ADIM 2 — YENİ İÇERİĞİ BUL (manifest'e bakarak)
═══════════════════════════════════════════════════════════════

⚠️ Ham kaynak taraması MUTLAKA ingest-manifest.md ile başlar.
   log.md bir hikâye günlüğüdür, durum tablosu DEĞİLDİR.


⭐ ÖNCE ŞU TABLOLA BAK:

| Klasör | Manifest sayısı | Diskteki sayı | Durum |
|---|---|---|---|
| `raw/knowhow/Keep/` | 487 | 988 | ✅ işli — **tekrar etme** |
| `raw/knowhow/infos/` | 1 | 1 | ⬜ **işlenmemiş → işle** |

Kural:
  1) Manifest'te **kaydı olmayan** klasör → ⬜ İŞLENMEMİŞ sayılır, işlenir.
  2) Diskteki sayı > manifest sayısı → yeni dosyalar var, SADECE onları işle.
  3) Diskteki sayı = manifest sayısı → o klasöre bakma.
  4) Hiçbiri tutmuyorsa ya da kararsızsan → kullanıcıya SOR, tahmin etme.

⭐ Bu adımda parmak izini KULLANMA. Yeni dosya tespiti yalnızca
   manifest + disk sayımıdır.
Her raw/ alt klasörü için:
  - manifest §Bölüm 1'deki dosya sayısı ve tarih değişmemişse
    → O KLASÖRE BAKMA.
  - Değişmişse SADECE yeni dosyaları işle.
  - Sayıyı tespit edemiyorsan "yok" deme — emin ol, sor.
  - .html + .json ikilisi TEK kayıttır (Keep export), iki kez sayma.

═══════════════════════════════════════════════════════════════
ADIM 3 — İŞLE (her dosya için)
═══════════════════════════════════════════════════════════════

a) GİZLİ KALIP TARAMASI — gözle arama yetmez, otomatik tara:
     eyJ[A-Za-z0-9_-]{10,}     (JWT)
     ["']password["']\s*:
     \$2[aby]\$
     \b[0-9a-fA-F]{32,}\b
     BEGIN .* PRIVATE KEY
     AKIA[0-9A-Z]{16}
     jdbc:
   Eşleşme varsa: sadece satır no + tür. Değeri hiçbir yere yazma.

b) ÜÇ KATMANLI KEŞİF — "bulamadım" demek için üçü de boş olmalı:
     1. raw/                      (metin ne diyor)
     2. projects/*/decisions/     (cevap burada olabilir)
     3. log.md · sources/         (daha önce çözülmüş olabilir)
   ⭐ Tarih kontrolü: bulduğun kayıt bugünden eskiyse "yeni" deme,
     "zaten var" de. Aynı iş iki isimle konuşulmuş olabilir.

c) ⭐ 5 MADDELİK ÖZET — **tek seferde, sonda, toplu.**
   Dosyaları tek tek onaylatma. Hepsini oku, özetlerini topla, işin
   sonunda **tek bir onay iste:**

   ```
   İŞLENECEK: 3 dosya
   ── 1) raw/knowhow/infos/Java & Spring….md
      · Konu: Java/Spring 2026 trendleri
      · 3 ana bulgu
      → sources/java-spring-2026-trendleri.md
      → Profil adayı: "teknoloji takibini kaynak belgeyle yapar"
   ── 2) …
   ── 3) …

   Yazayım mı? (evet / hayır)
   ```

   - Cevap **evet** → hepsini yaz, bitir, ADIM 4'e geç.
   - Cevap **hayır** → hiçbirini yazma, dur.
   - ⛔ Bu **menü değildir** — evet/hayır. "Hangi seçenek doğru?" gibi
     sorular yasak (bkz. kural 5).

d) Routing'e göre yaz (CLAUDE.md §7.0):
     raw/projects/<proje>/  → projects/<proje>/sources/
     raw/knowhow/           → sources/ + profil adayı ÖNER (asla yazma)
     raw/chats/<ajtör>/     → profile/reactions.md
     raw/inbox|articles|     → sources/ + entities/ + concepts/
       transcripts/

e) Sayfa formatı: CLAUDE.md §4 (frontmatter + ## Sources + ## Related).

f) Güncelle: index.md · log.md · manifest §Bölüm 1
   (kapanmayan iş → §Bölüm 2 flag, karar gereken → §Bölüm 3).

═══════════════════════════════════════════════════════════════
ADIM 4 — raporla
═══════════════════════════════════════════════════════════════

Rapor **şu sırayla** olsun (kısa, madde madde):

1. **İşlenen dosyalar** — her biri için 5 maddelik özet:
   `ne` · `ana bulgu` · `hangi sayfa açıldı` · `hangi karara bağlandı` ·
   `güven düzeyi`
2. **Alınan kararlar** — varsayılanlardan hangilerini uyguladın
3. ⭐ **Profil adayları** — `preferences.md`'ye **yazılmadı**, burada listelendi.
   (3+ doğrulandıysa *"terfi adayı"* işaretle)
4. **Emin olmadığın / doğrulayamadığın** — dürüstçe
5. **Erteleme / `staging/`'a bırakılanlar** — neden

⛔ Raporda **"onayınızı bekliyorum" gibi bir cümle yazma.** Bitti.
Kullanıcı sonraki adımı kendisi söyler.

═══════════════════════════════════════════════════════════════
ADIM 5 — ⭐ raw/ DOKUNULMADIĞINI KANITLA
═══════════════════════════════════════════════════════════════

ADIM 0'daki komutu TEKRAR çalıştır ve şu tabloyu uygula:
⭐ **Yalnız ADIM 0 değeriyle karşılaştır** — bu oturumun başı ↔ sonu.
Bu oturumda sen `raw/`'ya dosya **eklemedin**, değiştirmedin, silmedin.
Kullanıcı eklerse bu da normaldir (paralel çalışma olabilir),
ama yine de bildir.

| ADIM 5 sonucu | Anlamı |
|---|---|
| ADIM 0 ile **birebir aynı** | ✅ `raw/` dokunulmadı → `raw/ DEĞİŞMEDİ` |
| `COUNT` **arttı** | ℹ️ paralel ekleme — listele, `raw/ dokunulmadı (yeni ekleme var)` |
| `COUNT` **azaldı** | ⛔ dosya silinmiş → `raw/ DEĞİŞMİŞ`, **DUR**, sor |
| `COUNT` aynı, iz farklı | ⛔ içerik değişmiş → `raw/ DEĞİŞMİŞ`, listele, **DUR** |
Bu rapor olmadan işi tamamlanmış sayma.

═══════════════════════════════════════════════════════════════
Dil: Türkçe. Kısa ve somut cevap ver.
Belirsiz bir şey varsa tahmin etme — sor.
═══════════════════════════════════════════════════════════════
````

---

## Neden bu prompt ayrı?

`LIBRARIAN_AGENT_PROMPT.md` genel amaçlıdır ve `raw/` dokunulmaz kuralını
**sonda hatırlatma** olarak verir. Güçlü modeller bunu yakalar, zayıf modeller
kaçırır.

| Sorun | Bu prompt'taki çözüm |
|---|---|
| Kural sonda, gözden kaçar | **En üstte** "DEĞİŞTİRİLEMEZ" bloğu |
| "Dokunmadım" sözü doğrulanamaz | ⭐ **Parmak izi** — 1079 dosya, 195 ms |
| Gizli tarama yoktu | ADIM 3-a, hazır desen listesi |
| Keşif sırası yoktu | ADIM 3-b, üç katman + tarih kontrolü |
| Kod reposu yasağı yoktu | Kural 2 |
| Onaysız yazma riski | ADIM 3-c, her dosyada onay |

## ⓘ Parmak izi ne zaman değişir?

| Durum | İhlal mi? |
|---|---|
| Sen `raw/`'a yeni belge ekledin | ✅ **Değil** — `COUNT` **artar**, bu tam olarak işlenecek şey |
| Ajan `sources/` · `decisions/` yazdı | ✅ Değil — parmak izi yalnız `raw/`'ı kapsar |
| Ajan bir `raw/` dosyasını **değiştirdi** | ⛔ **İHLAL** — `COUNT` aynı, iz farklı |
| Bir `raw/` dosyası **silindi** | ⛔ **İHLAL** — `COUNT` azalır |

> ⭐ **Bu yüzden prompt'ta tek bir "beklenen değer" yok — bir tablo var.**
> Tek sabit değer yazsaydım, her yeni belgede ajan yanlışlıkla *ihlal*
> diyecekti. İlk kullanımda bu hata olacaktı.

## ⭐ Pratikte: siz ne yaparsınız?

Hiçbir şey yazmazsınız. `raw/`'a belge koyarsınız, `RAW_ISLEM_PROMPT.md`'yi
açıp **kopyalanacak bloğu** olduğu gibi yapıştırırsınız.

Ajan kendi ölçümünü alır, tabloyu uygular, işler ve sonunda kanıtı raporlar.

→ Ayrıntılı adımlar: [[MANUEL]] §İş 3

## Related

- [[LIBRARIAN_AGENT_PROMPT]] — genel amaçlı Kütüphaneci prompt'u
- [[CLAUDE]] §7.0 — routing tablosu
- [[MANUEL]] — bu yapının kullanımı
- [[log]] — 2026-09-29 kaydı
