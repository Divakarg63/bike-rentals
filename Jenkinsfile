
pipeline {
agent any

environment {
    DOCKER_IMAGE = "rajeshtutta123/bike_rentals_project_img"
}

stages {

    stage('GIT CHECKOUT') {
        steps {
            git branch: 'master',
            credentialsId: 'rajeshcred',
            url: 'https://github.com/rajeshtutta/bike-rentals.git'
        }
    }

    stage('BUILD') {
        steps {
            sh 'mvn clean package -DskipTests'
        }
    }

    stage('Docker Build') {
        steps {
            sh 'docker build -t $DOCKER_IMAGE:latest .'
        }
    }

    stage('Docker Login') {
        steps {
            withCredentials([usernamePassword(credentialsId: 'dockerhub-cred', usernameVariable: 'USER', passwordVariable: 'PASS')]) {
                sh 'echo $PASS | docker login -u $USER --password-stdin'
            }
        }
    }

    stage('Push Image') {
        steps {
            sh 'docker push $DOCKER_IMAGE:latest'
        }
    }

    stage('Deploy Container') {
        steps {
            sh '''
            docker rm -f Hotstar_project_cont || true
            docker run -d -p 2002:8080 --name Hotstar_project_cont $DOCKER_IMAGE:latest
            '''
        }
    }

}

}
