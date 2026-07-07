## Kalkulator-Dosis-Kafein

Program sederhana untuk menghitung **batas aman**, **ambang batas overdosis**, dan **dosis fatal (lethal dose)** kafein berdasarkan berat badan pengguna. Tersedia dalam dua versi: **Bash** dan **Python**.

> Dibuat oleh:
> Nama   : [Ilham Aditya Pratama]
> NIM    : [25.11.6407]
> Tugas Final Project Bash-Python

## 📋 Deskripsi

Program ini menghitung 3 ambang batas konsumsi kafein harian berdasarkan berat badan (kg):

| Kategori | Rumus | Keterangan |
|---|---|---|
| Batas Aman | `berat_badan x 4` (maks. 400 mg) | Batas konsumsi harian yang direkomendasikan |
| Ambang Overdosis | `berat_badan x 15` | Kadar yang mulai berbahaya dalam sekali minum |
| Dosis Fatal | `berat_badan x 150` | Perkiraan dosis yang berpotensi mematikan |

Perhitungan ini bersifat **edukatif** (perkiraan referensi umum), bukan pengganti nasihat medis profesional.

Program juga bisa mengonversi angka mg tersebut menjadi perkiraan jumlah minuman (kopi hitam, kopi instan, minuman energi, atau teh/soda) berdasarkan database kafein per sajian.

## ⚙️ Fitur

- Input berat badan dengan validasi (harus angka bulat positif)
- Pilihan database jenis minuman berkafein (opsional, bisa dilewati)
- Sistem retry otomatis (maksimal 3x percobaan) untuk input yang salah
- Laporan lengkap: batas aman, ambang overdosis, dan dosis fatal beserta efek sampingnya
- Menu ulangi perhitungan atau keluar program
- Tidak membutuhkan dependensi/paket eksternal tambahan (native)

## 🖥️ Kebutuhan Sistem

- Ubuntu 22.04 (atau distro Linux lain dengan bash)
- Untuk versi Python: Python 3 (sudah terpasang secara default di sebagian besar Ubuntu)
- Tidak ada library/paket tambahan yang perlu diinstal

## ▶️ Cara Menjalankan

### Versi Bash

```bash
chmod +x Kalkulator_Overdosis_Kafein.sh
./Kalkulator_Overdosis_Kafein.sh
```

atau

```bash
bash Kalkulator_Overdosis_Kafein.sh
```

### Versi Python

```bash
python3 Kalkulator_Overdosis_Kafein.py
```

## 📁 Struktur File

```
.
├── Kalkulator_Overdosis_Kafein.sh   # Versi Bash
├── Kalkulator_Overdosis_Kafein.py   # Versi Python
└── README.md                        # Dokumentasi ini
```

## 📌 Contoh Penggunaan

```
Masukkan berat badan Anda (kg): 60

[ PILIHAN DATABASE MINUMAN ]
ID   | Jenis Minuman                    | Perkiraan Kafein
---------------------------------------------------------
1    | Kopi Hitam / Brewed Coffee       | 100 mg/cangkir
...
Pilih ID minuman (1-4) atau Tekan Enter untuk Lewati: 1

LAPORAN DOSIS KAFEIN (BERAT BADAN: 60 KG)
1. BATAS AMAN KONSUMSI (SAFE LIMIT)
   Kadar Maksimal : 240 mg / hari
   Setara Dengan  : 2.4 cangkir Kopi Hitam
...
```

## ⚠️ Disclaimer

Program ini dibuat untuk tujuan **edukasi/pembelajaran** dalam mata kuliah pemrograman. Angka-angka yang digunakan adalah perkiraan umum dan **tidak boleh dijadikan acuan medis**. Konsultasikan ke tenaga medis profesional untuk keputusan terkait kesehatan.
