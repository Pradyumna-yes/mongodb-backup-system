#!/bin/bash

DB_NAME="mydb"
BACKUP_DIR="/tmp/mongodb_backups"
TIMESTAMP=$(date +"%Y-%m-%d_%H-%M-%S")
BACKUP_FILE="$BACKUP_DIR/${DB_NAME}_backup_$TIMESTAMP.tar.gz"
R2_BUCKET="paddu"
R2_ENDPOINT="https://ee39b00ce77b46c6e6df5b0d3717b9bd.eu.r2.cloudflarestorage.com"

# Ensure the backup directory exists
mkdir -p "$BACKUP_DIR"

# Step 1: Dump MongoDB database
mongodump --db "$DB_NAME" --out "$BACKUP_DIR/$DB_NAME"
if [ $? -ne 0 ]; then
    echo "MongoDB dump failed!"
    exit 1
fi

# Step 2: Compress the backup
tar -czf "$BACKUP_FILE" -C "$BACKUP_DIR" "$DB_NAME"
if [ $? -ne 0 ]; then
    echo "Failed to compress backup!"
    exit 1
fi

# Clean up uncompressed files
rm -rf "$BACKUP_DIR/$DB_NAME"

# Step 3: Upload backup to Cloudflare R2
aws s3 cp "$BACKUP_FILE" s3://$R2_BUCKET --endpoint-url="$R2_ENDPOINT"
if [ $? -ne 0 ]; then
    echo "Failed to upload backup to Cloudflare R2!"
    exit 1
fi

# Step 4: Delete old backups (keep the latest 7 backups)
aws s3 ls s3://$R2_BUCKET --endpoint-url="$R2_ENDPOINT" | sort | head -n -7 | awk '{print $4}' | while read -r old_file; do
    aws s3 rm s3://$R2_BUCKET/$old_file --endpoint-url="$R2_ENDPOINT"
done

echo "Backup and upload completed successfully at $TIMESTAMP"
