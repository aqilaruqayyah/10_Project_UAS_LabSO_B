#!/bin/bash
# main.sh - Sistem Backup Otomatis dengan Log & Rotasi

# fungsi tambahan
trim() {
	echo "$1" | awk '{$1=$1;print}'
}

clean_input() {
	echo "$1" | tr -d '\r'
}

expand_tilde() { # konversi ~ ke direktori home pengguna secara aman
	case "$1" in
	"~" | "~/"*) printf "%s\n" "${1/#\~/$HOME}"  ;;
	*) printf "%s\n" "$1" ;;
	esac
}

write_log() {
	local message="$1"
	# Log di parent folder (Auto-Backup/)
	LOG_FOLDER="$(dirname "$DEST_FOLDER")"
	mkdir -p "$LOG_FOLDER"
	printf "%s | %s\n" "$(date '+%Y-%m-%d %H:%M:%S')" "$message" >> "$LOG_FOLDER/backup.log"
}

error_exit() {
	local msg="$1"
	# log ke parent folder juga
	LOG_FOLDER="$(dirname "$DEST_FOLDER")"
	printf "%s | ERROR: %s\n" "$(date '+%Y-%m-%d %H:%M:%S')" "$msg" >> "$LOG_FOLDER/backup.log"
	echo "$msg" >&2
	exit 1
}

# ------ Mulai Program ------
# memastikan script dijalankan oleh bash (lihat #!/bin/bash di atas) 
# dan tidak ada karakter carriage return yang tersisa
# (jika file dibuat di Windows, bersihkan dengan perintah: sed -i 's/\r$//' main.sh)

echo "============================="
echo "    Sistem Backup Otomatis   "
echo "============================="

# input dari pengguna (pakai -r agar backslash tidak di-escape)
printf "Masukkan folder sumber: "
read -r SOURCE_FOLDER_IN
SOURCE_FOLDER_IN=$(trim "$SOURCE_FOLDER_IN")
SOURCE_FOLDER=$(expand_tilde "$SOURCE_FOLDER_IN")

printf "Masukkan folder tujuan backup: "
read -r DEST_FOLDER_IN
DEST_FOLDER_IN=$(echo "$DEST_FOLDER_IN" | tr -d '\r')
DEST_FOLDER=$(expand_tilde "$DEST_FOLDER_IN")

printf "Masukkan lama penyimpanan backup (hari): "
read -r RETENTION_DAYS_IN
RETENTION_DAYS_IN=$(trim " $RETENTION_DAYS_IN")


# pastikan retention days berupa bilangan bulat lebih dari nol
if ! echo "$RETENTION_DAYS_IN" | grep -qE '^[0-9]+$'; then
	echo "Lama penyimpanan backup harus angka bulat >= 0. Default dipakai 7 hari."
	RETENTION_DAYS=7
else
	RETENTION_DAYS="$RETENTION_DAYS_IN"
fi

# Validasi apakah folder sumber ada
if [ ! -d "$SOURCE_FOLDER" ]; then
	error_exit "Folder sumber '$SOURCE_FOLDER' tidak ditemukan."
fi
# Buat folder tujuan jika belum ada
if [ ! -d "$DEST_FOLDER" ]; then
	echo "Folder tujuan tidak ada - akan dibuat: $DEST_FOLDER"
	if ! mkdir -p "$DEST_FOLDER"; then
		error_exit "Gagal membuat folder tujuan: $DEST_FOLDER"
	fi
fi


# Siapkan format nama file untuk backup
TIMESTAMP=$(date '+%Y%m%d - %H%M%S')
BACKUP_FILE="backup-$TIMESTAMP.tar.gz"
BACKUP_PATH="$DEST_FOLDER/$BACKUP_FILE"

# SIMPAN WAKTU MULAI 
START_TIME=$(date '+%Y-%m-%d %H:%M:%S')
# Start log
write_log "Backup started: $SOURCE_FOLDER"


# Buat arsip terkompresi
# Gunakan tar + gzip, jaga permission file, ikuti symbolic links
if tar -czf "$BACKUP_PATH" -C "$(dirname "$SOURCE_FOLDER")" "$(basename "$SOURCE_FOLDER")" 2>/tmp/backup_tar_err.log;  then
	SIZE=$(du -h "$BACKUP_PATH" | cut -f1)
	write_log "Backup finished: $BACKUP_FILE"
	write_log "Size: $SIZE | Status: SUCCESS"
	echo "Folder sumber: $SOURCE_FOLDER"
	echo "Folder tujuan: $DEST_FOLDER"
	echo "Backup dimulai: $START_TIME"
	echo "Backup selesai: $BACKUP_FILE"
	echo "Ukuran backup: $SIZE"
	echo "Backup tersimpan di $DEST_FOLDER"

	# Tambahkan pesan rotasi di terminal
	if [ "$RETENTION_DAYS" -gt 0 ] 2>/dev/null; then
		echo "Backup lebih dari $RETENTION_DAYS hari dihapus (rotasi backup)"
	fi

else
	#menangkap tar error
	TARRER="$(cat /tmp/backup_tar_err.log)"
	write_log "Status: FAILED | tar error: $TARERR"
	rm -f "$BACKUP_PATH" >/dev/null 2>&1
	error_exit "Backup gagal. Lihat log: $(dirname "$DEST_FOLDER")/backup.log"
fi
rm -f /tmp/backup_tar_err.log

# Rotasi: hapus backup yang sudah lebih lama dari retention days
if [ "$RETENTION_DAYS" -gt 0 ] 2>/dev/null; then
	find "$DEST_FOLDER" -maxdepth 1 -type f -name "backup-*.tar.gz" -mtime "+$RETENTION_DAYS" -delete >/dev/null 2>&1
fi

echo "Proses backup telah berhasil dilakukan!"
exit 0
