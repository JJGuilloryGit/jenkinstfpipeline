pipeline {
    agent any

    environment {
        GIT_CREDENTIALS_ID = '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' // Use the ID of your GitHub token
    }

    stages {
        stage('Clone Repository') {
            steps {
                git credentialsId: "${GIT_CREDENTIALS_ID}", url: 'https://github.com/JJGuilloryGit/jenkinstfpipeline.git', branch: 'main'
            }
        }

        stage('Build') {
            steps {
                sh 'echo "Building the project..."'
                sh 'python --version' // Example: Check Python version
            }
        }

        stage('Test') {
            steps {
                sh 'echo "Running tests..."'
            }
        }

        stage('Deploy') {
            steps {
                sh 'echo "Deploying application..."'
            }
        }
    }

    post {
        success {
            echo 'Pipeline completed successfully!'
        }
        failure {
            echo 'Pipeline failed!'
        }
    }
}
