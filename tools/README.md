# tools/ — araçlar

> Bu klasördeki scriptler **vault'u okur ve raporlar.**
> ⛔ **Hiçbiri kullanıcının kod reposuna dokunmaz.**
> (istisna: `proje-init.ps1` — o kullanıcının **açık komutuyla** çalışır)

## Kurulum doğrulaması

| Script | Ne |
|---|---|
| ⭐ `vault-baslangic-dogrula.ps1` | "hazırla" komutunun son adımı — 9 bölüm sağlık kontrolü |
| `proje-init-dogrula.ps1` | yeni proje bağlantısını doğrular (repo + vault tarafı) |

## Ham kaynak

| Script | Ne |
|---|---|
| `raw-dogrula.ps1` | `raw/` bütünlüğünü doğrular (parmak izi) |
| `vaultignore-dogrula.ps1` | `.vaultignore` kurallarını doğrular |

## Proje kurulumu

| Script | Ne |
|---|---|
| `proje-init.ps1` | ⭐ yeni projeyi vault'a **bağlar**. **IDEMPOTENT** |

**Kullanım:**
```powershell
pwsh -NoProfile -File tools\proje-init.ps1 -Repo "C:\...\yeni-proje"

# sadece kontrol, hiçbir şey yazma:
pwsh -NoProfile -File tools\proje-init.ps1 -Repo "C:\...\yeni-proje" -SadeceDogrula
```

## ⭐ Gizli bilgi kasası

| Script | Ne |
|---|---|
| `secret-vault/secretvault.py` | şifrele / çöz |
| `secret-vault/ac.py` | arayüz (GUI) |

Parola · token · API anahtarı · IBAN · kart/TC/vergi no gibi veriler
`raw/`'a **şifrelenerek** yazılır, `_GIZLI/kayitlar/<slug>.gizli` altında
tutulur. `_GIZLI/INDEX.md` serbest okunur.

> ⛔ **Değeri çözme.** `decrypt`/`coz` komutunu **çalıştırma**, parolayı
> isteme, tahmin etme. Kullanıcı onay verirse sana **şifreli metni** verir.

## ⭐ Bu klasöre ne eklenir / eklenmez

| | |
|---|---|
| ✅ Eklenir | Vault'u okuyan, raporlayan, **idempotent** script |
| ⛔ Eklenmez | Kullanıcının projelerini **değiştiren** script |
| ⛔ Eklenmez | Mutlak yol **içeren** script (tâşınabilir olmalı) |
| ⛔ Eklenmez | Kullanıcıya özel veri içeren script |

> ⭐ **Tâşınabilirlik kuralı:** script kendi yolunu bulur —
> `$vault = Split-Path -Parent (Split-Path -Parent $PSCommandPath)`.
> ⛔ `<WINDOWS_KULLANICI>\...` gibi sabit yol **yazma**; şablon başka
> birine verilecekse o yol kırılır. Ajan `vault-baslangic-dogrula.ps1`
> bunu **sızıntı** olarak raporlar.