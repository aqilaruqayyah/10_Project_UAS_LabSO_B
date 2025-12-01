## Project UAS PRAKTIKUM SO | Kelompok 10

Anggota:
Aqila Ruqayyah - 2408107010070
Syifa Salsabila - 2408107010018
Ihda Nisa Mei Drika - 2408107010051

### tujuan Project
Project ini dibuat untuk melengkapi UAS Praktikum SO Kelas B 2025

### Mekanisme Script
Script ini dibuat dalam format Shell Script. Script ini akan mengambil data dari sebuah folder yang telah di input oleh pengguna, dan membuat sebuah backup folder yang akan disimpan dalam folder destinasi.

### Penjelasan Script
1. Input
Script ini akan mengambil 3 input dari pengguna menggunakan syntax "read", yaitu:
  Source Folder (folder yang akan dipindah)
  Destination Folder (folder tujuan)
  Lama penyimpanan (Dalam hari)

2. Validasi
Program akan mengecek validasi dari data yang dimasukkan pengguna, diantaranya:
  Retensi penyimpanan => Jika pengguna menginput x < 1, maka program akan mencetak error message, jika berhasil, maka kode akan lanjut.
  Source File => Jika source file tidak ditemukan dalam sistem, maka akan mencetak error message, jika berhasil ditemukan, maka kode lanjut.
  Destination File => Jika folder berhasil ditemukan, maka log akan disimpan dalam Folder tersebut, jika file tidak ditemukan, maka program akan otomatis membuat folder baru dengan nama yang di input pengguna.

3. Proses Backup
Proses backup akan dilakukan setelah tahap validasi data.
  Program akan menyimpan file dengan nama "backup-[timestamp].tar.gz" dan diletakkan dalam destination folder.
  Program akan menyimpan waktu mulai backup

4. Make Archive
Membuat file log untuk menyimpan proses backup yang dilakukan oleh program.
  Jika backup berhasil, maka akan dicetak nama file backup, waktu mulai backup, ukuran folder, dan lokasi file tersimpan dimana. Program juga akan mencetak hari retensi bakup folder yang tersimpan dalam terminal.
  Jika backup gagal, maka akan dicetak error dalam terminal dan juga akan disimpan error message di file log.

5. Rotasi
Jika folder bakup sudah melewati retensi hari yang telah ditetapkan, maka program akan mencari file tersebut untuk dihapus.

6. Fungsi tambahan
Telah dibuat fungsi tambahan dalam program untuk membantu kami dalam menulis kode:
  trim => Menghapus spasi di awal/akhir string (seperti trim() di bahasa lain).
  clean_input() => Menghapus karakter carriage return (\r) yang biasa muncul dari input Windows.
  expand_tilde => Mengubah ~ atau ~/folder menjadi path lengkap (Contoh: ~/data menjadi /home/user/data)
  write_log() => Menulis log ke file backup.log di folder parent dari folder tujuan dalam format: timestamp | message.
  error_exit() => Jika terjadi error:
    Tulis log error.
    Tampilkan pesan ke user (stderr).
    Keluar dari script.
