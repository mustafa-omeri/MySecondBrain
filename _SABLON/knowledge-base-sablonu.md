# Knowledge Base

> **Bu dosya proje kökünde durur ve KOD AJANI tarafından yazılır.**
> ⛔ **Vault'daki hiçbir yere yazma** — tek hedefin bu dosya.
> ⛔ **Bu dosyayı okuma.** Okuman gereken yer `DEV_BRIEF.md` §3'tür.
> İki tür kayıt yazılır: **çözülen hata** ve **alınan karar**.
>
> ⚠️ **Günlük yazma.** *"X eklendi"*, *"debug logları koydum"* gibi
> kayıtlar **kanıt sayısını şişirir** ve terfi döngüsünü bozar.
>
> Aynı hatayı ikinci kez bulursan **tekrar yazma** — terfi öner.

---

## ⭐ İki kayıt türü

| | Hata kaydı | Karar kaydı |
|---|---|---|
| **Ne zaman** | Bir hata çözüldüyse | Kalıcı bir karar alındıysa |
| **Bloklar** | `Problem` · `Root Cause` · `Solution` · `Files Changed` | `Karar` · `Gerekçe` · `Değerlendirilen Alternatifler` · `Files Changed` |
| **Terfi sayımı** | ✅ **sayılır** (`Problem` + `Root Cause` birlikte) | ⛔ **sayılmaz** — ayrı kanıt türüdür |

> ⭐ **Ayırma nedeni:** Karar kaydı eklenince terfi ölçümü bozulmasın.
> Kural: **`### Problem` + `### Root Cause` birlikte olan kayıt** hata
> kanıtıdır. Karar kaydı **kanıt sayısına girmez** — kendi düşüncesi
> içinde değerlendirilir.

---

## ⭐ Karar yazma kuralı — hangi kararlar yazılır

> ⛔ **Her karar yazılmaz.** Karar bloğu yalnızca kararın **gelecekteki
> işi bağladığı** durumlarda açılır.

| | Yaz | Yazma |
|---|---|---|
| **Yaz** | Kural doğuracak karar (enum değeri seçimi, katman sınırı, kütüphane seçimi, convention) | ⛔ O an için çözülen, kalıcı olmayan düzeltme |
| **Yaz** | Alternatifleri **değerlendirilmiş**seçim | ⛔ "Zorunda kaldım çünkü hata aldım" — bu `Root Cause`'dur |
| **Yaz** | Gerekçesi **bir sonraki oturumu etkileyecekse** | ⛔ Dosya adı, fonksiyon adı gibi uygulama detayı |
| | | ⛔ Bu dosyada **bulunan** kararları tekrar etme — `DEV_BRIEF.md` §3 zaten taşır |

> ⭐ **Aynı olayda ikisi de olabilir.** Bir hata çözümü kalıcı bir kural
> doğuruyorsa **tek kayıtta** hem `Root Cause` hem `Karar` açılır.
> Bölme — bağ kopar.

---

## Hata kaydı — örnek

## `companies.find is not a function` (2026-01-21)

### Problem
Frontend'de `companies.find is not a function` hatası. Backend liste
döndürüyor ama istemci tarafında dizi bekleniyordu.

### Root Cause
API response sarmalayıcısı değişmiş, servis katmanı eski yapıyı
unmarshal etmeye çalışıyordu. Sözleşme değişikliği client'a yansımamıştı.

### Solution
Servis katmanında tip doğrulaması eklendi; tip uyuşmazlığında JSON'u zorla
yorumlamak yerine hata fırlatılıyor. Yeni endpoint yazarken mevcut
sarmalayıcı kullanılacak.

### Karar
⭐ *Bu kayıt bir kural doğurdu:* **Yeni endpoint yazarken mevcut
sarmalayıcıyı kullan.** Tip zorlaması (cast) yasak; uyuşmazlık hata
fırlatır.

### Karar Gerekçesi
Cast, sözleşme bozulduğunda **sessiz** hata üretir — bu hatayı 3 gün
gizlemişti.

### Değerlendirilen Alternatifler
| Alternatif | Neden seçilmedi |
|---|---|
| `as Company[]` ile zorla çevir | Sözleşme bozulmasını **gizler** |
| Yeni endpoint'i eski biçimde döndür | Sözleşme bütünlüğü bozulur |

### Files Changed
- `src/features/.../companyService.ts`

---

## Karar kaydı — örnek (hata yok)

## Mutasyonlarda POST kullanımı (2026-01-28)

### Karar
Tüm mutasyon işlemleri `POST` ile yapılır. `PUT`/`DELETE` kullanılmaz.
Kritik mutasyonlarda idempotency key zorunlu.

### Karar Gerekçesi
İstemciler `PUT`/`DELETE` için yetki kontrolü uygulamıyor; aynı
işlemin iki kez gönderilmesi veri bozulmasına yol açıyordu.

### Değerlendirilen Alternatifler
| Alternatif | Neden seçilmedi |
|---|---|
| REST'e uygun `PUT`/`DELETE` | İstemci uyumsuzluğu; çift gönderim riski |
| `POST` + idempotency (seçilen) | İstemciyle uyumlu, tekrar güvenli |

### Files Changed
- `CLAUDE.md` (kural) · ilgili controller dosyaları

---

## Kurallar

| | |
|---|---|
| **Yaz** | Çözülmüş gerçek hatalar · kalıcı kararlar |
| **Yazma** | "X eklendi" · "debug logları koydum" · "temizlendi" günlükleri |
| **Yazma** | Uzun deneme notları — kısa, tekrar kullanılabilir kural |
| **Yazma** | Çok gizli veri (parola, token, anahtar) — `CLAUDE.md §9` |
| **Yazma** | Burada **bulunan** kararları tekrar etme — `DEV_BRIEF.md` §3 taşır |
| **Okuma** | Bu dosyayı **okumuyorsun** |

> **Neden okunmuyor?** 200 KB'a ulaşabilir (~50k token). Ajanın
> "daha önce oldu mu?" sorusunun cevabı zaten `DEV_BRIEF.md` §3'te.
>
> **Kimi okuyor?** Yalnızca Kütüphaneci (ikinci beyin) — terfi taramasında.
> 2+ projede geçen bir **hata** dersi `DEV_BRIEF.md`'ye taşınır.
>
> ⭐ **Karar kayıtları** farklı bir yol izler: aynı karar **2+ projede**
> tekrarlandığında **cross-project karar** olur ve `network.md`'ye girer.
>
---

> ⭐ **Bu dosya senin TEK yazma hedefin.**
>
> | | Ne |
> |---|---|
> | | **Günlük kayıt** — hata + karar, bağlamıyla, anında |
> | | Kim yazar | Kod ajanı (sen) — iş bitmeden, anında |
> | | Kim okur | ⛔ Sen okumazsın · **yalnızca Kütüphaneci** (snapshot) |
> | | Kalıcılık | Proje ömrü boyunca; snapshot tarihli kopyalar |
>
> Kütüphaneci bu dosyayı okur → `raw/knowledge-base/` altına snapshot
> alır → kalıcı kararları `projects/<proje>/decisions/` katmanına taşır
> → 2+ projede geçen dersleri terfi eder.
>
> ⛔ **Sen vault'a hiçbir şey yazmazsın.** Başka hiçbir wiki dosyasını
> değiştirmezsin.
