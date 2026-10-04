# lint-report

> ⭐ LINT **bulur ve raporlar.** ⛔ **OTOMATİK DÜZELTME YAPMAZ.**
> Bu dosya ajanın/insanın gözden geçirme listesidir.

## Kontrol listesi

| # | Kontrol | Durum |
|---|---|---|
| 1 | Çelişki var mı? (`## ÇELİŞKİ` işaretli) | ⬜ |
| 2 | Eskimiş iddia var mı? (tarih kontrolü) | ⬜ |
| 3 | Yetim sayfa var mı? (kimse bağlamıyor) | ⬜ |
| 4 | Eksik kavram sayfası var mı? | ⬜ |
| 5 | Tek-yönlü cross-referans var mı? | ⬜ |
| 6 | `scope: cross-project` kararlar `network.md`'de görünüyor mu? | ⬜ |
| 7 | `staging/`'de X günden eski taslak var mı? | ⬜ |
| 8 | Lessons-learning terfi adayı var mı? (aynı ders 2+ projede) | ⬜ |
| 9 | `knowledge-base.md` snapshot'ı güncel mi? (satır sayısı) | ⬜ |
| 10 | `ingest-manifest.md` ↔ `raw/` gerçekliği tutarlı mı? | ⬜ |
| 11 | Doküman bayatlığı (aşağıdaki tablo) | ⬜ |
| 12 | ⭐ **"Yok" bulgularının tazeliği** (araç sürümü değişmiş olabilir) | ⬜ |
| 13 | `<VAULT_YOLU>` placeholder'ı kalmış mı? | ⬜ |

## ⭐ Doküman bayatlığı

Yapı değiştiğinde şunların **yeniden yazılmış** olması gerekir.

| Dosya | Bayatlarsa ne olur |
|---|---|
| `REPO_ROOT_AGENTS_STUB.md` | Ajan vault'u okur ama **bellek biriktirmez** |
| `CODING_AGENT_PROMPT.md` | Ajan `preferences.md` / `reactions.md`'yi hiç okumaz |
| `LIBRARIAN_AGENT_PROMPT.md` | Kütüphaneci yeni klasörü taramaz |
| `MANUEL.md` | İlk kez açan kişi **yanlış klasöre** yazar |
| `README.md` | "Kurulum adımları" bölümü yalan söyler |
| `HAZIRLA.md` | ⭐ Ajan eski soruları sorar / eksik adım atlar |

**Kontrol noktası:** `CLAUDE.md` §0 okuma sırası ↔ `CODING_AGENT_PROMPT.md`
Katman 1 ↔ `REPO_ROOT_AGENTS_STUB.md` ↔ `MANUEL.md` §5 —
**dördü aynı sayıyı göstermeli.**

## Son rapor

_(henüz lint yapılmadı)_

## Related
- `CLAUDE.md` §7 — LINT operasyonu