
pipeline {
    agent any
    environment {
        IMAGE_NAME = 'loki1492/ci-cd-nodejs-app'
    }
    stages {
        stage('Clone Code') {
            steps {
                git 'https://github.com/lowkey-loki14/ci-cd-nodejs-app.git'
            }
        }
        stage('Build Docker Image') {
            steps {
                script {
                    sh 'docker build -t $IMAGE_NAME .'
                }
            }
        }
        stage('Push to Docker Hub') {
            steps {
                withCredentials([usernamePassword(credentialsId: 'dockerhub-credentials', usernameVariable: 'USERNAME', passwordVariable: 'PASSWORD')]) {
                    sh 'echo $PASSWORD | docker login -u $USERNAME --password-stdin'
                    sh 'docker push $IMAGE_NAME'
                }
            }
        }
        stage('Deploy Container') {
            steps {
                sshagent(['ecommerce-key']) {
                    sh '''
                    ssh -o StrictHostKeyChecking=no ubuntu@54.91.42.13 << EOF
                      docker rm -f ci-cd-nodejs-app || true
                      docker pull $IMAGE_NAME
                      docker run -d -p 3000:3000 --name ci-cd-app $IMAGE_NAME
                    EOF
                    '''
                }
            }
        }
    }
}
