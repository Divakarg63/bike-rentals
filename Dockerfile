pipeline {
    agent any

    environment {
        IMAGE_NAME = "surya-nodejs-app"
        CONTAINER_NAME = "surya-node-container"
    }

    stages {

        stage('Checkout Code') {
            steps {
                git 'https://github.com/Surya8442/project-nodejs-webapp.git'
            }
        }

        stage('Build Docker Image') {
            steps {
                sh 'docker build -t $IMAGE_NAME .'
            }
        }

        stage('Run Container') {
            steps {
                sh '''
                docker stop $CONTAINER_NAME || true
                docker rm $CONTAINER_NAME || true
                docker run -d -p 1337:1337 --name $CONTAINER_NAME $IMAGE_NAME
                '''
            }
        }
        stage('Push Image to DockerHub') {
            steps {
                withCredentials([usernamePassword(credentialsId: 'Docker_cred', usernameVariable: 'USER', passwordVariable: 'PASS')]) {
                    sh '''
                    echo "$PASS" | docker login -u "$USER" --password-stdin
                    docker tag ${IMAGE_NAME}:${IMAGE_TAG} ${DOCKER_USER}/${IMAGE_NAME}:${IMAGE_TAG}
                    docker push ${DOCKER_USER}/${IMAGE_NAME}:${IMAGE_TAG}
                    '''
                }
            }
        }

    }
}
