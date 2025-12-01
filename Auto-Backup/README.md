## Project UAS PRAKTIKUM SO | Kelompok 10

Anggota:<br/>
Aqila Ruqayyah - 2408107010070<br/>
Syifa Salsabila - 2408107010018<br/>
Ihda Nisa Mei Drika - 2408107010051

### tujuan Project
Project ini dibuat untuk melengkapi UAS Praktikum SO Kelas B 2025

### Mekanisme Script
Script ini dibuat dalam format Shell Script. Script ini akan mengambil data dari sebuah folder yang telah di input oleh pengguna, dan membuat sebuah backup folder yang akan disimpan dalam folder destinasi.

### Penjelasan Script
1. Input<br/>
Script ini akan mengambil 3 input dari pengguna menggunakan syntax "read", yaitu:<br/>
  Source Folder (folder yang akan dipindah)<br/>
  Destination Folder (folder tujuan)<br/>
  Lama penyimpanan (Dalam hari)

2. Validasi<br/>
Program akan mengecek validasi dari data yang dimasukkan pengguna, diantaranya:<br/>
  Retensi penyimpanan => Jika pengguna menginput x < 1, maka program akan mencetak error message, jika berhasil, maka kode akan lanjut.<br/>
  Source File => Jika source file tidak ditemukan dalam sistem, maka akan mencetak error message, jika berhasil ditemukan, maka kode lanjut.<br/>
  Destination File => Jika folder berhasil ditemukan, maka log akan disimpan dalam Folder tersebut, jika file tidak ditemukan, maka program akan otomatis membuat folder baru dengan nama yang di input pengguna.

3. Proses Backup<br/>
Proses backup akan dilakukan setelah tahap validasi data.<br/>
  Program akan menyimpan file dengan nama "backup-(timestamp).tar.gz" dan diletakkan dalam destination folder.<br/>
  Program akan menyimpan waktu mulai backup<br/>

4. Make Archive<br/>
Membuat file log untuk menyimpan proses backup yang dilakukan oleh program.<br/>
  Jika backup berhasil, maka akan dicetak nama file backup, waktu mulai backup, ukuran folder, dan lokasi file tersimpan dimana. Program juga akan mencetak hari retensi bakup folder yang tersimpan dalam terminal.<br/>
  Jika backup gagal, maka akan dicetak error dalam terminal dan juga akan disimpan error message di file log.<br/>

5. Rotasi<br/>
Jika folder bakup sudah melewati retensi hari yang telah ditetapkan, maka program akan mencari file tersebut untuk dihapus.<br/>

6. Fungsi tambahan<br/>
Telah dibuat fungsi tambahan dalam program untuk membantu kami dalam menulis kode:<br/>
  trim => Menghapus spasi di awal/akhir string (seperti trim() di bahasa lain).<br/>
  clean_input() => Menghapus karakter carriage return (\r) yang biasa muncul dari input Windows.<br/>
  expand_tilde => Mengubah ~ atau ~/folder menjadi path lengkap (Contoh: ~/data menjadi /home/user/data)<br/>
  write_log() => Menulis log ke file backup.log di folder parent dari folder tujuan dalam format: timestamp | message.<br/>
  error_exit() => Jika terjadi error:<br/>
    Tulis log error.<br/>
    Tampilkan pesan ke user (stderr).<br/>
    Keluar dari script.<br/>
