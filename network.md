# network.md — projeler arası karar haritası

> ⭐ Bu dosya **"hangi karar hangi projeleri etkiliyor"** sorusunun
> cevabıdır. `list_decisions` kararları listeler ama bu **etki alanını**
> vermez.
>
> ⛔ **Bu dosya içerik TUTMAZ.** Tek doğruluk kaynağı
> `projects/<proje>/decisions/`'dir. Burada yalnız **işaret** + **geri link**.

## Format

```
- [[global/decisions/<slug>]] ← etkiler: [[projects/a/PROJECT]], [[projects/b/PROJECT]]
```

## Harita

_(boş — henüz cross-project karar yok)_

> ⭐ İlk kararın `scope: cross-project` olduğunda buraya bir satır düşer.

## Neden ayrı dosya?

| | |
|---|---|
| `projects/x/decisions/` | **tek doğruluk kaynağı** — içerik burada |
| `global/decisions/` | **pointer** — tek satır özet + geri bağlantı |
| `network.md` | **etki alanı** — hangi projeler etkileniyor |

> ⛔ Bu ayrım olmazsa aynı karar 3 yerde yaşar; biri bayatlar ve ajan
> bayat olanı okur.

## Related
- `CLAUDE.md` §6 — proje izolasyonu + ortak ağ
- `projects/_STANDARTLAR/PROJECT.md` — sahipsiz kararların yaşadığı yer