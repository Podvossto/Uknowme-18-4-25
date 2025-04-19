pipeline {
    agent any

    environment {
        GIT_REPO = 'https://github.com/Podvossto/Uknowme-18-4-25.git'
        GIT_BRANCH = 'main'
        PATH = "/usr/local/bin:${env.PATH}"
        APP_PORT = '5173'
        ROBOT_REPORTS_DIR = 'robot-reports'
        VENV_PATH = 'robot-venv'
    }

    stages {
        stage('Git Clone') {
            steps {
                cleanWs()
                git branch: "${GIT_BRANCH}",
                    url: "${GIT_REPO}",
                    credentialsId: 'git-credentials'
            }
        }

        stage('Check Node') {
            steps {
                bat '''
                    node -v
                    npm -v
                '''
            }
        }

        stage('Prepare Test Environment') {
            steps {
                bat '''
                    python -m venv %VENV_PATH%
                    call %VENV_PATH%\\Scripts\\activate
                    pip install --upgrade pip
                    pip install robotframework robotframework-seleniumlibrary pyotp
                '''
            }
        }

        stage('Check Docker') {
            steps {
                bat 'docker info'
            }
        }

        stage('Clean Up Containers') {
            steps {
                bat 'docker-compose down'
            }
        }

        stage('Create .env File') {
            steps {
                writeFile file: 'Server/.env', text: '''
MONGODB_URI=mongodb://127.0.0.1:27017/Uknowmedatabase
PORT=3000
JWT_SECRET=uknowme
SMTP_HOST=smtp.gmail.com
SMTP_PORT=587
SMTP_USER=UknowmeService@gmail.com
SMTP_PASS=ldgukmgxnmsrbkkw
OTP_SECRET=uknowme
FRONTEND_URL=http://localhost:5173
'''
            }
        }

        stage('Build Docker Images') {
            steps {
                bat 'docker-compose build'
            }
        }

        stage('Deploy Containers') {
            steps {
                bat 'docker-compose up -d'
            }
        }

        stage('Run Robot Tests') {
            steps {
                bat '''
                    robot -d %ROBOT_REPORTS_DIR% \
                        PositiveSuperAdmin.robot \
                        PositiveBond.robot \
                        PositiveAdmin.robot \
                        NegativeSuperAdmin.robot \
                        NegativeBond.robot \
                        NegativeAdmin.robot
                '''
            }
        }

        stage('Docker Compose Logs') {
            steps {
                bat 'docker-compose logs --tail=50'
            }
        }
    }

    post {
        success {
            echo "Pipeline สำเร็จ! แอปพลิเคชันกำลังทำงานที่ http://localhost:${APP_PORT}"
            echo "รายงานการทดสอบ Robot Framework อยู่ในโฟลเดอร์ ${ROBOT_REPORTS_DIR}"
        }
        failure {
            echo 'Pipeline ล้มเหลว! กรุณาตรวจสอบบันทึกเพื่อดูรายละเอียด'
        }
        always {
            cleanWs()
        }
    }
}
