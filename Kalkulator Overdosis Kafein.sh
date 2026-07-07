#!/bin/bash

cetak_garis() {
    echo "---------------------------------------------------------"
}

cetak_header() {
    echo "========================================================="
    echo "    		KALKULATOR DOSIS KAFEIN v1.0	           "
    echo "========================================================="
}

while true; do
    clear
    cetak_header

    echo -n "Masukkan berat badan Anda (kg): "
    read berat_badan

    if ! [[ "$berat_badan" =~ ^[0-9]+$ ]] || [ "$berat_badan" -le 0 ]; then
        echo "[Sistem Error] Input salah. Silakan masukkan angka bulat positif."
        cetak_garis
        echo -n "Tekan Enter untuk mencoba lagi..."
        read
        continue  
    fi

    percobaan=1
    input_valid=false

    while [ "$percobaan" -le 3 ]; do
        echo ""
        echo "[ PILIHAN DATABASE MINUMAN ]"
        printf "%-4s | %-32s | %-15s\n" "ID" "Jenis Minuman" "Perkiraan Kafein"
        cetak_garis
        printf "%-4s | %-32s | %-15s\n" "1" "Kopi Hitam / Brewed Coffee" "100 mg/cangkir"
        printf "%-4s | %-32s | %-15s\n" "2" "Kopi Instan / Saset" "65 mg/saset"
        printf "%-4s | %-32s | %-15s\n" "3" "Minuman Energi / Energy Drink" "80 mg/kaleng"
        printf "%-4s | %-32s | %-15s\n" "4" "Teh / Minuman Bersoda" "35 mg/gelas"
        cetak_garis

        if [ "$percobaan" -gt 1 ]; then
            echo "[Peringatan] Pilihan salah. Percobaan ke-$percobaan dari 3."
        fi

        echo -n "Pilih ID minuman (1-4) atau Tekan Enter untuk Lewati: "
        read pilihan

        case $pilihan in
            1) kafein_per_saji=100; satuan="cangkir"; nama_minuman="Kopi Hitam"; input_valid=true; break;;
            2) kafein_per_saji=65; satuan="saset"; nama_minuman="Kopi Instan"; input_valid=true; break;;
            3) kafein_per_saji=80; satuan="kaleng"; nama_minuman="Minuman Energi"; input_valid=true; break;;
            4) kafein_per_saji=35; satuan="gelas"; nama_minuman="Teh/Soda"; input_valid=true; break;;
            "") kafein_per_saji=0; input_valid=true; break;; 
            *) 
                clear
                cetak_header
                printf "Berat badan tersimpan: %d kg\n" "$berat_badan"
                percobaan=$((percobaan + 1))
                ;;
        esac
    done

    if [ "$input_valid" = false ]; then
        echo ""
        echo "[Sistem Error] Anda salah memasukkan ID sebanyak 3 kali."
        echo "Program otomatis diulang ke menu awal."
        cetak_garis
        echo -n "Tekan Enter untuk kembali mengisi berat badan..."
        read
        continue 
    fi

    batas_aman=$((berat_badan * 4))
    if [ "$batas_aman" -gt 400 ]; then
        batas_aman=400
    fi

    batas_overdosis=$((berat_badan * 15))
    batas_lethal=$((berat_badan * 150))

    echo ""
    echo "========================================================="
    printf " LAPORAN DOSIS KAFEIN (BERAT BADAN: %d KG) \n" "$berat_badan"
    echo "========================================================="

    echo ""
    echo "1. BATAS AMAN KONSUMSI (SAFE LIMIT)"
    printf "   Kadar Maksimal : %d mg / hari\n" "$batas_aman"
    if [ "$kafein_per_saji" -gt 0 ]; then
        servings_int=$((batas_aman / kafein_per_saji))
        servings_dec=$(((batas_aman * 10 / kafein_per_saji) % 10))
        echo "   Setara Dengan  : $servings_int.$servings_dec $satuan $nama_minuman"
    fi

    echo ""
    echo "2. AMBANG BATAS OVERDOSIS (OVERDOSE THRESHOLD)"
    printf "   Kadar Bahaya   : %d mg dalam sekali minum\n" "$batas_overdosis"
    if [ "$kafein_per_saji" -gt 0 ]; then
        servings_int=$((batas_overdosis / kafein_per_saji))
        servings_dec=$(((batas_overdosis * 10 / kafein_per_saji) % 10))
        echo "   Setara Dengan  : $servings_int.$servings_dec $satuan $nama_minuman"
    fi
    echo "   Efek Samping   : Jantung berdebar kencang, cemas parah, tangan gemetar, mual, dan muntah."

    echo ""
    echo "3. DOSIS RACUN FATAL (LETHAL DOSE)"
    printf "   Kadar Mematikan: %d mg\n" "$batas_lethal"
    if [ "$kafein_per_saji" -gt 0 ]; then
        servings_int=$((batas_lethal / kafein_per_saji))
        servings_dec=$(((batas_lethal * 10 / kafein_per_saji) % 10))
        echo "   Setara Dengan  : $servings_int.$servings_dec $satuan $nama_minuman"
    fi
    echo "   Efek Samping   : Risiko kejang parah, kerusakan irama jantung, hingga henti jantung (fatal)."

    echo ""
    echo "========================================================="

    percobaan_keluar=1
    keluar_valid=false
    
    while [ "$percobaan_keluar" -le 3 ]; do
        echo ""
        echo "Apakah Anda ingin menghitung ulang?"
        echo "1. Ya (Kembali ke Awal)"
        echo "2. Tidak (Keluar Program)"
        
        if [ "$percobaan_keluar" -gt 1 ]; then
            echo "[Peringatan] Pilihan tidak valid. Ketik angka 1 atau 2."
        fi
        
        echo -n "Masukkan pilihan Anda (1/2): "
        read menu_keluar

        if [ "$menu_keluar" == "1" ]; then
            keluar_valid=true
            break
        elif [ "$menu_keluar" == "2" ]; then
            echo -e "\n[Sistem] Terima kasih telah menggunakan kalkulator kafein. Selesai."
            exit 0 
        else
            percobaan_keluar=$((percobaan_keluar + 1))
        fi
    done

    if [ "$keluar_valid" = false ]; then
        echo -e "\n[Sistem Reset] Salah memilih menu 3 kali. Kembali ke menu utama."
        cetak_garis
        echo -n "Tekan Enter..."
        read
    fi
done