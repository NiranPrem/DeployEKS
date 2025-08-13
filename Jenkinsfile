pipeline {
    agent { label 'ubuntu' } 
    stages {
        stage('Checkout') {
            steps {
                git 'https://github.com/NiranPrem/DeployEKS.git'
            }
        }
        stage('Build Docker Image') {
            steps {
                sh 'docker build -t myjenkinsapp:latest .'
            }
        }
        stage('Run Container') {
            steps {
                sh '''
                    docker rm -f myjenkinscontainer || true
                    docker run -d --name myjenkinscontainer -p 8080:80 myjenkinsapp:latest
                '''
            }
        }
        stage('test application') {
            steps {
                sh 'curl -f http://localhost:8080 || exit 1'
            }
        }
    }
}

