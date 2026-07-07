#!/bin/bash

BERAT_MIN=10
BERAT_MAX=300

cetak_garis() {
    echo "---------------------------------------------------------"
}

cetak_header() {
    echo "========================================================="
    echo "               KALKULATOR DOSIS KAFEIN v1.1               "
    echo "========================================================="
}

fmt_num() {
    awk -v n="$1" 'BEGIN {
        if (n == int(n)) printf "%d", n; else printf "%.1f", n
    }'
}

while true; do
    clear
    cetak_header

    echo "(Masukkan angka antara $BERAT_MIN-$BERAT_MAX kg, boleh desimal, mis. 65.5)"
    echo -n "Masukkan berat badan Anda (kg): "
    read -r berat_badan_input
    berat_badan_input=${berat_badan_input//,/.}

    if ! [[ "$berat_badan_input" =~ ^[0-9]+(\.[0-9]+)?$ ]]; then
        echo "[Sistem Error] Input salah. Masukkan angka antara $BERAT_MIN-$BERAT_MAX kg."
        cetak_garis
        echo -n "Tekan Enter untuk mencoba lagi..."
        read -r
        continue
    fi

    dalam_batas=$(awk -v b="$berat_badan_input" -v min="$BERAT_MIN" -v max="$BERAT_MAX" \
        'BEGIN { print (b >= min && b <= max) ? "1" : "0" }')
    if [ "$dalam_batas" != "1" ]; then
        echo "[Sistem Error] Input salah. Masukkan angka antara $BERAT_MIN-$BERAT_MAX kg."
        cetak_garis
        echo -n "Tekan Enter untuk mencoba lagi..."
        read -r
        continue
    fi

    berat_badan="$berat_badan_input"

    percobaan=1
    input_valid=false
    kafein_per_saji=0
    satuan=""
    nama_minuman=""

    while [ "$percobaan" -le 3 ]; do
        echo ""
        echo "[ PILIHAN DATABASE MINUMAN ]"
        printf "%-4s | %-32s | %-15s\n" "ID" "Jenis Minuman" "Perkiraan Kafein"
        cetak_garis
        printf "%-4s | %-32s | %-15s\n" "1" "Kopi Hitam / Brewed Coffee" "100 mg/cangkir"
        printf "%-4s | %-32s | %-15s\n" "2" "Kopi Instan / Saset" "65 mg/saset"
        printf "%-4s | %-32s | %-15s\n" "3" "Minuman Energi / Energy Drink" "80 mg/kaleng"
        printf "%-4s | %-32s | %-15s\n" "4" "Teh / Minuman Bersoda" "35 mg/gelas"
        printf "%-4s | %-32s | %-15s\n" "5" "Input Kafein Manual (mg)" "sesuai input"
        cetak_garis

        if [ "$percobaan" -gt 1 ]; then
            echo "[Peringatan] Pilihan salah. Percobaan ke-$percobaan dari 3."
        fi

        echo "Berat badan tersimpan: $(fmt_num "$berat_badan") kg"
        echo -n "Pilih ID minuman (1-5) atau Tekan Enter untuk Lewati: "
        read -r pilihan

        case $pilihan in
            1) kafein_per_saji=100; satuan="cangkir"; nama_minuman="Kopi Hitam"; input_valid=true; break;;
            2) kafein_per_saji=65; satuan="saset"; nama_minuman="Kopi Instan"; input_valid=true; break;;
            3) kafein_per_saji=80; satuan="kaleng"; nama_minuman="Minuman Energi"; input_valid=true; break;;
            4) kafein_per_saji=35; satuan="gelas"; nama_minuman="Teh/Soda"; input_valid=true; break;;
            5)
                echo -n "Masukkan kadar kafein per saji (mg): "
                read -r manual_input
                manual_input=${manual_input//,/.}
                manual_ok=$(awk -v n="$manual_input" 'BEGIN { print (n ~ /^[0-9]+(\.[0-9]+)?$/ && n+0 > 0) ? "1" : "0" }' 2>/dev/null)
                if [ "$manual_ok" = "1" ]; then
                    kafein_per_saji="$manual_input"
                    satuan="saji"
                    nama_minuman="Minuman Kustom"
                    input_valid=true
                    break
                else
                    echo "[Sistem Error] Nilai kafein harus angka positif."
                    percobaan=$((percobaan + 1))
                fi
                ;;
            "") kafein_per_saji=0; input_valid=true; break;;
            *)
                clear
                cetak_header
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
        read -r
        continue
    fi

    batas_aman=$(awk -v b="$berat_badan" 'BEGIN { v = b * 4; if (v > 400) v = 400; print v }')
    batas_overdosis=$(awk -v b="$berat_badan" 'BEGIN { print b * 15 }')
    batas_lethal=$(awk -v b="$berat_badan" 'BEGIN { print b * 150 }')

    echo ""
    echo "========================================================="
    printf " LAPORAN DOSIS KAFEIN (BERAT BADAN: %s KG) \n" "$(fmt_num "$berat_badan")"
    echo "========================================================="

    echo ""
    echo "1. BATAS AMAN KONSUMSI (SAFE LIMIT)"
    printf "   Kadar Maksimal : %s mg / hari\n" "$(fmt_num "$batas_aman")"
    if awk -v k="$kafein_per_saji" 'BEGIN { exit !(k > 0) }'; then
        ekuivalensi=$(awk -v a="$batas_aman" -v k="$kafein_per_saji" 'BEGIN { printf "%.1f", a / k }')
        echo "   Setara Dengan  : $ekuivalensi $satuan $nama_minuman"
    fi

    echo ""
    echo "2. AMBANG BATAS OVERDOSIS (OVERDOSE THRESHOLD)"
    printf "   Kadar Bahaya   : %s mg dalam sekali minum\n" "$(fmt_num "$batas_overdosis")"
    if awk -v k="$kafein_per_saji" 'BEGIN { exit !(k > 0) }'; then
        ekuivalensi=$(awk -v a="$batas_overdosis" -v k="$kafein_per_saji" 'BEGIN { printf "%.1f", a / k }')
        echo "   Setara Dengan  : $ekuivalensi $satuan $nama_minuman"
    fi
    echo "   Efek Samping   : Jantung berdebar kencang, cemas parah, tangan gemetar, mual, dan muntah."

    echo ""
    echo "3. DOSIS RACUN FATAL (LETHAL DOSE)"
    printf "   Kadar Mematikan: %s mg\n" "$(fmt_num "$batas_lethal")"
    if awk -v k="$kafein_per_saji" 'BEGIN { exit !(k > 0) }'; then
        ekuivalensi=$(awk -v a="$batas_lethal" -v k="$kafein_per_saji" 'BEGIN { printf "%.1f", a / k }')
        echo "   Setara Dengan  : $ekuivalensi $satuan $nama_minuman"
    fi
    echo "   Efek Samping   : Risiko kejang parah, kerusakan irama jantung, hingga henti jantung (fatal)."

    echo ""
    cetak_garis
    echo "[Catatan] Angka di atas adalah estimasi umum berbasis mg/kg berat badan,"
    echo "BUKAN diagnosis medis. Toleransi kafein berbeda-beda tiap orang, dan"
    echo "angka ini bisa jauh lebih rendah untuk ibu hamil, anak-anak, lansia,"
    echo "atau orang dengan gangguan jantung. Konsultasikan ke tenaga medis"
    echo "untuk kondisi kesehatan spesifik."
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
        read -r menu_keluar

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
        read -r
    fi
done
