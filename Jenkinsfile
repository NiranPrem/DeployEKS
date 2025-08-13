pipeline {
    agent { label 'ubuntu' }

    stages {
        stage('Checkout') {
            steps {
                // Checkout main branch explicitly
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
                    # Remove old container if exists
                    docker rm -f myjenkinscontainer || true
                    # Run new container
                    docker run -d --name myjenkinscontainer -p 8080:80 myjenkinsapp:latest
                '''
            }
        }

        stage('Test Application') {
            steps {
                sh 'curl -f http://localhost:8080 || exit 1'
            }
        }
    }
}
