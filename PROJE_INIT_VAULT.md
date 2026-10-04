# PROJE_INIT_VAULT — Vault tarafı (Kütüphaneci'ye verilecek komut)

> ⭐ **Ne zaman:** [[PROJE_INIT_REPO]] çalıştıktan **sonra**.
> **Kime:** Kod ajanına **değil** — vault'ta bana (Kütüphaneci).
> **Ne yapar:** `projects/<slug>/` tarafını kurar, projeyi kaydeder.
>
> ⛔ **Bunu kod ajanına verme.** Kod ajanı vault'a yazamaz
> → [[global/decisions/kod-ajani-vaulta-yazmaz]]

---

## 🎯 Kullanıcıya verilecek tek satır

```
Yeni proje vault tarafını hazırla: <slug> · <stack>
```

> Önce repo komutunu çalıştırın, ajan **slug'ı** raporunda yazar.
> O slug'ı buraya yazarsınız.

---

## Ajanın (Kütüphaneci'nin) izleyeceği yol

### 1 — Anayasayı oku

```
CLAUDE.md → index.md → ingest-manifest.md → profile/* → log.md (son 20)
```

### 2 — ⭐ Kararları seç (tek soru — kullanıcı)

Yeni projeye **hangi cross-project kararlar** geçerli? Kullanıcı seçer.

| # | Karar | Yeni projeye uygulanır mı? |
|---|---|---|
| 1 | `postgresql-tum-projelerde-tek-veritabani` | ✅ |
| 2 | `spring-boot-3-kalir-boot-4-sart-ile` | ⭐ **yeni proje = Boot 4** |
| 3 | `feature-based-paket-yapisi` | backend ise |
| 4 | `api-mutasyonlarinda-post-kullanimi` | backend ise |
| 5 | `silme-standarti-soft-delete` | ✅ |
| 6 | `kod-ajani-vaulta-yazmaz` | ✅ her zaman |
| 7 | `frontend-stack-react-vite` | frontend ise |

> ⓘ Bu liste **öneri**dir; kullanıcı değiştirebilir.
> Seçim **proje başına** — `_STANDARTLAR`'a dokunulmaz.

### 3 — Klasör yapısını oluştur

```
projects/<slug>/
├── PROJECT.md          ← şablon + slug/stack/karar listesi
├── architecture.md     ← şablon (stack'e göre doldur)
├── decisions/          ← ⭐ index.md: bu projeye bağlı kararlar
├── sources/
└── log.md              ← açılış kaydı
raw/projects/<slug>/    ← kullanıcının belge atacağı yer
```

> `_STANDARTLAR`'ı **kopyalama** — her proje oradan okur.

### 4 — ⭐ `decisions/index.md` — sistemin kalbi

Bu dosya olmadan ajan "12 kararı oku → hangisi benim?" diye kalır.
Bu dosya **"bunlar senin"** der.

```markdown
# <Proje Adı> — geçerli kararlar

> Bu liste **projeye bağlı** standartları gösterir. Kaynak sayfaları
> vault'tadır; **kopyalanmaz, okunur.**

## Bağlı standartlar (cross-project)

| Karar | Ne getirir | Kaynak |
|---|---|---|
| Spring Boot 4 ⭐ | yeni proje Boot 4 ile başlar | [[global/decisions/spring-boot-3-kalir-boot-4-sart-ile]] |
| PostgreSQL | tek veritabanı | [[global/decisions/postgresql-tum-projelerde-tek-veritabani]] |
| Soft delete | `status = DELETED` | [[global/decisions/silme-standardi-soft-delete]] |
| … | … | … |

## Projeye özel kararlar

Henüz yok. Ajan karar verdiğinde buraya eklenir.

## Related
- [[projects/_STANDARTLAR/PROJECT]] — tüm projelere geçerli kurallar
- [[network]] — çapraz proje haritası
```

### 5 — Kayıt

| # | Ne | Nereye |
|---|---|---|
| 1 | Kurulum satırı (gerçek SHA'lar) | `projects/_STANDARTLAR/DEV_BRIEF_YEREL_KOPYASI.md` |
| 2 | Proje listesi | `index.md` |
| 3 | Ham klasör satırı (`🔄`) | `ingest-manifest.md` §Bölüm 1 |
| 4 | Olay kaydı | `log.md` → `## [YYYY-MM-DD] schema-change \| yeni proje: <slug>` |
| 5 | Proje logu açılışı | `projects/<slug>/log.md` |

### 6 — Doğrulama

```powershell
pwsh -NoProfile -File "<VAULT_YOLU>\tools\proje-init-dogrula.ps1" -Slug "<slug>"
```

Raporda ✅ / ⛔ çıkmalı. Kırmızı satır varsa düzelt, sonra bitir.

---

## ⓘ Neden iki komut?

| | |
|---|---|
| **Repo komutu** | Kod ajanına → `AGENTS.md` · `DEV_BRIEF.md` · `knowledge-base.md` |
| **Bu komut** | Kütüphaneci'ye → `projects/<slug>/` · kayıt · karar listesi |

Ajanın vault'a **hiçbir yetkisi yok.** İkisini ayırmak bu kuralı
**mekanik** kılar — güvene gerek kalmaz.

---

## Related

- [[PROJE_INIT_REPO]] — repo tarafı (birinci komut)
- [[global/decisions/kod-ajani-vaulta-yazmaz]] — ayrımın gerekçesi
- [[projects/_TEMPLATE_PROJECT]] — kopyalanan şablon
- [[MANUEL]] §İş 6