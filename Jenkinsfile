pipeline {
    agent any

    environment {
        GIT_CREDENTIALS_ID = credentials('github-token')
    }

    stages {
        stage('Clone Repository') {
            steps {
                git credentialsId: "github-token", 
                    url: 'https://github.com/JJGuilloryGit/jenkinstfpipeline.git', 
                    branch: 'main'
            }
        }
        // rest of your stages...
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
