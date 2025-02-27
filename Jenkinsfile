pipeline {
    agent any

    environment {
        KUBECONFIG = credentials('kubeconfig-credentials-id')  // Kubernetes authentication
    }

    stages {
        stage('Checkout') {
            steps {
                git 'https://github.com/jenkinstfpipeline/mlops-project.git'
            }
        }

        stage('Set Up Python Environment') {
            steps {
                sh '''
                python3 -m venv venv
                source venv/bin/activate
                pip install -r requirements.txt
                '''
            }
        }

        stage('Train Model') {
            steps {
                sh '''
                source venv/bin/activate
                python train.py
                '''
            }
        }

        stage('Terraform Apply (Provision Infra)') {
            steps {
                sh '''
                cd terraform
                terraform init
                terraform apply -auto-approve
                '''
            }
        }

        stage('Deploy Model to Kubernetes') {
            steps {
                sh '''
                kubectl apply -f k8s/deployment.yaml
                kubectl apply -f k8s/service.yaml
                '''
            }
        }

        stage('Monitor Deployment') {
            steps {
                sh 'kubectl get pods'
                sh 'kubectl get services'
            }
        }
    }
}
