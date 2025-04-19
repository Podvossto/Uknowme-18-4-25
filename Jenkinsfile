pipeline {
    agent any
    
    environment {
        DOCKER_IMAGE = 'clients'
        DOCKER_TAG = 'latest'
        GIT_REPO = 'https://github.com/Podvossto/Uknowme-18-4-25.git'
        GIT_BRANCH = 'main'
        PATH = "/usr/local/bin:${env.PATH}"
        APP_PORT = '5001'
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

        stage('Install Dependencies') {
            steps {
                bat '''
                    npm install
                    python -m venv %VENV_PATH%
                    call %VENV_PATH%\Scripts\activate
                    python -m pip install robotframework robotframework-seleniumlibrary
                '''
            }
        }

        stage('Build') {
            steps {
                bat 'npm run build'
            }
        }

        stage('Docker Compose Build') {
            steps {
                script {
                    bat '''
                        docker-compose down
                        docker-compose build
                    '''
                }
            }
        }

        stage('Deploy Container') {
            steps {
                script {
                    bat '''
                        docker-compose up -d
                        echo แอปพลิเคชันกำลังทำงานด้วย docker-compose
                        echo คุณสามารถเข้าถึงได้ที่ http://localhost:%APP_PORT%
                    '''
                }
            }
        }

        stage('Run Robot Tests') {
            steps {
                script {
                    bat """
                        call %VENV_PATH%\Scripts\activate
                        if not exist %ROBOT_REPORTS_DIR% mkdir %ROBOT_REPORTS_DIR%
                        python -m robot --outputdir %ROBOT_REPORTS_DIR% TestCase.robot
                    """
                }
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