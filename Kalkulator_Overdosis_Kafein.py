import os
import sys

BERAT_MIN = 10
BERAT_MAX = 300


def cetak_garis():
    print("---------------------------------------------------------")


def cetak_header():
    print("=========================================================")
    print("               KALKULATOR DOSIS KAFEIN v1.1              ")
    print("=========================================================")


def clear_screen():
    os.system('cls' if os.name == 'nt' else 'clear')


def minta_input_dengan_percobaan(tampilkan_opsi, proses_pilihan, max_percobaan=3):
    """
    Menampilkan opsi lalu meminta input, mengulang hingga max_percobaan kali
    jika pilihan tidak valid. proses_pilihan(pilihan) harus mengembalikan
    (berhasil: bool, hasil: any).
    Mengembalikan (berhasil, hasil) setelah valid, atau (False, None) jika
    percobaan habis.
    """
    percobaan = 1
    while percobaan <= max_percobaan:
        if percobaan > 1:
            print(f"[Peringatan] Pilihan tidak valid. Percobaan ke-{percobaan} dari {max_percobaan}.")
        pilihan = tampilkan_opsi()
        berhasil, hasil = proses_pilihan(pilihan)
        if berhasil:
            return True, hasil
        percobaan += 1
    return False, None


while True:
    clear_screen()
    cetak_header()

    print(f"(Masukkan angka antara {BERAT_MIN}-{BERAT_MAX} kg, boleh desimal, mis. 65.5)")
    berat_badan_input = input("Masukkan berat badan Anda (kg): ").strip().replace(",", ".")

    try:
        berat_badan = float(berat_badan_input)
        if not (BERAT_MIN <= berat_badan <= BERAT_MAX):
            raise ValueError
    except ValueError:
        print(f"[Sistem Error] Input salah. Masukkan angka antara {BERAT_MIN}-{BERAT_MAX} kg.")
        cetak_garis()
        input("Tekan Enter untuk mencoba lagi...")
        continue

    kafein_per_saji = 0
    satuan = ""
    nama_minuman = ""

    def tampilkan_menu_minuman():
        print("")
        print("[ PILIHAN DATABASE MINUMAN ]")
        print(f"{'ID':<4} | {'Jenis Minuman':<32} | {'Perkiraan Kafein':<15}")
        cetak_garis()
        print(f"{'1':<4} | {'Kopi Hitam / Brewed Coffee':<32} | {'100 mg/cangkir':<15}")
        print(f"{'2':<4} | {'Kopi Instan / Saset':<32} | {'65 mg/saset':<15}")
        print(f"{'3':<4} | {'Minuman Energi / Energy Drink':<32} | {'80 mg/kaleng':<15}")
        print(f"{'4':<4} | {'Teh / Minuman Bersoda':<32} | {'35 mg/gelas':<15}")
        print(f"{'5':<4} | {'Input Kafein Manual (mg)':<32} | {'sesuai input':<15}")
        cetak_garis()
        print(f"Berat badan tersimpan: {berat_badan:g} kg")
        return input("Pilih ID minuman (1-5) atau Tekan Enter untuk Lewati: ").strip()

    def proses_pilihan_minuman(pilihan):
        global kafein_per_saji, satuan, nama_minuman
        opsi = {
            "1": (100, "cangkir", "Kopi Hitam"),
            "2": (65, "saset", "Kopi Instan"),
            "3": (80, "kaleng", "Minuman Energi"),
            "4": (35, "gelas", "Teh/Soda"),
        }
        if pilihan in opsi:
            kafein_per_saji, satuan, nama_minuman = opsi[pilihan]
            return True, None
        elif pilihan == "5":
            manual_input = input("Masukkan kadar kafein per saji (mg): ").strip().replace(",", ".")
            try:
                nilai = float(manual_input)
                if nilai <= 0:
                    raise ValueError
            except ValueError:
                print("[Sistem Error] Nilai kafein harus angka positif.")
                return False, None
            kafein_per_saji = nilai
            satuan = "saji"
            nama_minuman = "Minuman Kustom"
            return True, None
        elif pilihan == "":
            kafein_per_saji = 0
            return True, None
        else:
            clear_screen()
            cetak_header()
            return False, None

    input_valid, _ = minta_input_dengan_percobaan(tampilkan_menu_minuman, proses_pilihan_minuman)

    if not input_valid:
        print("")
        print("[Sistem Error] Anda salah memasukkan ID sebanyak 3 kali.")
        print("Program otomatis diulang ke menu awal.")
        cetak_garis()
        input("Tekan Enter untuk kembali mengisi berat badan...")
        continue

    batas_aman = berat_badan * 4
    if batas_aman > 400:
        batas_aman = 400

    batas_overdosis = berat_badan * 15
    batas_lethal = berat_badan * 150

    print("")
    print("=========================================================")
    print(f" LAPORAN DOSIS KAFEIN (BERAT BADAN: {berat_badan:g} KG) ")
    print("=========================================================")

    print("")
    print("1. BATAS AMAN KONSUMSI (SAFE LIMIT)")
    print(f"   Kadar Maksimal : {batas_aman:g} mg / hari")
    if kafein_per_saji > 0:
        ekuivalensi = batas_aman / kafein_per_saji
        print(f"   Setara Dengan  : {ekuivalensi:.1f} {satuan} {nama_minuman}")

    print("")
    print("2. AMBANG BATAS OVERDOSIS (OVERDOSE THRESHOLD)")
    print(f"   Kadar Bahaya   : {batas_overdosis:g} mg dalam sekali minum")
    if kafein_per_saji > 0:
        ekuivalensi = batas_overdosis / kafein_per_saji
        print(f"   Setara Dengan  : {ekuivalensi:.1f} {satuan} {nama_minuman}")
    print("   Efek Samping   : Jantung berdebar kencang, cemas parah, tangan gemetar, mual, dan muntah.")

    print("")
    print("3. DOSIS RACUN FATAL (LETHAL DOSE)")
    print(f"   Kadar Mematikan: {batas_lethal:g} mg")
    if kafein_per_saji > 0:
        ekuivalensi = batas_lethal / kafein_per_saji
        print(f"   Setara Dengan  : {ekuivalensi:.1f} {satuan} {nama_minuman}")
    print("   Efek Samping   : Risiko kejang parah, kerusakan irama jantung, hingga henti jantung (fatal).")

    print("")
    cetak_garis()
    print("[Catatan] Angka di atas adalah estimasi umum berbasis mg/kg berat badan,")
    print("BUKAN diagnosis medis. Toleransi kafein berbeda-beda tiap orang, dan")
    print("angka ini bisa jauh lebih rendah untuk ibu hamil, anak-anak, lansia,")
    print("atau orang dengan gangguan jantung. Konsultasikan ke tenaga medis")
    print("untuk kondisi kesehatan spesifik.")
    print("=========================================================")

    def tampilkan_menu_keluar():
        print("")
        print("Apakah Anda ingin menghitung ulang?")
        print("1. Ya (Kembali ke Awal)")
        print("2. Tidak (Keluar Program)")
        return input("Masukkan pilihan Anda (1/2): ").strip()

    def proses_pilihan_keluar(pilihan):
        if pilihan == "1":
            return True, "ulang"
        elif pilihan == "2":
            print("\n[Sistem] Terima kasih telah menggunakan kalkulator kafein. Selesai.")
            sys.exit(0)
        else:
            return False, None

    keluar_valid, _ = minta_input_dengan_percobaan(tampilkan_menu_keluar, proses_pilihan_keluar)

    if not keluar_valid:
        print("\n[Sistem Reset] Salah memilih menu 3 kali. Kembali ke menu utama.")
        cetak_garis()
        input("Tekan Enter...")
