#!/bin/bash

# Variables
DB_NAME="mydb"                            # Replace with your database name
BACKUP_DIR="/tmp/mongodb_backups"         # Temporary directory for backups
TIMESTAMP=$(date +"%Y-%m-%d_%H-%M-%S")    # Timestamp for the backup file
BACKUP_FILE="$BACKUP_DIR/${DB_NAME}_backup_$TIMESTAMP.tar.gz"
R2_BUCKET="paddu"                         # Cloudflare R2 bucket name
R2_ENDPOINT="https://ee39b00ce77b46c6e6df5b0d3717b9bd.eu.r2.cloudflarestorage.com" # R2 endpoint

# Step 1: Create backup directory if it doesn't exist
mkdir -p "$BACKUP_DIR"

# Step 2: Dump the MongoDB database
mongodump --db "$DB_NAME" --out "$BACKUP_DIR/$DB_NAME"

# Step 3: Compress the backup into a tarball
tar -czf "$BACKUP_FILE" -C "$BACKUP_DIR" "$DB_NAME"

# Step 4: Clean up uncompressed dump
rm -rf "$BACKUP_DIR/$DB_NAME"

# Step 5: Upload the backup to Cloudflare R2
aws s3 cp "$BACKUP_FILE" s3://$R2_BUCKET --endpoint-url="$R2_ENDPOINT"

# Step 6: Remove the local backup file
rm -f "$BACKUP_FILE"

echo "Backup and upload completed successfully at $TIMESTAMP"

#section for the health monitor
curl -fsS --retry 3 https://hc-ping.com/f265e9aa-2b27-4421-9f05-0093f1f2b3e5 > /dev/null


#logic to delete the old backup

aws s3 ls s3://$R2_BUCKET --endpoint-url=$R2_ENDPOINT | sort | head -n -7 | awk '{print $4}' | while re>
    aws s3 rm s3://$R2_BUCKET/$old_file --endpoint-url=$R2_ENDPOINT
done
