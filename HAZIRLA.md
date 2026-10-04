# HAZIRLA — bu vault'u senin için kurar

> ⭐ **Tek komut.** Bu klasörde bir ajan aç (Claude Code · opencode · Codex)
> ve yaz:
>
> ```
> hazırla
> ```
>
> Gerisini ajan yapar. **Sen sadece soruları cevapla.**

---

## ⭐ Bu ne?

| | |
|---|---|
| Ne | Kişisel ikinci beyin şablonu — **kurallar hazır, bilgiler boş** |
| Kurallar | tam (anayasa, ajan prompt'ları, araçlar, şablonlar) |
| Senin bilgilerin | **hiçbiri yok** (şablon temiz) |
| Ne zaman | **Bir kez**, bu vault'u ilk kez açtığında |

## ⭐ Neden "komut" gerekiyor?

Çünkü **iki şey ayrı:**

| | |
|---|---|
| **Kurallar** | Herkese aynı. Kopyalanabilir. **Şablonda var.** |
| **Bilgiler** | Sadece senin. Kopyalanamaz. **Senin cveaplarınla dolar.** |

Kuralları okuyan bir ajan seni **tanımaz** — sadece *kuralları* bilir.
`profile/` klasörü bu yüzden boş geliyor.

---

## ADIM 0 — ⭐ VAULT YOLU

Şablonda `<VAULT_YOLU>` placeholder'ı var. Bu, **senin vault'unun tam yolu**.

Ajan bunu **kendisi** tespit eder (çalıştığı klasör = vault kökü) ve tüm
dosyalardaki `<VAULT_YOLU>` yerine **gerçek yolu** yazar.

> ⭐ Ajan `Get-Location` ile başlar. Emin değilse **sorar** — asla tahmin
> etmez.

## ADIM 1 — Anayasayı oku

Sıra, atlağın yok (`CLAUDE.md` §0):

```
CLAUDE.md · index.md · ingest-manifest.md
profile/* · log.md (son 20)
```

Bu dosyalar **boş** — içeriği yok, sadece **yapısı** var.

## ADIM 2 — ⭐ Kurulum soruları (sabit liste, 7 soru)

> ⭐ **Kural:** bu sorular **kısa ve tek tek** sorulur. Kullanıcı
> cevaplamak zorunda — ama **istediği kadar kısa** cevap verebilir.
> **Tahmin etme, doldurma.** Boş bırakılan soru boş kalır; bu normaldir
> ve `profile/patterns.md`'ye `inferred` notu düşülür.

| # | Soru | Nereye yazılır |
|---|---|---|
| 1 | **Adın soyadın?** | `profile/user.md` |
| 2 | **Ne iş yapıyorsun?** (rol · sektör · deneyim yılı) | `profile/user.md` |
| 3 | **Hangi dili konuşuyorsun?** (Türkçe/İngilizce/başka) | `profile/preferences.md` |
| 4 | **Cevaplar nasıl olsun?** (kısa/uzun · sadece sonuç mu, açıklama da mı) | `profile/preferences.md` |
| 5 | **Kullandığın stack?** (diller · framework · DB · paket yöneticisi) | `profile/preferences.md` |
| 6 | **Hangi AI araçlarını kullanıyorsun?** (Cursor · Claude Code · opencode · Codex) | `profile/preferences.md` |
| 7 | **Ajan adı?** (istersen — bu ajana kimlik verir, sonraki oturumlarda hatırlanır) | `entities/<isim>.md` |

> ⭐ **Soru 7 isteğe bağlı.** Verilirse `entities/<isim>.md` açılır ve
> `CLAUDE.md` §0'a bir ADIM 0 satırı eklenir → sonraki oturumlarda
> adı yazınca ajan devam eder.

## ADIM 3 — `profile/` dosyalarını doldur

Üç dosya, üç farklı iş:

| Dosya | Ne yazılır | ⛔ Asla |
|---|---|---|
| `profile/user.md` | **kim olduğun** — ad, rol, alanlar | Tahmin, "muhtemelen" |
| `profile/preferences.md` | **nasıl çalışmak istediğin** — dil, uzunluk, stack | Başka birinin tercihi |
| `profile/reactions.md` | **boş kalır** — sadece senin vereceğin tepkilerle dolar | Uydurma örnek satır |

> ⭐ **Neden `reactions.md` boş?** Çünkü bu dosya **senin tepkilerinin
> ölçümüdür.** Ajan tahmin edemez. İlk sohbetlerden sonra dolar.

## ADIM 4 — İlk projeni kur

`PROJE_INIT_REPO.md` + `PROJE_INIT_VAULT.md` akışı çalışır:

```
Kod ajanına:  "Bu projeyi second brain yapısına bağla.
               <VAULT_YOLU>\PROJE_INIT_REPO.md adımlarını uygula."
Sonra:        "Yeni proje vault tarafını hazırla: <slug> · <stack>"
```

## ADIM 5 — Git + MCP

| | |
|---|---|
| Git | `git init` + ilk commit → **sürüm tarihi bedava** |
| MCP | İstersen `secondBrainVaultMCP` → `VAULT_ROOT` bu yol olacak |

## ADIM 6 — Doğrulama

```powershell
pwsh -NoProfile -File "<VAULT_YOLU>\tools\vault-baslangic-dogrula.ps1"
```

Raporda hata varsa düzelt, sonra bitir.

## ADIM 7 — `log.md` ilk kayıt

```
## [YYYY-MM-DD] schema-change | vault kuruldu (şablon → kişisel)
```

---

## ⭐ Sık yapılan hata

| Hata | Doğrusu |
|---|---|
| Ajan `profile/`'i **kendisi dolduruyor** | Cevap **senin** ağzından gelmeli. "Muhtemelen Java kullanıyorsun" yazma — **sor.** |
| Ajan kuralları değiştiriyor | `HAZIRLA` **bilgi** toplar, kural **değiştirmez**. |
| Ajan `raw/`'a bir şey kopyalıyor | `raw/` sadece **senin** eklediğin malzeme. |
| Ajan ilk commit'i atıyor | Commit **senin** kararın. Sadece `git status` göster. |

---

## Related
- `CLAUDE.md` — anayasa
- `PROJE_INIT_REPO.md` — yeni proje (repo tarafı)
- `PROJE_INIT_VAULT.md` — yeni proje (vault tarafı)
- `MANUEL.md` — insan rehberi
- `profile/reactions.md` — yasak listesi burada birikir