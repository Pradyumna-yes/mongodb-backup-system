#!/bin/bash

# Variables
R2_BUCKET="paddu"  # Your Cloudflare R2 bucket name
R2_ENDPOINT="https://ee39b00ce77b46c6e6df5b0d3717b9bd.eu.r2.cloudflarestorage.com"
RESTORE_DIR="/tmp/mongodb_restore"
LATEST_BACKUP=$(aws s3 ls s3://$R2_BUCKET --endpoint-url=$R2_ENDPOINT | sort | tail -n 1 | awk '{print $4}')

# Step 1: Download the latest backup
mkdir -p "$RESTORE_DIR"
aws s3 cp s3://$R2_BUCKET/$LATEST_BACKUP "$RESTORE_DIR/" --endpoint-url="$R2_ENDPOINT"

# Step 2: Extract the backup
tar -xzf "$RESTORE_DIR/$LATEST_BACKUP" -C "$RESTORE_DIR"

# Step 3: Restore the database
mongorestore --dir="$RESTORE_DIR/mydb"

# Step 4: Clean up
rm -rf "$RESTORE_DIR"

echo "Database restore completed successfully from $LATEST_BACKUP"
