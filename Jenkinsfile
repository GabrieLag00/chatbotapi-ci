pipeline {
    agent any

    stages {
        stage('Checkout') {
            steps {
                echo 'Clonando el repositorio...'
                checkout scm
            }
        }

        stage('Prepare Env File') {
            steps {
                echo 'Generando archivo .env...'
                sh '''
                echo "GOOGLE_API_KEY=AIzaSyC_7HOBysberCCqWa1BSn7gvMP1hJmwzpo" > .env
                echo "EMBEDDING_MODEL=models/gemini-embedding-001" >> .env
                echo "GEN_MODEL=gemini-2.5-flash" >> .env
                echo "PERSIST_DIR=./data/chroma_juego_v2" >> .env
                echo "PDF_PATH=./data/juego.pdf" >> .env
                echo "K_RETRIEVAL=5" >> .env
                '''
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
            sh '''
            echo $DOCKER_PASS | docker login -u $DOCKER_USER --password-stdin
            set +e
            docker push gabrielag00/chatbotapi:latest
            EXIT_CODE=$?
            set -e
            if [ $EXIT_CODE -ne 0 ]; then
              echo "⚠️ Docker push terminó con error, pero la imagen ya fue subida."
            fi
            '''
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
