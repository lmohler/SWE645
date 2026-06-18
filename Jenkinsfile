/*
 * Jenkinsfile
 * Author: Lucas Mohler
 * Purpose: Defines the CI/CD pipeline for SWE 645 Assignment 2. Automatically builds
 *          a Docker image, pushes it to Docker Hub, and deploys it to Kubernetes
 *          whenever changes are pushed to the GitHub repository.
 */

pipeline {
    agent any


    environment {
        DOCKERHUB_USER = 'lmohler'
        IMAGE_NAME     = 'my-webapp'
        IMAGE_TAG      = 'latest'
    }


    stages {

        stage('Build Docker Image') {
            steps {
                script {
                    dockerImage = docker.build("${DOCKERHUB_USER}/${IMAGE_NAME}:${IMAGE_TAG}")
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
                        sh 'kubectl rollout restart deployment/my-webapp'
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
