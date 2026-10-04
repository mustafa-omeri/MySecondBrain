"""
ac.py — Gizli kutu çözücü (basit arayüz).

Kullanım senaryosu:
  1. Ajan bir şifre ister  ->  sana ŞİFRELİ metni verir
  2. Sen bu metni buraya yapıştırırsın
     (veya aşağıdaki listeden kaydı seçersin, metin otomatik gelir)
  3. Parolanı yazarsın
  4. Metin karşında görünür; 30 sn sonra kendini siler

Güvenlik notları:
  * Parola HİÇBİR YERE yazılmaz — ne dosya, ne log, ne kayıt.
  * Çözülen değer RAM'de kalır, diske YAZILMAZ.
  * 30 sn sonra otomatik gizlenir. Kapatınca temizlenir.
  * Ekran görüntüsü / ekran kaydı bu araç KORUMAZ.
"""

import subprocess
import sys
import tkinter as tk
from pathlib import Path
from tkinter import ttk

import secretvault as sv

KOK = Path(__file__).resolve().parent.parent.parent
KAYITLAR = KOK / "_GIZLI" / "kayitlar"
OTOMATIK_SIFIRLA_SN = 30
NOKTA = "•"


def panoya_kopyala(metin: str) -> bool:
    try:
        if sys.platform.startswith("win"):
            p = subprocess.run(["clip"], input=metin, text=True,
                               capture_output=True, timeout=5)
            return p.returncode == 0
        r = subprocess.run(["pbcopy"], input=metin, text=True, capture_output=True)
        return r.returncode == 0
    except Exception:
        return False


class Uygulama:
    def __init__(self, kok):
        self.kok = kok
        self.sayac = None

        self.y = kok
        self.y.title("Gizli Kutu — Şifreli Metin Çözücü")
        self.y.configure(bg="#1e1e1e")
        self.y.resizable(False, False)

        def baslik(metin, satir):
            tk.Label(self.y, text=metin, bg="#1e1e1e", fg="#8ab4f8",
                     font=("Segoe UI", 10, "bold")).grid(
                row=satir, column=0, sticky="w", padx=14, pady=(14, 4))

        # --- kayit listesi -------------------------------------------------
        baslik("KAYIT", 0)
        self.kayitlar = self._kayit_listesi()
        self.secili = tk.StringVar()
        kutu = ttk.Combobox(self.y, textvariable=self.secili, values=self.kayitlar,
                            state="readonly", width=34, font=("Segoe UI", 10))
        kutu.grid(row=1, column=0, sticky="w", padx=14)
        kutu.bind("<<ComboboxSelected>>", lambda _: self.kayit_yukle())
        self.liste = kutu
        if self.kayitlar:
            self.secili.set(self.kayitlar[0])

        self.yukle_btn = tk.Button(self.y, text="ŞİFRELI METNİ GETİR", command=self.kayit_yukle,
                                   bg="#1f6feb", fg="white", relief="flat", bd=0,
                                   padx=12, pady=3, cursor="hand2",
                                   font=("Segoe UI", 8, "bold"))
        self.yukle_btn.grid(row=1, column=0, sticky="e", padx=14)

        # --- yapıştırma alanı ----------------------------------------------
        baslik("ŞİFRELİ METNİ YAPIŞTIR", 2)
        self.girdi = tk.Text(self.y, width=62, height=5, wrap="char",
                             bg="#0d1117", fg="#c9d1d9", insertbackground="#c9d1d9",
                             font=("Consolas", 9), relief="flat", bd=0)
        self.girdi.grid(row=3, column=0, padx=14)
        self.girdi.bind("<Control-Key-v>", self.yapistir_kisa_yol)

        self.kopyala_btn = tk.Button(self.y, text="Panoya kopyala", command=self.kopyala,
                                     bg="#21262d", fg="#8b949e", relief="flat", bd=0,
                                     padx=10, pady=2, cursor="hand2", font=("Segoe UI", 8))
        self.kopyala_btn.grid(row=4, column=0, sticky="e", padx=14, pady=(4, 0))

        # --- parola --------------------------------------------------------
        baslik("PAROLA", 5)
        self.parola = tk.Entry(self.y, width=54, show=NOKTA, bg="#0d1117",
                               fg="#c9d1d9", insertbackground="#c9d1d9",
                               relief="flat", bd=0, font=("Consolas", 10))
        self.parola.grid(row=6, column=0, padx=14)

        self.dugme = tk.Button(self.y, text="ÇÖZ", command=self.coz, bg="#238636",
                               fg="white", relief="flat", bd=0, padx=22, pady=6,
                               cursor="hand2", font=("Segoe UI", 10, "bold"))
        self.dugme.grid(row=7, column=0, sticky="w", padx=14, pady=12)

        # --- sonuç ----------------------------------------------------------
        baslik("SONUÇ", 8)
        self.sonuc = tk.Text(self.y, width=62, height=6, wrap="char", bg="#161b22",
                             fg="#7ee787", insertbackground="#7ee787",
                             relief="flat", bd=0, font=("Consolas", 9, "bold"))
        self.sonuc.grid(row=9, column=0, padx=14, pady=(4, 8))

        self.alt = tk.Label(self.y, text="", bg="#1e1e1e", fg="#8b949e",
                            font=("Segoe UI", 8), justify="left")
        self.alt.grid(row=10, column=0, sticky="w", padx=14, pady=(0, 12))

        self.parola.bind("<Return>", lambda _: self.coz())
        self.y.bind("<Escape>", lambda _: self.y.destroy())
        self.y.protocol("WM_DELETE_WINDOW", self.kapat)
        self.parola.focus_set()

    # ------------------------------------------------------------------ #
    @staticmethod
    def _kayit_listesi():
        if not KAYITLAR.exists():
            return []
        adlar = []
        for d in sorted(KAYITLAR.glob("*.gizli")):
            try:
                meta, _ = sv.kayit_oku(d.stem)
            except Exception:
                continue
            amac = meta.get("amac", "")
            adlar.append(f"{meta.get('slug', d.stem)}  —  {amac}")
        return adlar

    def _slug(self) -> str:
        secili = self.secili.get() or ""
        return secili.split("  —  ")[0].strip()

    def kayit_yukle(self):
        slug = self._slug()
        if not slug:
            return
        try:
            _, baslik = sv.kayit_oku(slug)
        except SystemExit:
            self._bilgi("Bu kayıt okunamadı.")
            return
        ham = sv.dosya_yolu(slug).read_text(encoding="utf-8").rstrip("\n")
        blob = ham[len(baslik):].strip()
        self.girdi.configure(state="normal")
        self.girdi.delete("1.0", "end")
        self.girdi.insert("1.0", blob)
        self.alt.configure(text=f"Yüklendi: {slug}   |   metni ajana verebilirsin")

    def yapistir_kisa_yol(self, olay):
        try:
            metin = self.y.clipboard_get()
        except Exception:
            return
        self.girdi.configure(state="normal")
        self.girdi.delete("1.0", "end")
        self.girdi.insert("1.0", metin)
        return "break"

    def kopyala(self):
        s = self.girdi.get("1.0", "end").strip()
        if not s:
            self._bilgi("Önce bir kayıt seç veya metni yapıştır.")
            return
        if panoya_kopyala(s):
            self.alt.configure(text="Şifreli metin panoya kopyalandı.")
        else:
            self._bilgi("Panoya kopyalanamadı — alanı elle seçip kopyala.")

    def _bilgi(self, metin):
        self.alt.configure(text=metin)

    # ------------------------------------------------------------------ #
    @staticmethod
    def _oku_ve_sifirla(kutu, gizle):
        if isinstance(kutu, tk.Entry):
            s = kutu.get()
            kutu.delete(0, "end")
            kutu.insert(0, NOKTA * len(s) if gizle else s)
        else:
            s = kutu.get("1.0", "end")
            kutu.delete("1.0", "end")
            kutu.insert("1.0", NOKTA * len(s) if gizle else s)
        kutu.configure(state="disabled")
        return s

    @staticmethod
    def _baslat(kutu):
        kutu.configure(state="normal")

    def kapat(self):
        if self.sayac:
            try:
                self.kok.after_cancel(self.sayac)
            except Exception:
                pass
        try:
            self.sonuc.delete("1.0", "end")
        except Exception:
            pass
        self.y.destroy()

    def _sayaci_baslat(self):
        kalan = {"n": OTOMATIK_SIFIRLA_SN}

        def geri():
            kalan["n"] -= 1
            if kalan["n"] <= 0:
                self.sonuc.configure(state="normal")
                self.sonuc.delete("1.0", "end")
                self.sonuc.insert("1.0", "(kendi kendine temizlendi)")
                self.alt.configure(text="Temizlendi.")
                self.sayac = None
            else:
                self.alt.configure(
                    text=f"Otomatik temizleme — {kalan['n']} sn   |   "
                         f"Kapatmak için ESC")
                self.sayac = self.kok.after(1000, geri)

        self.alt.configure(
            text=f"Otomatik temizleme — {OTOMATIK_SIFIRLA_SN} sn   |   "
                 f"Kapatmak için ESC")
        self.sayac = self.kok.after(1000, geri)

    @staticmethod
    def _normalize(s: str) -> str:
        """Yapistirma bozulmalarini tolere et: bosluk, satir sonu, tirnak."""
        return "".join(s.split()).replace("\u201c", "").replace("\u201d", "")

    def _aad_bul(self, blob: str):
        """Sifreli metin hangi kayda ait? Basligi (AAD) dondurur.

        Uc kademe eslesme — kopyalama sirasinda metin bozulabilir:
          1) birebir  2) bosluk/satir sonu temizlenmis  3) onek (kirpma toleransi)
        """
        hedef = self._normalize(blob)
        if not hedef or not KAYITLAR.exists():
            return None, "Metin kutusu bos ya da kasa yok."

        adaylar = []
        for d in sorted(KAYITLAR.glob("*.gizli")):
            try:
                ham = d.read_text(encoding="utf-8").rstrip("\n")
            except Exception:
                continue
            baslik, sep, kismi = ham.partition("gizli:v1:")
            if sep:
                adaylar.append((d.stem, baslik, "gizli:v1:" + kismi.strip()))

        for _, baslik, gercek in adaylar:
            if gercek == blob.strip():
                return baslik, None
        for _, baslik, gercek in adaylar:
            if self._normalize(gercek) == hedef:
                return baslik, None
        for _, baslik, gercek in adaylar:
            if len(hedef) >= 60 and hedef.startswith(self._normalize(gercek)[:60]):
                return baslik, None

        self.bulunamayan = (hedef, adaylar)
        return None, None

    def _teshis(self, blob: str, neden):
        """Kayit bulunamadiysa NEDENini somut olarak goster.

        Parola bu asamda hic denenmemistir — yani "parola yanlis" ile
        "metin bozulmus" birbirine karismasin diye ayirt edici mesaj.
        """
        satirlar = []
        g = self._normalize(blob)
        if neden:
            satirlar.append(neden)
            return "\n".join(satirlar)

        satirlar.append("Kayıt BULUNAMADI — parola henüz denenmedi.")
        satirlar.append("")
        satirlar.append(f"  Yapıştırdığın metin : {len(g)} karakter")
        if g:
            satirlar.append(f"  Başı                : {g[:34]}")
            satirlar.append(f"  Sonu                : ...{g[-18:]}")
        adaylar = getattr(self, "bulunamayan", ([], []))[1] if hasattr(self, "bulunamayan") else []
        for slug, _, gercek in adaylar:
            g2 = self._normalize(gercek)
            satirlar.append(f"  Kasadaki {slug:<28} : {len(g2)} karakter")
        satirlar.append("")
        satirlar.append("En olası neden: metin kopyalanırken bozuldu")
        satirlar.append("(satır kayması, kesilme, akıllı tırnak).")
        satirlar.append("")
        satirlar.append("En güvenli yol: yukarıdaki KAYIT listesinden seçip")
        satirlar.append("ŞİFRELI METNİ GETİR'e bas — elle yapıştırma.")
        return "\n".join(satirlar)

    def coz(self):
        self.sonuc.configure(state="normal")
        self.sonuc.delete("1.0", "end")
        self.dugme.configure(state="disabled")

        blob = self._oku_ve_sifirla(self.girdi, gizle=True)
        parola = self._oku_ve_sifirla(self.parola, gizle=True)

        if not blob or not parola:
            self.sonuc.insert(
                "1.0",
                "Önce kayıt seçip ŞİFRELİ METNİ GETİR'e bas,\n"
                "sonra parolayı yaz.")
            self.dugme.configure(state="normal")
            self._baslat(self.girdi)
            self._baslat(self.parola)
            self.parola.focus_set()
            return

        aad, neden = self._aad_bul(blob)
        if aad is None:
            self.sonuc.insert("1.0", self._teshis(blob, neden))
        else:
            try:
                deger = sv.coz(blob, aad, parola)
            except Exception as e:
                tip = type(e).__name__
                if tip == "InvalidTag":
                    mesaj = ("\u00c7\u00f6z\u00fclemedi: **parola yanl\u0131\u015f**.\n\n"
                             "Kay\u0131t do\u011fru bulundu, yani \u015fifreli metin sa\u011flam.\n"
                             "Parolay\u0131 kontrol et \u2014 b\u00fcy\u00fck harf / TR klavye fark\u0131 olabilir.")
                elif tip in ("OverflowError", "ValueError"):
                    mesaj = f"\u00c7\u00f6z\u00fclemedi: bi\u00e7im hatas\u0131 ({tip})."
                else:
                    mesaj = f"\u00c7\u00f6z\u00fclemedi: {tip}"
                self.sonuc.insert("1.0", mesaj)
            else:
                self.sonuc.insert("1.0", deger.decode("utf-8", errors="replace"))
                self._sayaci_baslat()

        self.dugme.configure(state="normal")
        self._baslat(self.girdi)
        self._baslat(self.parola)
        self.parola.focus_set()

    def _ekrana_sigdir(self):
        self.y.update_idletasks()
        gx, gy = self.y.winfo_screenwidth(), self.y.winfo_screenheight()
        w, h = self.y.winfo_width(), self.y.winfo_height()
        if w > 1 and h > 1:
            self.y.geometry(f"+{max(0, (gx - w) // 2)}+{max(0, (gy - h) // 3)}")

    def calistir(self):
        self._ekrana_sigdir()
        self.y.deiconify()
        self.y.lift()
        self.y.attributes("-topmost", True)
        self.y.after(300, lambda: self.y.attributes("-topmost", False))
        self.y.focus_force()
        self.y.update_idletasks()
        self.y.mainloop()


if __name__ == "__main__":
    k = tk.Tk()
    k.withdraw()
    Uygulama(k).calistir()