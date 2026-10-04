# Kod Geliştirme Ajanı — Bellek Protokolü

Bu vault bir **ikinci beyin**. Kod ajanının (Claude Code, Codex, vs.)
görevi kod yazmak değil — **önce hafızayı okumak, sonra karar vermek,
sonra kaydetmek.**

Bu protokol sayesinde ajan, her oturumda sıfırdan başlamaz; projede daha
önce verilmiş kararları, senin isteklerini ve mimari sözleşmeni **okur**,
kendisinin verdiği kararları **anında yazar**.

`{{VAULT_YOLU}}` ve `{{PROJE_SLUG}}`'ı değiştir.

```
Bu depo {{VAULT_YOLU}} adlı bir Obsidian "second brain" vault'una bağlı.
Hafıza bu vault'ta. Kod yazmadan önce OKU, karar verirken YAZ.

═══════════════════════════════════════════════════════════════
KATMAN 1 — BAŞLANGIÇ: HAFIZAYI YÜKLE (kod yazmadan ÖNCE)
═══════════════════════════════════════════════════════════════

Sırayla oku. Atlağın yok.

1) {{VAULT_YOLU}}/CLAUDE.md
   → Bölüm 8 (kod ajanı sözleşmesi) ve Bölüm 9 (kesin kurallar)

2) {{VAULT_YOLU}}/profile/preferences.md
   → Kullanıcının çalışma tarzı ve TEKNİK TERCİHLERİ.
   → Buradaki kurallar sana da geçerlidir. Özellikle:
       "Teori verme, kod ver" · "Yarım çözüm kabul edilmez" ·
       "Türkçe yanıtla" · "Mevcut akışı bozma"
   → BU DOSYA OKUMA LİSTESİNDE YOKSA, İSTENEN İŞİ YAPMA.

3) {{VAULT_YOLU}}/profile/reactions.md
   → Kullanıcının **neye TEPKİ verdiği**. preferences ne istediğini,
     BU DOSYA hangi çıktıya onay verdiğini / reddettiğini söyler.
   → §"Ret edilenler" = YASAK LİSTESİ. Oradaki hiçbir şeyi yapma.
   → §"Onaylanmış kalıplar" = standart; oradaki biçimi kopyala.
   → BİRİ OLMAKTAN DİĞERİ EKSİKTİR. İkisini de oku.

4) {{VAULT_YOLU}}/projects/_STANDARTLAR/PROJECT.md
   → ve projects/_STANDARTLAR/decisions/ altındaki TÜM sayfalar
   → AI kuralları, kurumsal mimari sözleşmesi, feature-based paket
     yapısı, dokümantasyon-kod sırası, gizli veri politikası.
   → BU ADIM ATLANMAZ. Projeye ait olmayan ama her projeye geçerli
     kurallar burada. Atlarsan aynı hatayı tekrar yaparsın.

5) {{VAULT_YOLU}}/projects/{{PROJE_SLUG}}/PROJECT.md
6) {{VAULT_YOLU}}/projects/{{PROJE_SLUG}}/architecture.md
7) {{VAULT_YOLU}}/projects/{{PROJE_SLUG}}/decisions/ → TÜMÜ
8) {{VAULT_YOLU}}/projects/{{PROJE_SLUG}}/log.md → SON 10-15 SATIR
   → Bu proje daha önce neler yapıldı, hangi sorunlar yaşandı
9) {{VAULT_YOLU}}/projects/{{PROJE_SLUG}}/sources/ → EN SON 3-5 dosya

Dokuz adım tamamlanmadan koda dokunma. Projeyi ve kararlarını keşfetmeye
çalışma — zaten yazılı.

═══════════════════════════════════════════════════════════════
KATMAN 2 — OKUMANIN KANITI (kod yazmadan hemen önce)
═══════════════════════════════════════════════════════════════

Koda geçmeden önce, yanıtında şunu yaz:

  "Bu iş için geçerli kararlar:
   - <karar-1-slug> → <tek cümle özet>
   - <karar-2-slug> → <tek cümle özet>
   Yoksa: 'Bu iş için geçerli bir karar bulamadım.'"

Kurallar:
- Her kararı **başlığıyla adıyla** belirt (yolunu yaz).
- **Bir kararın adını uydurma.** Emin değilsen dosyayı tekrar oku.
- Hiç karar yoksa **bunu açıkça söyle** ve kullanıcıya sor — boşluğu
  doldurmak için uydurma karar verme.

Bu iki kuralın sebebi: yanlış hatırlama (hallucination) ancak okuma
kanıtıyla yakalanır. Hatırladığını yazamıyorsan hatırlamamışsındır.

═══════════════════════════════════════════════════════════════
KATMAN 3 — KARAR VERİRKEN: ANINDA YAZ
═══════════════════════════════════════════════════════════════

**Yazma kuralı:** Kararı İŞ BİTİNCE değil, **verdiği anda** yaz.

Ne zaman yeni karar veriyorsun?
- Yeni bir dosya/klasör yapısı seçtiğinde
- Bir kütüphane/framework eklediğinde
- Bir şemayı (tablo/DTO/API) tasarladığında
- Bir kararı "geçici" olarak değiştirdiğinde
- Hangi modülün ne sorumluluğu olduğunu belirlediğinde
- Bir kuralın istisnası yarattığında

Yazma yeri (⭐ **vault'a DEĞİL, projenin kendi dizinine**):

  knowledge-base.md          (proje kökü — senin tek yazma hedefin)

Bu dosya iki kayıt türü taşır: **hata** ve **karar**.

── KARAR KAYDI ─────────────────────────────────────────────
  ## <karar adı> (YYYY-MM-DD)
  ### Karar
  ### Karar Gerekçesi
  ### Değerlendirilen Alternatifler
  ### Files Changed

Şu 4 alan ZORUNLU: Karar · Gerekçe · Değerlendirilen alternatifler ·
Etki. Gerekçesiz karar yazma. Alternatif düşünmediysen dürüstçe
yaz: ⚠️ "Ajan bu alternatifi değerlendirmedi — <sebep>".

⛔ HER KARAR YAZILMAZ:
  ✅ kural doğuracak karar · değerlendirilmiş seçim · sonraki oturumu
     etkileyen gerekçe
  ⛔ geçici düzeltme · dosya adı gibi uygulama detayı · KB'de zaten
     bulunan kararı tekrar etme

Yazmadığın her karar, oturum kapanınca **kalıcı belleğe hiç geçmez** ve
bir sonraki ajan onu **yeniden verecek**. Bu, koda yazmaktan daha
pahalıdır.

⭐ **VAULT'A HİÇBİR ŞEY YAZMA.** `projects/{{PROJE_SLUG}}/decisions/`
başta olmak üzere vault'un hiçbir katmanına dokunma — oradaki her sayfa
Kütüphaneci onaylıdır ve taşınma işi Kütüphaneci'nindir. Vault senin
için **okunacak** bir hafızadır (second brain).

MEVCUT BİR KARARI DEĞİŞTİRMEK istiyorsan: KB'ye **yeni** bir karar
kaydı ekle, eskisini silme/değiştirme. Terfi taramasında
`supersedes: <eski-karar-adı>` belirt; Kütüphaneci vault'taki eski
sayfayı `status: superseded` olarak işaretler.

═══════════════════════════════════════════════════════════════
KATMAN 4 — HALÜSİNASYON KORUMASI (her adımda geçerli)
═══════════════════════════════════════════════════════════════

a) UYDURMA YAPMA
   - Var olmayan dosya, sınıf, metot, alan, endpoint adı yazma.
     Yazmadan önce **grep/ls ile doğrula**.
   - Bir API'nin imzasını tahmin etme. Kodu oku veya tipten türet.
   - Kütüphane versiyonu/özelliği hatırlamıyorsan kontrol et.
   - Emin değilsen **yazma, sor** — tahmin yürütme.

b) KAYNAKSIZ İDDA YAPMA
   - Her teknik iddianın arkasında bir kaynak olmalı: karar sayfası,
     architecture.md, kullanıcı talimatı veya okuduğun kod.
   - "Genellikle", "muhtemelen", "standart olarak" diyorsan ve bir kaynak
     yoksa bunu **açıkça belirt**.

c) TAHMİNİ İŞARETLE
   - Spekülasyon yapabilirsin, ama **"tahmin:"** diye işaretle.
   - Emin olmadığın yerde iki seçenek sun, birini seçme.

d) ÇELİŞKİYİ GİZLEME
   - Bir kural/decision sayfası ile kodu çelişiyorsa **kendi kararınla
     geçme**. Dur, `Karşılaşılan sorunlar` bölümüne yaz, kullanıcıya sor.

e) TUTARLILIK
   - Var olan bir kodu değiştiriyorsan: önce **ne için var olduğunu**
     bul. Silme/taşıma yapmadan önce **referanslarını** ara
     (grep ile tüm kullanımı listele).
   - Mantığı bozma, taşıma; akışı güncelle.

f) "TÜMÜNÜ YAPTIM" YALANINI SÖYLEME
   - Yarım bıraktığın, atladığın, doğrulayamadığın şey varsa **söyle**.
   - Bu, senin kalıcı kurallarından biri.

══════════════════════════════════════════════════════════════
OTURUM SONU KONTROL LİSTESİ
══════════════════════════════════════════════════════════════

☐ Katman 1'in 9 adımı tamamlandı mı? (özellikle preferences.md,
  reactions.md ve _STANDARTLAR)
☐ Katman 2'de kararları adıyla özetledim mi?
☐ Verdirdiğim HER karar için `knowledge-base.md`'de `### Karar` +
  `### Karar Gerekçesi` var mı?
☐ Çözülen her hata için `### Problem` + `### Root Cause` var mı?
☐ ⭐ VAULT'A HİÇBİR ŞEY YAZILMADI mı?
☐ Uydurduğum veya doğrulayamadığım bir şey var mı? — Varsa yazdım mı?

---

## Neden tek kayıt?

`knowledge-base.md` **projeye özeldir** — ajan yalnız kendi reposunda
çalışır, paylaşılan dosya çakışması olmaz. Ayrıca dosya **yazmak**
içindir: ajan onu okumaz (200 KB olur, ~50k token). "Daha önce oldu mu?"
sorusunun cevabı zaten `{{VAULT_YOLU}}/DEV_BRIEF.md` §3'te.

Kütüphaneci senin KB'yi okur, snapshot'ını `raw/knowledge-base/` altına
alır, kalıcı kararları `projects/<proje>/decisions/` katmanına taşır ve
2+ projede geçen dersleri terfi eder. **Senin ek işin yok** — tek
görevin KB'yi doğru yazmaktır.
