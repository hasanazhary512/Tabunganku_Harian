# Laporan User Acceptance Testing (UAT)

**Aplikasi:** Tabunganku_Harian (Flutter & Supabase)  
**Penguji:** Hasan Azhary  
**Tanggal Pengujian:** 6 November 2026  
**Status Pengujian:** LULUS SEPENUHNYA (100% PASS)  

---

## 1. Peran & Persona Pengguna
- **Pengguna Utama:** Mahasiswa / Pekerja / Pengguna Umum yang membutuhkan sistem pencatatan keuangan harian (setoran & penarikan) berbasis *mobile* secara akurat, transparan, dan terintegrasi dengan modul laporan PDF.

---

## 2. Kriteria Penerimaan (Acceptance Criteria)
1. **Autentikasi:** Pengguna dapat melakukan *login* dengan *username* dan *password* yang terdaftar, serta *logout* dari aplikasi secara aman.
2. **Dashboard & Ringkasan:** Pengguna dapat melihat akumulasi total saldo secara *real-time* dan daftar riwayat transaksi.
3. **Pencatatan Transaksi:** Pengguna dapat menambahkan transaksi baru jenis **Setoran** (pemasukan) maupun **Penarikan** (pengeluaran).
4. **Validasi Input Real-Time:** Sistem mampu menangani dan menampilkan *SnackBar* peringatan apabila input kredensial atau transaksi kosong/invalid.
5. **Preview & Cetak Laporan:** Pengguna dapat mengakses pratinjau laporan rekapitulasi transaksi dalam bentuk PDF dan membuka modul pencetakan sistem Android (*Print Spooler*).

---

## 3. Matriks Skenario Pengujian UAT & Otomasi (Maestro)

| ID UAT | Nama Skenario Pengujian | File Maestro YAML | Hasil yang Diharapkan | Status |
| :--- | :--- | :--- | :--- | :---: |
| **UAT-01** | Peluncuran & Tampilan Layar Login | `01_open_app.yaml` | Aplikasi berhasil dibuka dan menampilkan form *Login* utama ("Masuk"). | **LULUS** |
| **UAT-02** | Alur Login Pengguna (*Happy Path*) | `02_login.yaml` | Mengisi *username* & *password* dengan benar, mengarahkan pengguna ke *Dashboard Tabungan*. | **LULUS** |
| **UAT-03** | Validasi Error Input Login/Form | `03_validation_error.yaml` | Menampilkan *SnackBar* peringatan *"Username dan Password wajib diisi!"* ketika input kosong. | **LULUS** |
| **UAT-04** | Menambah Transaksi Setoran | `04_add_transaction.yaml` | Menambah transaksi "Setoran" (`Uang Saku Bulanan` - `5000`), saldo bertambah dan tercatat di riwayat. | **LULUS** |
| **UAT-05** | Navigasi & Cetak Laporan PDF | `05_navigation_report.yaml` | Membuka pratinjau PDF, menekan ikon printer via koordinat relatif (`9%,92%`), dan memicu modal *Simpan sebagai PDF*. | **LULUS** |
| **UAT-06** | Logout Pengguna | `06_logout.yaml` | Menekan ikon *Logout* via *tooltip* pada AppBar dan berhasil kembali ke layar *Login*. | **LULUS** |

---

## 4. Detail Skenario Pengujian UAT

### Skenario UAT-01: Membuka Aplikasi & Layar Login
- **Prasyarat:** Aplikasi terpasang pada emulator atau perangkat fisik Android.
- **Langkah Pengujian:**
  1. Jalankan aplikasi `com.example.tabunganku_harian`.
  2. Amati tampilan layar awal.
- **Hasil yang Diharapkan:** Aplikasi menampilkan tombol dan formulir *Login* ("Masuk").
- **Status:** **LULUS (PASS)**

---

### Skenario UAT-02: Alur Login Pengguna (Happy Path)
- **Prasyarat:** Berada di layar *Login*.
- **Langkah Pengujian:**
  1. Isi *Username*: `user_test`.
  2. Isi *Password*: `password123`.
  3. Sembunyikan keyboard, lalu tekan tombol **Masuk**.
- **Hasil yang Diharapkan:** Aplikasi berhasil mengautentikasi pengguna dan mengarahkan ke halaman **Dashboard Tabungan**.
- **Status:** **LULUS (PASS)**

---

### Skenario UAT-03: Validasi Form Input Login (Kondisi Gagal)
- **Prasyarat:** Berada di layar *Login*.
- **Langkah Pengujian:**
  1. Biarkan kolom *Username* dan *Password* kosong.
  2. Tekan tombol **Masuk**.
- **Hasil yang Diharapkan:** Aplikasi menampilkan *SnackBar* bertuliskan *"Username dan Password wajib diisi!"*. Data tidak diproses ke database.
- **Status:** **LULUS (PASS)**

---

### Skenario UAT-04: Menambah Transaksi Setoran
- **Prasyarat:** Berada di halaman Dashboard Tabungan.
- **Langkah Pengujian:**
  1. Tekan tombol **+ Tambah**.
  2. Pilih jenis transaksi **Setoran**.
  3. Isi Keterangan: `Uang Saku Bulanan`.
  4. Isi Nominal: `5000`.
  5. Sembunyikan keyboard, lalu tekan tombol **Simpan Transaksi**.
- **Hasil yang Diharapkan:** Formulir tertutup, kembali ke Dashboard, item `Uang Saku Bulanan` tercatat pada riwayat, dan akumulasi total saldo bertambah Rp 5.000.
- **Status:** **LULUS (PASS)**

---

### Skenario UAT-05: Navigasi & Cetak Laporan PDF
- **Prasyarat:** Berada di halaman Dashboard Tabungan.
- **Langkah Pengujian:**
  1. Tekan tombol **Cetak Laporan** dari menu Dashboard.
  2. Verifikasi dokumen pratinjau laporan keuangan terbuka.
  3. Tekan ikon printer di pojok kiri bawah *toolbar* PDF *viewer* (menggunakan koordinat `point: "9%,92%"`).
- **Hasil yang Diharapkan:** Antarmuka *Print Spooler* bawaan Android terbuka dengan opsi **Simpan sebagai PDF**.
- **Status:** **LULUS (PASS)**

---

### Skenario UAT-06: Keluar Akun (Logout)
- **Prasyarat:** Berada di halaman Dashboard Tabungan.
- **Langkah Pengujian:**
  1. Tekan ikon **Logout** pada AppBar (diidentifikasi via *tooltip* `"Logout"`).
- **Hasil yang Diharapkan:** Sesi pengguna dibatalkan dan antarmuka aplikasi secara otomatis kembali ke layar utama **Login**.
- **Status:** **LULUS (PASS)**

---

## 5. Ringkasan Temuan & Bukti Pengujian (Test Evidence)

- **Eksekusi Pengujian Otomatis (Maestro CLI):**
  Seluruh skrip E2E testing yang berada dalam folder `maestro/` (`01_open_app.yaml` hingga `06_logout.yaml`) telah dijalankan secara sekuensial dan memperoleh status **GREEN / PASSED**.
- **Penanganan Aksesibilitas Toolbar PDF:**
  Ikon printer pada modul pembaca PDF tidak mengekspos ID elemen Android bawaan secara langsung. Masalah ini berhasil diatasi pada skrip otomatisasi menggunakan mekanisme penekanan koordinat presisi (`point: "9%,92%"`).
- **Integritas Data Supabase:**
  Penambahan transaksi dan sinkronisasi status login/logout secara *real-time* berkomunikasi dengan baik bersama *backend* Supabase tanpa memicu penundaan (*lag*) atau kebocoran memori pada aplikasi.
- **Kesimpulan:**
  Aplikasi **Tabunganku_Harian** dinyatakan **Layak Rilis (Ready for Production/Deployment)** untuk memenuhi kebutuhan pengujian fungsional dan kriteria penerimaan pengguna (UAT).