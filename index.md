# index.md — vault kataloğu

> ⭐ **Bu dosya katalogdur.** Yeni bir sayfa açıldığında veya bir sayfa
> **emekliye ayrıldığında** buraya eklenir/güncellenir.
> ⛔ Bu dosya bir **özet** değildir — **katalog**dur.

## Operasyon dosyaları

| Dosya | Ne |
|---|---|
| `HAZIRLA.md` | ⭐ **"hazırla"** — vault'u kuran tek komut |
| `NASIL_KULLANILIR.md` | ⭐ **sıfırdan adım adım** — birine anlatır gibi |
| `ACIK_ISLER.md` | ⭐ eksi/hata defteri — "sonra düzeltirim" listesi |
| `CLAUDE.md` · `AGENTS.md` | anayasa (her ajan için bağlayıcı) |
| `MANUEL.md` | insan rehberi — dosya nereye gider? |
| `RAW_ISLEM_PROMPT.md` | `raw/` klasörünü işleme komutu |
| `tools/proje-init.ps1` | **yeni proje: TEK KOMUT** - repo + vault + kayit + dogrulama |
| `REPO_ROOT_AGENTS_STUB.md` | repo köküne `AGENTS.md` olarak kopya |
| `ingest-manifest.md` | ⭐ ham kaynak takibi — ajan önce buraya bakar |
| `network.md` | ⭐ çapraz karar haritası |
| `log.md` | append-only olay kaydı |
| `lint-report.md` | son lint raporu |
| `DEV_BRIEF.md` | kod ajanının profil brifi (§3 = kanıtlı dersler) |

## Ajan prompt'ları

| Dosya | Kime |
|---|---|
| `CODING_AGENT_PROMPT.md` | kod ajanı (kod yazan) |
| `LIBRARIAN_AGENT_PROMPT.md` | Kütüphaneci (vault'u yazan) |

## Profil katmanı — "beni zamanla tanıma"

| Dosya | Ne | Durum |
|---|---|---|
| `profile/user.md` | kim olduğun | ⬜ boş |
| `profile/preferences.md` | nasıl çalışmak istediğin | ⬜ boş |
| `profile/reactions.md` | ⭐ **neye tepki verdiğin** — yasak listesi | ⬜ boş |
| `profile/patterns.md` | ajan çıkarımı (terfi etmemiş) | ⬜ boş |

## Projeler

| Proje | Slug | Ne |
|---|---|---|
| _(yok)_ | | |

Şablon: `projects/_TEMPLATE_PROJECT/` · Ortak kurallar:
`projects/_STANDARTLAR/PROJECT.md`

## Kaynaklar — `sources/`

_(yok)_

## Varlıklar — `entities/`

_(kişiler, araçlar, şirketler, servisler)_

## Kavramlar — `concepts/`

_(genel bilgi kavramları)_

## Çapraz ağ — `global/`

| Klasör | Ne |
|---|---|
| `global/decisions/` | ⛔ **sadece pointer** — asıl sayfa `projects/*/decisions/` |
| `global/concepts/` | projeler arası tekrar eden desenler |
| `global/syntheses/` | büyük resim, evrilen tezler |

## Arşiv — `archive/`

_(emekliye ayrılmış sayfalar — asla silinmez)_

## Ham kaynak — `raw/`

⛔ **Dokunulmaz.** Kullanıcı ekler, ajan yalnız okur.

| Klasör | Ne |
|---|---|
| `raw/inbox/` | sınıflandırılmamış |
| `raw/articles/` · `raw/transcripts/` | okuma malzemesi |
| `raw/chats/<ajtör>/` | ⭐ sohbet kayıtları — **tepki sinyali** |
| `raw/knowhow/` | kişiye özel teknik bilgi |
| `raw/projects/<proje>/` | projeye ait belgeler |
| `raw/agent-output/<proje>/` | ajan raporları |
| `raw/_SABLON/` | yeniden üretilebilir şablonlar |

## Araçlar — `tools/`

| Dosya | Ne |
|---|---|
| `proje-init.ps1` | yeni projeyi vault'a bağlar |
| `proje-init-dogrula.ps1` | bağlantıyı doğrular |
| `raw-dogrula.ps1` | `raw/` bütünlüğünü doğrular |
| `vaultignore-dogrula.ps1` | `.vaultignore` kurallarını doğrular |
| `vault-baslangic-dogrula.ps1` | ⭐ kurulum sonrası sağlık kontrolü |
| `secret-vault/` | ⭐ gizli bilgi şifreleme kasası |