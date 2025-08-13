pipeline {
    agent { label 'ubuntu' }

    stages {
        stage('Checkout') {
            steps {
                git branch: 'main', url: 'https://github.com/NiranPrem/DeployEKS.git'
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
                    docker run -d --name myjenkinscontainer -p 80:80 myjenkinsapp:latest
                '''
            }
        }

        stage('Test Application') {
            steps {
                sh 'curl -f http://localhost:80 || exit 1'
            }
        }
    }
}
