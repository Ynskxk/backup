#!/bin/bash
# MySQL connection information
DB_USER=$1
DB_PASSWORD=$2

if [ -z "$DB_USER" ] || [ -z "$DB_PASSWORD" ]; then
    echo "WARNING: One or more parameters are empty."
    echo "Usage: $0 <DB_USER> <DB_PASSWORD>"
    exit 1
fi

# Backup directory and file name
BACKUP_DIR="/dockertest/mydb-backups"
mkdir -p $BACKUP_DIR
DATE=$(date +"%Y-%m-%d")
COMPRESSED_FILE="$BACKUP_DIR/mysql_backup_$DATE.gz"

# MySQL backup command
mysqldump -u$DB_USER -p$DB_PASSWORD --all-databases | gzip > $COMPRESSED_FILE
# Check if the backup was successful
if [ $? -eq 0 ]; then
    echo "MySQL backup was successfully created: $COMPRESSED_FILE"
else
    echo "An error occurred during MySQL backup."
    exit 1
fi
