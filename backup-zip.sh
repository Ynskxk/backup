#!/bin/bash
#set -x
# MySQL bağlantı bilgileri
DB_USER=$1
DB_PASSWORD=$2

# Yedekleme dizini ve dosya adı
BACKUP_DIR="/dockertest/mydb-backups"
DATE=$(date +"%Y-%m-%d")
COMPRESSED_FILE="$BACKUP_DIR/mysql_backup_$DATE.gz"

# MySQL yedekleme komutu
mysqldump -u$DB_USER -p$DB_PASSWORD --all-databases | gzip > $COMPRESSED_FILE
# Başarılı olup olmadığını kontrol et
if [ $? -eq 0 ]; then
    echo "MySQL yedekleme başarıyla alındı: $COMPRESSED_FILE"
else
    echo "MySQL yedekleme sırasında bir hata oluştu."
fi

