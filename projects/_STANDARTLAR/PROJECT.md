---
title: Ortak Kurallar (sahipsiz projeler arası)
type: project
project: _STANDARTLAR
status: reviewed
confidence: stated
created: 2026-10-04
updated: 2026-10-04
tags: [standart, karar, her-proje]
---

# _STANDARTLAR — her projeye uygulanan kurallar

> ⭐ Bu, **hiçbir projeye ait olmayan** kararların yaşadığı yerdir.
> Bir karar birden fazla projeyi etkiliyorsa ya da doğrudan stratejikse
> buraya gider.
>
> ⛔ **`global/decisions/` buraya POINTER'dır, içerik değil.**
> Tek doğruluk kaynağı bu klasör. `network.md` etki alanını tutar.

## Bu dosyayı kod ajanı okur

`CLAUDE.md` §8 ADIM 4: **atlanmaz.** Yeni projeye başlarken buraya bak.

## Kurallar

_(henüz karar yok — kullanım başladıkça dolar)_

## ⭐ Karar nasıl eklenir?

Her karar **atomik** bir sayfa olur: `decisions/<slug>.md`

| | |
|---|---|
| Slug | **kebab-case** |
| Frontmatter | `type: decision` · `scope: cross-project \| project-only` |
| İçerik | Karar · Gerekçe · **Değerlendirilen alternatifler** · Etkilenen projeler |
| Etki alanı | `network.md`'ye **bir satır** düşer |

⛔ **"Değerlendirilen alternatifler" boş bırakılamaz.** Üç dürüst seçenek:
(1) gerçekten düşünüldü — somut gerekçe, (2) ajan düşünmedi —
*"değerlendirmedi"* + neden (utanç değil, dürüstlük), (3) kaynakta yok —
*"ajan uydurmadı"*.

## ⭐ Bir kararı değiştirmek

Eski sayfa **değiştirilmez, silinmez.** Yeni sayfa açılır:

```yaml
supersedes: <eski-slug>
```

Eski sayfaya `status: superseded` + `superseded_by:` eklenir.

## Related
- `CLAUDE.md` §6 — izolasyon + ortak ağ
- `network.md` — etki haritası
- `DEV_BRIEF.md` — kod ajanının brifi