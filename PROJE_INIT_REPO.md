# PROJE_INIT_REPO — Repo tarafı (kod ajanına verilecek tek komut)

> ⭐ **Ne zaman:** Yeni, **boş** bir proje klasörü açtığında.
> **Kime:** Bu klasördeki **kod ajanına** (Claude Code, opencode, Codex).
> **Ne yapar:** Vault'u okur, projeyi second brain'a bağlar.
>
> ⛔ **Bu komut vault'a HİÇBİR ŞEY YAZMAZ.** Vault tarafı ayrı komutta:
> [[PROJE_INIT_VAULT]]

---

## ⭐ Kullanıcıya verilecek tek satır

```
Bu projeyi second brain yapısına bağla.
<VAULT_YOLU>\PROJE_INIT_REPO.md dosyasındaki adımları uygula.
Slug'ı klasör adından türet, placeholder doldurma.
```

> Kopyala-yapıştır yok. Slug otomatik. Ajan tek soru sorar (stack).

---

## Ajan'ın izleyeceği yol

### 1 — Anayasayı oku (sıra, atlağın yok)

```
<VAULT_YOLU>\CLAUDE.md                          §8 yazma kuralı
<VAULT_YOLU>\DEV_BRIEF.md                       geliştirici profili
<VAULT_YOLU>\projects\_STANDARTLAR\PROJECT.md   ortak kurallar
<VAULT_YOLU>\_SABLON\knowledge-base-sablonu.md
<VAULT_YOLU>\REPO_ROOT_AGENTS_STUB.md           injector kaynağı
```

### 2 — Slug'ı türet

- Slug = **klasör adıyla birebir aynı** (camelCase).
- ⛔ kebab-case **DEĞİL** — karar: `projects/_STANDARTLAR/decisions/`
  dosya adları kebab-case, **proje kimliği** camelCase'dir.
- ⭐ **Gerekçe:** slug repo adından farklı görününce vault'ta **iki isim**
  birden yaşar ve ajan hangisini arayacağını bilemez.
- Kullanıcıdan slug **istemez** — türetir ve raporunda yazar.

### 3 — ⭐ TEK SORU: stack

Klasör boş olduğu için ajan stack'i **kendisi göremez.** Sor:

```
Bu proje hangi stack? (1 yazman yeterli, kısa yaz)
  1) Java backend      - Java 21 + Spring Boot + Maven
  2) React frontend    - React 18+ + Vite + npm
  3) Node backend      - Node + Prisma + PostgreSQL
  4) Başka / karma      - ne ise onu yaz
```

> ⭐ **Bu tek sorudur.** Cevabı bekle, sonra devam et. Başka soru
> **SORMA** — her şey `CLAUDE.md`'de yazılı, uygula.

### 4 — Idempotency kontrolü (önce)

| Durum | Ne yap |
|---|---|
| Repo kökünde `AGENTS.md` **yok** | Kur (aşağıdaki 5) |
| Repo kökünde `AGENTS.md` **var** | ⚠️ **Üzerine yazma.** Kullanıcıya sor: *"var olanı koruyayım mı, ikisini birleştireyim mi?"* |
| `DEV_BRIEF.md` yok | `REPO_ROOT_AGENTS_STUB.md`'dan üret |
| `knowledge-base.md` yok | `_SABLON/knowledge-base-sablonu.md`'dan üret |

### 5 — Dosyaları yaz

```
<repo>\AGENTS.md              ← vault anayasasının repo adaptasyonu
<repo>\DEV_BRIEF.md           ← vault kökünden kopyalanır (birebir)
<repo>\knowledge-base.md      ← _SABLON'dan (hata + karar kayıtı)
```

> ⭐ `DEV_BRIEF.md` **birebir kopyalanır.** Ajan içeriğini
> değiştirmez, özetlemez, güncellemez — vault'taki asıl dosya tek
> doğruluk kaynağıdır.

### 6 — Kayıt

Projenin gerçek SHA'larını vault'a bildir (kod ajanı vault'a **yazmaz**,
**raporlar**):

```
Slug: <slug>
Stack: <1|2|3|4>
HEAD: <sha>
Yazılan: AGENTS.md, DEV_BRIEF.md, knowledge-base.md
```

Kullanıcı bu slug'ı [[PROJE_INIT_VAULT]] komutuna yazar.

### 7 — ⭐ Doğrulama (kullanıcı çalıştırır)

```powershell
pwsh -NoProfile -File "<VAULT_YOLU>\tools\proje-init-dogrula.ps1" `
  -Repo "<repo yolu>" -Slug "<slug>"
```

Raporda hata varsa düzelt, sonra bitir.

---

## ⛔ Kod ajanının YAPMAMASI gerekenler

| ⛔ | Neden |
|---|---|
| Vault'a **hiçbir şey** yazmaz | Yazma yetkisi yok — tek hedefi `knowledge-base.md` |
| `raw/agent-output/`'a rapor bırakmaz | Bu klasör Kütüphaneci'nin katmanı |
| `DEV_BRIEF.md`'yi **güncellemez** | Asıl dosya vault'ta; kopya sadece kopyadır |
| `knowledge-base.md`'yi **okumaz** | Kayıt dosyası, komut değil |
| Var olan `AGENTS.md`'yi **ezmez** | Kullanıcının emeği |

## Related
- [[PROJE_INIT_VAULT]] — vault tarafı (ikinci komut)
- `CLAUDE.md` §8 — kod ajanı sözleşmesi
- `REPO_ROOT_AGENTS_STUB.md` — `AGENTS.md` kaynağı