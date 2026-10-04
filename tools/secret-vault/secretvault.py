"""
secretvault — vault'ta gizli bilgi saklama araci.

Tasarim:
  * Degerler AES-256-GCM ile sifrelenir. Anahtar paroladan turetilir (scrypt).
  * Parola HICBIR YERE KAYDEDILMEZ. Ne dosya, ne ortam degiskeni, ne log.
  * `.gizli` dosyasinin basligi ACIKTAIR (slug, tur, amac) — ajan "ne var"
    sorusunu sorabilir, "deger nedir" sorusunu soramaz.
  * Anahtar, dosya adinin ve basligin butunlugu icin AAD olarak kullanilir:
    biri dosyayi degistirirse cözme basarisiz olur.

Kullanim:
    python secretvault.py list
    python secretvault.py add
    python secretvault.py import <dosya> <slug> <tur> <amac> [nerede]
    python secretvault.py blob <slug>
    python secretvault.py decrypt <slug>
    python secretvault.py unregister <slug>

    `add` ve `import` ikisi de: sirli sifreler, kayitlar/<slug>.gizli yazar
    ve _GIZLI/INDEX.md tablosuna satirini OTOMATIK ekler.
"""

import base64
import getpass
import os
import sys
import time
from pathlib import Path

from cryptography.hazmat.primitives.ciphers.aead import AESGCM
from cryptography.hazmat.primitives.kdf.scrypt import Scrypt

KOK = Path(__file__).resolve().parent.parent.parent
KAYITLAR = KOK / "_GIZLI" / "kayitlar"
MAGIC = "gizli:v1"
SALT_UZ = 16
NONCE_UZ = 12
KDF_N = 2**15
KDF_R = 8
KDF_P = 1
OK = "[ok]"

# Windows konsolu cp1254 — unicode isareti cokertiyor. UTF-8'a zorla.
for _akis in (sys.stdout, sys.stderr):
    try:
        _akis.reconfigure(encoding="utf-8", errors="replace")
    except Exception:
        pass


def _b64e(b: bytes) -> str:
    return base64.urlsafe_b64encode(b).decode().rstrip("=")


def _b64d(s: str) -> bytes:
    return base64.urlsafe_b64decode(s + "=" * (-len(s) % 4))


def parola_isteyen_mod(sekme: bool = True) -> str:
    """Parolayi sor. Hicbir yere yazilmaz, ekrana yansimaz."""
    while True:
        p = getpass.getpass("Parola: ")
        if not p:
            print("  Bos parola olmaz.", file=sys.stderr)
            continue
        if not sekme:
            return p
        p2 = getpass.getpass("Parola (tekrar): ")
        if p == p2:
            return p
        print("  Eslesmedi, tekrar dene.", file=sys.stderr)


def anahtar_uret(parola: str, salt: bytes) -> bytes:
    kdf = Scrypt(salt=salt, length=32, n=KDF_N, r=KDF_R, p=KDF_P)
    return kdf.derive(parola.encode("utf-8"))


def sifrele(deger: bytes, aad: str, parola: str) -> str:
    salt = os.urandom(SALT_UZ)
    nonce = os.urandom(NONCE_UZ)
    aes = AESGCM(anahtar_uret(parola, salt))
    return f"{MAGIC}:{_b64e(salt)}:{_b64e(nonce)}:{_b64e(aes.encrypt(nonce, deger, aad.encode()))}"


def coz(blob: str, aad: str, parola: str) -> bytes:
    blob = blob.strip()
    onek = MAGIC + ":"
    if not blob.startswith(onek):
        raise ValueError("Bilinmeyen bicim (gizli:v1: ile baslamali).")
    parcalar = blob[len(onek):].split(":")
    if len(parcalar) != 3:
        raise ValueError("Bilinmeyen bicim (salt:nonce:sifreliMetin bekleniyordu).")
    salt, nonce, ct = parcalar
    aes = AESGCM(anahtar_uret(parola, _b64d(salt)))
    return aes.decrypt(_b64d(nonce), _b64d(ct), aad.encode())


def slug_dogrula(slug: str) -> str:
    if not slug or any(c not in "abcdefghijklmnopqrstuvwxyz0123456789-" for c in slug.lower()):
        sys.exit("  Slug hatali: sadece kucuk harf, rakam ve tire.")
    return slug.lower()


def dosya_yolu(slug: str) -> Path:
    return KAYITLAR / f"{slug_dogrula(slug)}.gizli"


INDEX_DOSYA = KOK / "_GIZLI" / "INDEX.md"
TABLO_BASLIK = "| Durum | Kayıt | Tür | Ne için | Nerede kullanılıyor |"


def indexe_yaz(slug: str, tur: str, amac: str, nerede: str) -> None:
    """Kaydi _GIZLI/INDEX.md tablosuna otomatik ekle.

    Elle eklemek unutulabiliyordu; unutulan kayit ajan tarafindan
    gorulemiyor (sir degerle birlikte kayboluyor).
    """
    satir = f"| ✅ | `{slug}` | {tur} | {amac} | {nerede} |"
    if INDEX_DOSYA.exists():
        icerik = INDEX_DOSYA.read_text(encoding="utf-8")
    else:
        icerik = "# Gizli Kutu — İndeks\n\n" + TABLO_BASLIK + "\n|---|---|---|---|---|\n"
    if satir in icerik:
        return
    satirlar = icerik.splitlines()
    for i, l in enumerate(satirlar):
        if l.startswith("|"):
            baslangic, son = i, i
            break
    else:
        icerik = icerik.rstrip() + "\n\n" + TABLO_BASLIK + "\n|---|---|---|---|---|\n" + satir + "\n"
        INDEX_DOSYA.write_text(icerik, encoding="utf-8")
        return
    for i in range(baslangic, len(satirlar) + 1):
        if i >= len(satirlar) or not satirlar[i].startswith("|"):
            son = i - 1
            break
    yeni = satirlar[: son + 1] + [satir] + satirlar[son + 1 :]
    INDEX_DOSYA.write_text("\n".join(yeni) + "\n", encoding="utf-8")


def kayit_yaz(slug: str, tur: str, amac: str, deger: bytes, parola: str,
              nerede: str = "—", indexle: bool = True) -> None:
    KAYITLAR.mkdir(parents=True, exist_ok=True)
    olusturma = time.strftime("%Y-%m-%d")
    baslik = f"slug: {slug}\ntur: {tur}\namac: {amac}\nolusturma: {olusturma}\n"
    blob = sifrele(deger, baslik, parola)
    dosya_yolu(slug).write_text(baslik + blob + "\n", encoding="utf-8")
    os.chmod(dosya_yolu(slug), 0o600)
    if indexle:
        indexe_yaz(slug, tur, amac, nerede)


def kayit_oku(slug: str) -> tuple[dict, str]:
    yol = dosya_yolu(slug)
    if not yol.exists():
        sys.exit(f"  Kayit yok: {slug}")
    ham = yol.read_text(encoding="utf-8").rstrip("\n")
    baslik, blob = ham.split(MAGIC, 1)
    blob = MAGIC + blob
    meta = {}
    for satir in baslik.strip().splitlines():
        if ":" in satir:
            k, v = satir.split(":", 1)
            meta[k.strip()] = v.strip()
    return meta, baslik


def listele() -> None:
    if not KAYITLAR.exists():
        print("  Henuz kayit yok.")
        return
    dosyalar = sorted(KAYITLAR.glob("*.gizli"))
    if not dosyalar:
        print("  Henuz kayit yok.")
        return
    print(f"  {len(dosyalar)} kayit — degerler sifreli, ajan okuyamaz.\n")
    for d in dosyalar:
        meta, _ = kayit_oku(d.stem)
        print(f"  {meta.get('slug','?'):<22} {meta.get('tur','?'):<14} {meta.get('amac','?')}")
    print("\n  Degeri gormek icin:  python secretvault.py decrypt <slug>")
    print("  Veya ac.py uygulamasini kullan.")


def main() -> None:
    if len(sys.argv) < 2:
        print(__doc__)
        return
    komut = sys.argv[1].lower()

    if komut == "list":
        listele()

    elif komut == "add":
        print("  Yeni gizli kayit\n")
        slug = slug_dogrula(input("  slug (kucuk harf/tire): ").strip())
        tur = input("  tur  (db / api-key / mail / ssh / diger): ").strip() or "diger"
        amac = input("  amac (aciklama, degeri YAZMA): ").strip()
        if not amac:
            sys.exit("  Amac bos olamaz.")
        nerede = input("  nerede kullaniliyor (repo/proje, acik yazilir): ").strip() or "—"
        print("  Degeri gir (gizli):")
        deger = getpass.getpass("  deger: ")
        if not deger:
            sys.exit("  Bos deger olmaz.")
        parola = parola_isteyen_mod()
        kayit_yaz(slug, tur, amac, deger.encode("utf-8"), parola, nerede)
        print(f"\n  {OK} Sifrelendi: _GIZLI/kayitlar/{slug}.gizli")
        print(f"    {OK} _GIZLI/INDEX.md tablosu guncellendi")
        print()
        print("  Simdi ne yapabilirsin:")
        print(f"    metni ajana vermek :  python secretvault.py blob {slug}")
        print("    sen cozmek icin    :  python ac.py")
        print()
        print("  DIKKAT: Bu parolayi unutursan geri almanin YOLU YOK.")
        print("  Bir parola yoneticisine yazman onerilir.")

    elif komut == "import":
        if len(sys.argv) < 6:
            sys.exit("  Kullanim: import <dosya> <slug> <tur> <amac> [nerede]")
        kaynak, slug, tur, amac = sys.argv[2], sys.argv[3], sys.argv[4], sys.argv[5]
        nerede = sys.argv[6] if len(sys.argv) > 6 else "—"
        yol = Path(kaynak)
        if not yol.exists():
            sys.exit(f"  Dosya yok: {yol}")
        icerik = yol.read_bytes()
        parola = parola_isteyen_mod()
        kayit_yaz(slug_dogrula(slug), tur, amac, icerik, parola, nerede)
        print(f"\n  {OK} Sifrelendi: _GIZLI/kayitlar/{slug}.gizli  ({len(icerik)} bayt)")
        print(f"    {OK} _GIZLI/INDEX.md tablosu guncellendi")
        print()
        print("  Kaynak dosyaya dokunulmadi. Vault KOPYALAR, sahiplenmez.")
        print()
        print("  Simdi ne yapabilirsin:")
        print(f"    metni ajana vermek :  python secretvault.py blob {slug}")
        print(f"    sen cozmek icin    :  python ac.py   (kayidi sec, metni getir)")
        print()
        print("  Canli proje dosyalari (.env, application-dev.properties, config)")
        print("  SILINMEZ — proje calisirken okur. Yalnizca sifreli yedek alindi.")
        print("  Geri alma gerekirse ayni parolayla yeni kayit yazabilirsin.")

    elif komut == "unregister":
        if len(sys.argv) < 3:
            sys.exit("  Kullanim: unregister <slug>")
        slug = sys.argv[2]
        yol = dosya_yolu(slug)
        if yol.exists():
            yol.unlink()
            print(f"  {OK} Silindi: {yol.name}")
        if INDEX_DOSYA.exists():
            icerik = INDEX_DOSYA.read_text(encoding="utf-8")
            yeni = "\n".join(l for l in icerik.splitlines() if f"`{slug}`" not in l)
            INDEX_DOSYA.write_text(yeni + "\n", encoding="utf-8")
            print(f"    {OK} INDEX.md'den satiri kaldirildi")

    elif komut == "blob":
        if len(sys.argv) < 3:
            sys.exit("  Kullanim: blob <slug>")
        slug = sv_slug = sys.argv[2]
        _, baslik = kayit_oku(slug)
        ham = dosya_yolu(slug).read_text(encoding="utf-8").rstrip("\n")
        print(ham[len(baslik):].strip())

    elif komut == "decrypt":
        if len(sys.argv) < 3:
            sys.exit("  Kullanim: decrypt <slug>")
        slug = sys.argv[2]
        meta, baslik = kayit_oku(slug)
        parola = getpass.getpass("  Parola: ")
        try:
            deger = coz(dosya_yolu(slug).read_text(encoding="utf-8").rstrip("\n")[len(baslik):].strip(), baslik, parola)
        except Exception as e:
            sys.exit(f"  Cozulemedi: {type(e).__name__} (parola yanlis olabilir veya dosya degistirilmis)")
        sys.stdout.write(deger.decode("utf-8", errors="replace"))
        sys.stdout.write("\n")

    else:
        print(__doc__)


if __name__ == "__main__":
    main()
