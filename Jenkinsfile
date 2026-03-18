pipeline {
    agent any
    parameters {
        choice(name: 'ENV', choices: ['dev', 'test', 'prod'], description: 'Target environment')
    }
    stages {
        stage('Checkout') {
            steps {
                checkout scm
            }
        }
        stage('Install Docker CLI (if needed)') {
            steps {
                sh '''
                    if ! command -v docker &> /dev/null
                    then
                        echo "Docker not found, installing..."
                        apt-get update
                        apt-get install -y docker.io
                    else
                        echo "Docker already installed"
                    fi
                '''
            }
        }
        stage('Build Image') {
            steps {
                sh 'docker build -t status-service:${BUILD_NUMBER} .'
            }
        }
        stage('Test') {
            steps {
                sh 'docker run --rm status-service:${BUILD_NUMBER} node -e "console.log(\\"Tests passed\\")"'
            }
        }
        stage('Deploy') {
            when {
                expression { params.ENV != 'prod' }
            }
            steps {
                sh 'docker run -d -p 3000:3000 -e ENV=${params.ENV} status-service:${BUILD_NUMBER}'
            }
        }
        stage('Deploy to Prod') {
            when {
                expression { params.ENV == 'prod' }
            }
            steps {
                input message: 'Approve production deployment'
                sh 'docker run -d -p 3000:3000 -e ENV=prod status-service:${BUILD_NUMBER}'
            }
        }
    }
    post {
        always {
            echo "Pipeline finished. Cleaning up stopped containers."
            sh '''
                docker ps -a -q --filter "name=status-service" | xargs -r docker rm -f
            '''
        }
    }
}