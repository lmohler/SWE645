pipeline {
    agent any


    environment {
        DOCKERHUB_USER = 'lmohler'
        IMAGE_NAME     = 'my-webapp'
        IMAGE_TAG      = 'latest'
    }


    stages {


        stage('Checkout') {
            steps {
                git 'https://github.com/lmohler/SWE645.git'
            }
        }


        stage('Build Docker Image') {
            steps {
                script {
                    dockerImage = docker.build(
                        "\/\:\")
                }
            }
        }


        stage('Push to Docker Hub') {
            steps {
                script {
                    docker.withRegistry(
                        'https://index.docker.io/v1/',
                        'docker-pass') {
                        dockerImage.push()
                    }
                }
            }
        }


        stage('Deploy to Kubernetes') {
            steps {
                script {
                    withCredentials([file(
                        credentialsId: 'kubeconfig',
                        variable: 'KUBECONFIG')]) {
                        sh 'kubectl apply -f k8s/deployment.yaml'
                        sh 'kubectl apply -f k8s/service.yaml'
                    }
                }
            }
        }
    }


    post {
        success { echo 'Pipeline completed successfully!' }
        failure { echo 'Pipeline failed. Check console output.' }
    }
}
