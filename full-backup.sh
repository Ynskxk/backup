#!/bin/bash

# MySQL bağlantı bilgileri
DB_USER="root"
DB_PASSWORD="my-secret=pw"

# Yedekleme dizini ve dosya adı
BACKUP_DIR="/dockertest/mydb-backups"
DATE=$(date +"%Y-%m-%d")
BACKUP_FILE="$BACKUP_DIR/mysql_backup_$DATE.sql"

# MySQL yedekleme komutu
mysqldump -u$DB_USER -p$DB_PASSWORD --all-databases > $BACKUP_FILE

# Başarılı olup olmadığını kontrol et
if [ $? -eq 0 ]; then
    echo "MySQL yedekleme başarıyla alındı: $BACKUP_FILE"
else
    echo "MySQL yedekleme sırasında bir hata oluştu."
    exit 1
fi
