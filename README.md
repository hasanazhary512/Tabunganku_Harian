# Tabunganku_Harian - Mobile Testing Project

Dokumentasi ini disusun untuk memenuhi tugas mata kuliah **Mobile Testing**. Proyek ini berfokus pada pengembangan dan pengujian otomatis (*Automated End-to-End Testing*) pada aplikasi pencatatan keuangan harian berbasis Flutter dan Supabase menggunakan peranti pengujian **Maestro** serta dokumen pendukung **User Acceptance Testing (UAT)**.

---

## 📌 Tujuan Aplikasi
Aplikasi **Tabunganku_Harian** bertujuan untuk membantu pengguna dalam mengelola dan mencatat transaksi keuangan harian secara ringkas, akurat, dan transparan. Aplikasi ini dirancang untuk mencegah pencatatan manual yang rentan hilang serta memberikan kemudahan dalam merekap saldo dan mencetak laporan transaksi.

## 🎯 Target Pengguna
- **Pelajar & Mahasiswa:** Mengatur uang saku bulanan, dana darurat, dan pengeluaran harian.
- **Pekerja & Pengguna Umum:** Mengelola alokasi pemasukan harian/bulanan serta melacak riwayat pengeluaran secara terstruktur.

---

## 🚀 Fitur Utama
- **Autentikasi Pengguna:** Sistem masuk (*Login*) dan keluar (*Logout*) akun secara aman.
- **Dashboard Tabungan:** Menampilkan akumulasi total saldo secara *real-time* serta ringkasan riwayat transaksi.
- **Pencatatan Transaksi:** Pencatatan transaksi jenis **Setoran** (pemasukan) dan **Penarikan** (pengeluaran) lengkap dengan keterangan dan nominal.
- **Validasi Input Real-Time:** Penanganan skenario *error* ketika kolom input kosong atau tidak sesuai.
- **Preview & Cetak Laporan:** Visualisasi rekapitulasi transaksi dalam format dokumen PDF yang dapat dicetak atau disimpan melalui antarmuka pencetakan sistem Android.

---

## 🔄 Alur Pengguna (User Flow)

1. **Alur Autentikasi & Masuk Aplikasi:**
   Pengguna membuka aplikasi -> Menampilkan halaman Login -> Memasukkan *Username* & *Password* -> Menekan tombol **Masuk** -> Pengguna diarahkan ke **Dashboard Tabungan**.

2. **Alur Penambahan Transaksi (Setoran / Penarikan):**
   Pengguna berada di Dashboard -> Menekan tombol **+ Tambah** -> Memilih Jenis Transaksi (**Setoran** / **Penarikan**) -> Mengisi kolom **Keterangan** & **Nominal** -> Menekan tombol **Simpan Transaksi** -> Kembali ke Dashboard dengan saldo & riwayat yang diperbarui.

3. **Alur Cetak Laporan PDF:**
   Pengguna berada di Dashboard -> Menekan menu **Cetak Laporan** -> Tampilan dokumen PDF *preview* muncul -> Pengguna menekan ikon **Printer** di toolbar bawah -> Antarmuka cetak sistem Android (**Simpan sebagai PDF**) terbuka.

4. **Alur Keluar Akun (Logout):**
   Pengguna berada di Dashboard -> Menekan tombol/ikon **Logout** pada AppBar -> Sesi berakhir dan pengguna dikembalikan ke halaman Login.

---

## 🧪 Skenario Pengujian Otomatis (Maestro E2E Testing)

Pengujian dilakukan menggunakan pengujian fungsional otomatis berbasis skrip Maestro YAML di direktori `maestro/`:

1. **Membuka Aplikasi (`01_open_app.yaml`):** Memastikan aplikasi meluncur dengan sukses dan menampilkan layar utama login.
2. **Alur Login Pengguna (`02_login.yaml`):** Memastikan proses autentikasi berhasil hingga pengguna masuk ke Dashboard.
3. **Validasi Input (`03_validation_error.yaml`):** Menguji penanganan *error* saat pengguna mengosongkan input *username* atau *password*.
4. **Tambah Transaksi Setoran (`04_add_transaction.yaml`):** Memastikan alur pengisian formulir transaksi setoran dapat disimpan dan langsung memperbarui riwayat.
5. **Navigasi & Cetak Laporan (`05_navigation_report.yaml`):** Memastikan pratinjau dokumen laporan terbuka dan tombol cetak berhasil memicu *print spooler* sistem Android menggunakan penekanan koordinat relatif (`point`).
6. **Keluar Akun (`06_logout.yaml`):** Memastikan fungsi *logout* melalui tombol *tooltip* mengembalikan status aplikasi ke layar awal login.

---

## 🛠️ Batasan Pengujian
- **Fokus Pengujian:** Diarahkan pada alur utama (*happy path*) serta validasi form dasar UI menggunakan Maestro.
- **Target Platform:** Diuji pada emulator dan perangkat fisik Android dengan resolusi layar standar.
- **Lingkungan Pengujian:** Membutuhkan koneksi internet aktif dan stabil untuk sinkronisasi data dengan *database* Supabase.
- **Pencetakan PDF:** Pengujian modul cetak diverifikasi hingga pemanggilan antarmuka *Print Spooler* Android (`Simpan sebagai PDF`).

---

## 📱 Petunjuk Menjalankan Aplikasi & Pengujian

### 1. Menjalankan Aplikasi (Flutter)
1. Pastikan Flutter SDK telah terkonfigurasi.
2. Jalankan perintah untuk mengunduh seluruh *dependencies*:
   ```bash
   flutter pub get
   flutter run -d (nama device)