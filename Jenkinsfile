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
                    pip install robotframework robotframework-seleniumlibrary
                '''
            }
        }

        

        stage('Check Docker') {
            steps {
                bat 'docker info'
            }
        }

        stage('Docker Compose Deploy') {
            steps {
                bat '''
                    docker-compose down
                    docker-compose build
                    docker-compose up -d
                '''
            }
        }

        stage('Run Robot Tests') {
            steps {
                bat """
                    call %VENV_PATH%\\Scripts\\activate
                    if not exist %ROBOT_REPORTS_DIR% mkdir %ROBOT_REPORTS_DIR%
                    if exist TestCase.robot python -m robot --outputdir %ROBOT_REPORTS_DIR% TestCase.robot
                """
            }
        }
    }

    post {
        success {
            echo "Pipeline สำเร็จ! แอปพลิเคชันกำลังทำงานที่ http://localhost:${APP_PORT}"
            echo "รายงานการทดสอบ Robot Framework อยู่ในโฟลเดอร์ ${ROBOT_REPORTS_DIR}"
        }
        failure {
            echo "Pipeline ล้มเหลว! กรุณาตรวจสอบบันทึกเพื่อดูรายละเอียด"
        }
        always {
            cleanWs()
        }
    }
} 