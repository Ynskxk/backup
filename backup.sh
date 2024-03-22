#!/bin/bash

# Check if a database name was provided
if [ -z "$1" ]; then
    echo "No database name provided. Usage: $0 <database_name>"
    exit 1
fi

# Set the database name
database_name=$1

# Create a backup file name with the current date and time
backup_file="backup_${database_name}_$(date +%Y-%m-%d_%H-%M-%S).sql"

# Create the backup
mysqldump -uroot -psecret $database_name > $backup_file

# Check if the backup was successful
if [ $? -ne 0 ]; then
    echo "Backup of $database_name failed"
    exit 1
fi

echo "Backup of $database_name successful, file name: $backup_file"