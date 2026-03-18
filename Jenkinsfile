pipeline {
    agent {
        docker {
            image 'ubuntu:22.04'
            args '-u root -v /var/run/docker.sock:/var/run/docker.sock'
            }
        }
        parameters {
            choice(name: 'ENV', choices: ['dev', 'test', 'prod'], description: 'Target environment')
            }
            
        stages {
            stage('Install Docker CLI') {
                steps {
                    sh '''
                    apt-get update
                    apt-get install -y docker.io
                    '''
                }
            }
        stage('Checkout') {
            steps {
                checkout scm
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
                sh 'docker run -d -p 3000:3000 -e ENV=${ENV} status-service:${BUILD_NUMBER}'
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
}