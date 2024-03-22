#!/bin/bash
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
BACKUP_DIR="$BACKUP_DIR/$DATE"

# xtrabackup için gerekli dizin kontrolü
if [ ! -d "$BACKUP_DIR" ]; then
    mkdir -p "$BACKUP_DIR"
else
    rm -rf "$BACKUP_DIR"/*
fi

# xtrabackup komutu
xtrabackup --user=$DB_USER --password=$DB_PASSWORD --backup --target-dir=$BACKUP_DIR

# Başarılı olup olmadığını kontrol et
if [ $? -eq 0 ]; then
    # qpress ile sıkıştırma
    qpress -v $BACKUP_DIR $BACKUP_DIR.qp
    rm -rf $BACKUP_DIR
    echo "MySQL yedekleme başarıyla alındı ve sıkıştırıldı: $BACKUP_DIR.qp"
else
    echo "MySQL yedekleme sırasında bir hata oluştu."
    exit 1
fi
