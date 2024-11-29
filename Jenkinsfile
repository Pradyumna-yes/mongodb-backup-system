pipeline {
    agent any
    environment {
        GITHUB_REPO = 'https://github.com/Pradyumna-yes/mongodb-backup-system.git' // Replace with your GitHub repo
        BACKUP_SCRIPT = './backup.sh' // Path to your backup script in the repository
        RESTORE_SCRIPT = './restore.sh' // Path to your restore script in the repository
        R2_BUCKET = 'paddu' // Your Cloudflare R2 bucket name
        R2_ENDPOINT = 'https://ee39b00ce77b46c6e6df5b0d3717b9bd.eu.r2.cloudflarestorage.com' // Cloudflare endpoint
    }
    stages {
        stage('Clone Repository') {
            steps {
                echo 'Cloning the repository...'
                git branch: 'main', url: "${GITHUB_REPO}"
            }
        }
        stage('Setup AWS Credentials') {
            steps {
                script {
                    echo "Configuring AWS credentials..."
                }
                withCredentials([string(credentialsId: 'jenkins', variable: 'AWS_CREDENTIALS')]) {
                    sh """
                    export AWS_ACCESS_KEY_ID=\$(echo \$AWS_CREDENTIALS | awk -F: '{print \$1}')
                    export AWS_SECRET_ACCESS_KEY=\$(echo \$AWS_CREDENTIALS | awk -F: '{print \$2}')
                    echo "Testing AWS S3 Access..."
                    aws s3 ls s3://${R2_BUCKET} --endpoint-url=${R2_ENDPOINT}
                    """
                }
            }
        }
        stage('Run Backup Script') {
            steps {
                echo 'Running the backup script...'
                sh """
                chmod +x ${BACKUP_SCRIPT}
                ${BACKUP_SCRIPT}
                """
            }
        }
        stage('Run Restore Script') {
            steps {
                echo 'Running the restore script...'
                sh """
                chmod +x ${RESTORE_SCRIPT}
                ${RESTORE_SCRIPT}
                """
            }
        }
    }
    post {
        always {
            echo 'Pipeline completed.'
        }
        success {
            echo 'Pipeline succeeded.'
        }
        failure {
            echo 'Pipeline failed.'
        }
    }
}
