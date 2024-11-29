# Variables
DB_NAME="mydb"                              # Name of the database to restore
BACKUP_DIR="/tmp/mongodb_restore"           # Temporary directory for restoring
R2_BUCKET="paddu"                           # Cloudflare R2 bucket name
R2_ENDPOINT="https://ee39b00ce77b46c6e6df5b0d3717b9bd.eu.r2.cloudflarestorage.com" # Cloudflare R2 endp>
LATEST_BACKUP_FILE=""                       # Placeholder for the latest backup file

# Step 1: Fetch the latest backup file name from Cloudflare R2
echo "Fetching the latest backup file from Cloudflare R2..."
LATEST_BACKUP_FILE=$(aws s3 ls s3://$R2_BUCKET --endpoint-url="$R2_ENDPOINT" | sort | tail -n 1 | awk '>
if [ -z "$LATEST_BACKUP_FILE" ]; then
    echo "Error: No backup files found in the bucket!"
    exit 1
fi
echo "Latest backup file: $LATEST_BACKUP_FILE"

# Step 2: Download the latest backup file
echo "Downloading the latest backup file: $LATEST_BACKUP_FILE"
aws s3 cp s3://$R2_BUCKET/$LATEST_BACKUP_FILE /tmp/ --endpoint-url="$R2_ENDPOINT"
if [ $? -ne 0 ]; then
    echo "Error: Failed to download the backup file from Cloudflare R2!"
    exit 1
fi

# Step 3: Create the restore directory if it doesn't exist
echo "Creating restore directory: $BACKUP_DIR"
mkdir -p "$BACKUP_DIR"

# Step 4: Extract the backup file
echo "Extracting the backup file: $LATEST_BACKUP_FILE"
tar -xzf /tmp/$LATEST_BACKUP_FILE -C $BACKUP_DIR
if [ $? -ne 0 ]; then
    echo "Error: Failed to extract the backup file!"
    exit 1
fi

# Step 5: Restore the database using mongorestore
echo "Restoring the database: $DB_NAME"
mongorestore --drop --db "$DB_NAME" "$BACKUP_DIR/$DB_NAME"
if [ $? -ne 0 ]; then
    echo "Error: Database restore failed!"
    exit 1
fi

# Step 6: Cleanup
echo "Cleaning up temporary files..."
rm -f /tmp/$LATEST_BACKUP_FILE
rm -rf $BACKUP_DIR

echo "Database restore completed successfully!"

