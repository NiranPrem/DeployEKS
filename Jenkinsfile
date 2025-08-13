pipeline {
    agent { label 'ubuntu' }

    environment {
        IMAGE_NAME = "myjenkinsapp:latest"
        CONTAINER_NAME = "myjenkinscontainer"
        HOST_PORT = "80"        // Change to 8080 if needed
        CONTAINER_PORT = "80"
    }

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

        stage('Stop Conflicting Services') {
            steps {
                script {
                    // Stop Apache if running on port 80
                    sh """
                    if ss -tuln | grep -q ':${HOST_PORT} '; then
                        echo 'Port ${HOST_PORT} is in use. Stopping Apache...'
                        sudo systemctl stop apache2 || true
                    fi
                    """
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
                sh "docker build -t ${IMAGE_NAME} ."
            }
        }

        stage('Run Container') {
            steps {
                sh """
                    docker rm -f ${CONTAINER_NAME} || true
                    docker run -d --name ${CONTAINER_NAME} -p ${HOST_PORT}:${CONTAINER_PORT} ${IMAGE_NAME}
                """
            }
        }

        stage('Test Application') {
            steps {
                sh "curl -f http://localhost:${HOST_PORT} || exit 1"
            }
        }
    }

    post {
        always {
            echo 'Cleaning up...'
            sh "docker rm -f ${CONTAINER_NAME} || true"
            sh "docker image prune -f || true"
        }
    }
}
