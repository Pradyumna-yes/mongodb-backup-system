# Automated Database Backups with Jenkins

This project provides a simple and automated solution for database backups using **Jenkins**, **Bash scripts**, and **AWS S3 (or compatible object storage)**. It ensures reliable backups and restores, making it easy for any user to manage their database data securely.

---

## Features

- Automated database backups triggered on a schedule or manually.
- Secure storage of backups in AWS S3 or compatible object storage.
- Easy restore functionality for quick disaster recovery.
- Fully configurable pipeline with support for custom settings.

---

## Table of Contents

- [Prerequisites](#prerequisites)
- [Project Structure](#project-structure)
- [Setup and Configuration](#setup-and-configuration)
- [Usage](#usage)
  - [Run Backups](#run-backups)
  - [Restore Database](#restore-database)
- [Manual Testing](#manual-testing)
- [Contributing](#contributing)
- [License](#license)

---

## Prerequisites

Before using this project, ensure you have the following installed and configured:

1. **Jenkins** installed on your server or local machine.
2. **AWS CLI** (version 2+) installed and configured with:
   - Access keys with permissions to your S3 bucket.
3. **Database Access**:
   - User credentials to access the database you want to back up.
4. **Bash** scripting support (Linux/Mac or Windows with WSL).

---

## Project Structure

```plaintext
Automated-DB-Backups/
├── backup.sh                   # Backup script
├── restore.sh                  # Restore script
├── Jenkinsfile                 # Jenkins pipeline script
├── README.md                   # Project documentation
├── config/                     # Configuration files
│   ├── db_config.json          # Database connection settings
│   └── backup_settings.json    # Backup preferences
├── scripts/                    # Utility scripts
│   ├── pre_backup_tasks.sh     # Pre-backup operations
│   └── post_restore_tasks.sh   # Post-restore operations
└── docs/
    ├── setup_instructions.md   # Detailed setup guide
    └── troubleshooting.md      # Common issues and fixes
```
## Setup and Configuration

**1. Clone the Repository**
Clone the project to your local machine:
```bash
git clone https://github.com/<your_username>/Automated-DB-Backups.git
cd Automated-DB-Backups
```

**2. Configure Database Settings**
Update config/db_config.json with your database connection details:
```bash
{
    "host": "localhost",
    "port": "3306",
    "username": "root",
    "password": "password",
    "database": "my_database"
}
```
**3. Configure Backup Settings**
Update config/backup_settings.json with your backup preferences:
```bash
{
    "s3_bucket": "s3://your-bucket-name",
    "endpoint_url": "https://your-cloudflare-endpoint.com",
    "retention_days": 7
}
```
## 4. Install Dependencies 
Ensure the necessary tools are installed:

Install the AWS CLI: AWS CLI Installation Guide
Test connectivity with your S3 bucket:
```bash
aws s3 ls s3://your-bucket-name --endpoint-url https://your-cloudflare-endpoint.com
```
## 5. Set Up Jenkins Pipeline 
  1.Open Jenkins and create a new pipeline job.
  2.Copy the contents of Jenkinsfile into the pipeline configuration.
  3.Configure a cron schedule (e.g., H 2 * * * for daily backups).
  4.Add environment variables in the pipeline for S3 settings:
   *.S3_BUCKET
   *.ENDPOINT_URL

## 6 Usage
**Run Backups**
Backups can be triggered in two ways:

   1.Automated via Jenkins:
     *.Set up the pipeline as described above.
     *.Jenkins will automatically run backups based on your schedule.
   2.Manually from the Command Line: Run the backup.sh script:
   
    ./backup.sh
``
## 7 Restore Database
To restore a database from a backup:
   1.Locate the desired backup file in your S3 bucket.
   2.Download the file and run the restore.sh script:
```
   ./restore.sh path/to/backup.sql
```
This will overwrite the existing database with the contents of the backup.

## 8 Manual Testing

**1. Test Backup Script**
Run the following command to verify the backup process:
```
Copy code
./backup.sh

```
![image](https://github.com/user-attachments/assets/a46d6893-17d0-417f-9483-4161253ceede)

1.1Check the generated .sql file in the current directory.
1.2Verify that the backup file is uploaded to the S3 bucket.

**2. Test Restore Script**
Restore the generated backup:
```
./restore.sh path/to/backup.sql
```
![image](https://github.com/user-attachments/assets/026075ee-30b4-4358-8523-5ae23fd8f189)

## 3. Jenkins Pipeline Test##
Trigger the Jenkins job manually to ensure it executes without errors.
![image](https://github.com/user-attachments/assets/b2623da4-6cbc-4489-b2ec-d353c9a917ea)


## License ##
This project is licensed under the MIT License. See the LICENSE file for more information.
