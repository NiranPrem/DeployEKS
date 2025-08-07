pipeline {
    agent any
    
    stages {
        stage('Checkout') {
            steps {
                // Assuming your repository is a Git repository, this step is for checkout.
                // The pipeline will automatically check out the repository to the workspace.
                echo "Repository checked out."
            }
        }
        
        stage('Upload to S3') {
            steps {
                withAWS(credentials: '53fb8826-2d78-41ab-979b-7e6f5aa3ab4b', region: 'us-east-1') {
                    // Uploads the 'test.txt' file to your S3 bucket.
                    // Replace 'your-s3-bucket-name' with the actual name of your S3 bucket.
                    // The 'cp' command copies the file from the Jenkins workspace to S3.
                    sh 'aws s3 cp test.txt s3://myterra1234/'
                }
            }
        }
    }
}
