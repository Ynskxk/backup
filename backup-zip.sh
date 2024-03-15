#!/bin/bash
#set -x
# MySQL bağlantı bilgileri
DB_USER=$1
DB_PASSWORD=$2

if [ -z "$DB_USER" ] || [ -z "$DB_PASSWORD" ]; then
    echo "WARNING: One or more parameters are empty."
    echo "Usage: $0 <DB_USER> <DB_PASSWORD>"
    exit 1
fi

# Yedekleme dizini ve dosya adı
BACKUP_DIR="/dockertest/mydb-backups"
mkdir -p $BACKUP_DIR
DATE=$(date +"%Y-%m-%d")
COMPRESSED_FILE="$BACKUP_DIR/mysql_backup_$DATE.gz"

# MySQL yedekleme komutu
mysqldump -u$DB_USER -p$DB_PASSWORD --all-databases | gzip > $COMPRESSED_FILE
# Başarılı olup olmadığını kontrol et
if [ $? -eq 0 ]; then
    echo "MySQL yedekleme başarıyla alındı: $COMPRESSED_FILE"
else
    echo "MySQL yedekleme sırasında bir hata oluştu."
    exit 1
fi

