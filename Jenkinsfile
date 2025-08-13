pipeline {
    agent { label 'ubuntu' }

    stages {
        stage('Verify Docker Access') {
            steps {
                script {
                    def result = sh(script: "docker info > /dev/null 2>&1", returnStatus: true)
                    if (result != 0) {
                        error "Jenkins cannot access Docker. Check group membership and restart Jenkins."
                    }
                }
            }
        }

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

    post {
        always {
            echo 'Cleaning up...'
            sh 'docker rm -f myjenkinscontainer || true'
            sh 'docker image prune -f || true'
        }
    }
}
