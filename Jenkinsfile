pipeline {
    agent any

    stages {
        stage('Checkout') {
            steps {
                echo 'Clonando el repositorio...'
                checkout scm
            }
        }

        stage('Build Docker Image') {
            steps {
                echo 'Construyendo imagen Docker...'
                sh 'docker build -t gabrielag00/chatbotapi:latest .'
            }
        }

        stage('Push to DockerHub') {
            steps {
                echo 'Subiendo imagen a DockerHub...'
                withCredentials([usernamePassword(credentialsId: 'dockerhub-creds', usernameVariable: 'DOCKER_USER', passwordVariable: 'DOCKER_PASS')]) {
                    sh "echo $DOCKER_PASS | docker login -u $DOCKER_USER --password-stdin"
                    sh 'docker push gabrielag00/chatbotapi:latest'
                }
            }
        }

        stage('Deploy to Staging') {
            steps {
                echo 'Desplegando en namespace STAGING...'
                withKubeConfig([credentialsId: 'kubeconfig-creds']) {
                    sh 'kubectl apply -n staging -f deployment.yaml'
                    sh 'kubectl apply -n staging -f service.yaml'
                }
            }
        }

        stage('Promote to Production') {
            steps {
                input message: "¿Promover a producción?"
                echo 'Desplegando en namespace PRODUCTION...'
                withKubeConfig([credentialsId: 'kubeconfig-creds']) {
                    sh 'kubectl apply -n production -f deployment.yaml'
                    sh 'kubectl apply -n production -f service.yaml'
                }
            }
        }
    }
}
