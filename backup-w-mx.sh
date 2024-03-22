#!/bin/bash
# MySQL bağlantı bilgileri
DB_USER=$1
DB_PASSWORD=$2

if [ -z "$DB_USER" ] || [ -z "$DB_PASSWORD" ]; then
    echo "WARNING: One or more parameters are empty."
    echo "Usage: $0 <DB_USER> <DB_PASSWORD>"
    exit 1
fi

# MySQL'de yeni bir veritabanı oluşturma
mysql -u root -p$DB_PASSWORD -e "CREATE DATABASE IF NOT EXISTS testdb;"

# Başarılı olup olmadığını kontrol et
if [ $? -gt 0 ]; then
    echo "mysql testdb database'i oluşturulamadı."
    exit 1
fi

# sysbench ile test veritabanını hazırlama
sysbench oltp_read_write --mysql-user=$DB_USER --mysql-password=$DB_PASSWORD --mysql-db=testdb --tables=10 --table-size=10000 prepare

# Başarılı olup olmadığını kontrol et
if [ $? -eq 0 ]; then
    # Başarı mesajını güncelle
    echo "sysbench ile test verisi oluşturuldu"
else
    echo "sysbench ile test verisi oluşturulamadı."
    exit 1
fi
# Yedekleme dizini ve dosya adı
BACKUP_DIR="/dockertest/mydb-backups/$(date +"%Y-%m-%d")"
mkdir -p $BACKUP_DIR
BACKUP_FILE=testdb_backup.sql.gz


# mysqldump komutu
mysqldump --user=$DB_USER --password=$DB_PASSWORD --databases testdb | gzip > $BACKUP_DIR/$BACKUP_FILE


# Başarılı olup olmadığını kontrol et
if [ $? -eq 0 ]; then
    # Başarı mesajını güncelle
    echo "mysqldump ile MySQL yedekleme başarıyla alındı: $BACKUP_DIR/$BACKUP_FILE"
else
    echo "mysqldump ile yedekleme sırasında bir hata oluştu."
    exit 1
fi

# xtrabackup için gerekli dizin kontrolü

mkdir -p "$BACKUP_DIR"

# xtrabackup komutu
xtrabackup --user=$DB_USER --password=$DB_PASSWORD --backup --compress --target-dir=$BACKUP_DIR

# Başarılı olup olmadığını kontrol et
if [ $? -eq 0 ]; then
    # qpress ile sıkıştırma
    echo "xtrabackup ile MySQL yedekleme başarıyla alındı ve sıkıştırıldı: $BACKUP_DIR.qp"
else
    echo "xtrabackup ile MySQL yedekleme sırasında bir hata oluştu."
    exit 1
fi
