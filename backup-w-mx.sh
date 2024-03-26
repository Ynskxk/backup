#!/bin/bash
# MySQL connection credentials
DB_USER=$1
DB_PASSWORD=$2

if [ -z "$DB_USER" ] || [ -z "$DB_PASSWORD" ]; then
    echo "UYARI: Bir veya daha fazla parametre boş."
    echo "Kullanım: $0 <DB_USER> <DB_PASSWORD>"
    exit 1
fi

# Creating a new database in MySQL
mysql -u root -p$DB_PASSWORD -e "CREATE DATABASE IF NOT EXISTS testdb;"

# Checking if successful
if [ $? -gt 0 ]; then
    echo "Failed to create mysql testdb database."
    exit 1
fi

# Prepare test database with sysbench
sysbench oltp_read_write --mysql-user=$DB_USER --mysql-password=$DB_PASSWORD --mysql-db=testdb --tables=10 --table-size=10000 prepare

# Checking if successful
if [ $? -eq 0 ]; then
    echo "Test data generated with sysbench successfully"
else
    echo "Failed to generate test data with sysbench."
    exit 1
fi

# Backup directory and file name
BACKUP_DIR="/dockertest/mydb-backups/$(date +"%Y-%m-%d")"
mkdir -p $BACKUP_DIR
BACKUP_FILE=testdb_backup.sql.gz

# mysqldump command
mysqldump --user=$DB_USER --password=$DB_PASSWORD --databases testdb | gzip > $BACKUP_DIR/$BACKUP_FILE

# Checking if successful
if [ $? -eq 0 ]; then
    echo "MySQL backup taken successfully with mysqldump: $BACKUP_DIR/$BACKUP_FILE"
else
    echo "An error occurred during mysqldump backup."
    exit 1
fi

# Checking necessary directory for xtrabackup
mkdir -p "$BACKUP_DIR"

# xtrabackup command
xtrabackup --user=$DB_USER --password=$DB_PASSWORD --backup --compress --target-dir=$BACKUP_DIR

# Checking if successful
if [ $? -eq 0 ]; then
    echo "MySQL backup taken successfully and compressed with xtrabackup: $BACKUP_DIR.qp"
else
    echo "An error occurred during MySQL backup with xtrabackup."
    exit 1
fi
