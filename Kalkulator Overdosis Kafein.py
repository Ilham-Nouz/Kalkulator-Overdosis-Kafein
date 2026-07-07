import os
import sys

def cetak_garis():
    print("---------------------------------------------------------")

def cetak_header():
    print("=========================================================")
    print("    		KALKULATOR DOSIS KAFEIN v1.0	           ")
    print("=========================================================")

def clear_screen():
    os.system('cls' if os.name == 'nt' else 'clear')

while True:
    clear_screen()
    cetak_header()

    berat_badan_input = input("Masukkan berat badan Anda (kg): ").strip()

    if not berat_badan_input.isdigit() or int(berat_badan_input) <= 0:
        print("[Sistem Error] Input salah. Silakan masukkan angka bulat positif.")
        cetak_garis()
        input("Tekan Enter untuk mencoba lagi...")
        continue

    berat_badan = int(berat_badan_input)
    percobaan = 1
    input_valid = False
    kafein_per_saji = 0
    satuan = ""
    nama_minuman = ""

    while percobaan <= 3:
        print("")
        print("[ PILIHAN DATABASE MINUMAN ]")
        print(f"{'ID':<4} | {'Jenis Minuman':<32} | {'Perkiraan Kafein':<15}")
        cetak_garis()
        print(f"{'1':<4} | {'Kopi Hitam / Brewed Coffee':<32} | {'100 mg/cangkir':<15}")
        print(f"{'2':<4} | {'Kopi Instan / Saset':<32} | {'65 mg/saset':<15}")
        print(f"{'3':<4} | {'Minuman Energi / Energy Drink':<32} | {'80 mg/kaleng':<15}")
        print(f"{'4':<4} | {'Teh / Minuman Bersoda':<32} | {'35 mg/gelas':<15}")
        cetak_garis()

        if percobaan > 1:
            print(f"[Peringatan] Pilihan salah. Percobaan ke-{percobaan} dari 3.")

        pilihan = input("Pilih ID minuman (1-4) atau Tekan Enter untuk Lewati: ").strip()

        if pilihan == "1":
            kafein_per_saji = 100
            satuan = "cangkir"
            nama_minuman = "Kopi Hitam"
            input_valid = True
            break
        elif pilihan == "2":
            kafein_per_saji = 65
            satuan = "saset"
            nama_minuman = "Kopi Instan"
            input_valid = True
            break
        elif pilihan == "3":
            kafein_per_saji = 80
            satuan = "kaleng"
            nama_minuman = "Minuman Energi"
            input_valid = True
            break
        elif pilihan == "4":
            kafein_per_saji = 35
            satuan = "gelas"
            nama_minuman = "Teh/Soda"
            input_valid = True
            break
        elif pilihan == "":
            kafein_per_saji = 0
            input_valid = True
            break
        else:
            clear_screen()
            cetak_header()
            print(f"Berat badan tersimpan: {berat_badan} kg")
            percobaan += 1

    if not input_valid:
        print("")
        print("[Sistem Error] Anda salah memasukkan ID sebanyak 3 kali.")
        print("Program otomatis diulang ke menu awal.")
        cetak_garis()
        input("Tekan Enter untuk kembali mengisi berat badan...")
        continue

    # Batas aman medis max 400 mg sehari
    batas_aman = berat_badan * 4
    if batas_aman > 400:
        batas_aman = 400

    batas_overdosis = berat_badan * 15
    batas_lethal = berat_badan * 150

    print("")
    print("=========================================================")
    print(f" LAPORAN DOSIS KAFEIN (BERAT BADAN: {berat_badan} KG) ")
    print("=========================================================")

    print("")
    print("1. BATAS AMAN KONSUMSI (SAFE LIMIT)")
    print(f"   Kadar Maksimal : {batas_aman} mg / hari")
    if kafein_per_saji > 0:
        ekuivalensi = batas_aman / kafein_per_saji
        print(f"   Setara Dengan  : {ekuivalensi:.1f} {satuan} {nama_minuman}")

    print("")
    print("2. AMBANG BATAS OVERDOSIS (OVERDOSE THRESHOLD)")
    print(f"   Kadar Bahaya   : {batas_overdosis} mg dalam sekali minum")
    if kafein_per_saji > 0:
        ekuivalensi = batas_overdosis / kafein_per_saji
        print(f"   Setara Dengan  : {ekuivalensi:.1f} {satuan} {nama_minuman}")
    print("   Efek Samping   : Jantung berdebar kencang, cemas parah, tangan gemetar, mual, dan muntah.")

    print("")
    print("3. DOSIS RACUN FATAL (LETHAL DOSE)")
    print(f"   Kadar Mematikan: {batas_lethal} mg")
    if kafein_per_saji > 0:
        ekuivalensi = batas_lethal / kafein_per_saji
        print(f"   Setara Dengan  : {ekuivalensi:.1f} {satuan} {nama_minuman}")
    print("   Efek Samping   : Risiko kejang parah, kerusakan irama jantung, hingga henti jantung (fatal).")

    print("")
    print("=========================================================")

    percobaan_keluar = 1
    keluar_valid = False

    while percobaan_keluar <= 3:
        print("")
        print("Apakah Anda ingin menghitung ulang?")
        print("1. Ya (Kembali ke Awal)")
        print("2. Tidak (Keluar Program)")

        if percobaan_keluar > 1:
            print("[Peringatan] Pilihan tidak valid. Ketik angka 1 atau 2.")

        menu_keluar = input("Masukkan pilihan Anda (1/2): ").strip()

        if menu_keluar == "1":
            keluar_valid = True
            break
        elif menu_keluar == "2":
            print("\n[Sistem] Terima kasih telah menggunakan kalkulator kafein. Selesai.")
            sys.exit(0)
        else:
            percobaan_keluar += 1

    if not keluar_valid:
        print("\n[Sistem Reset] Salah memilih menu 3 kali. Kembali ke menu utama.")
        cetak_garis()
        input("Tekan Enter...")