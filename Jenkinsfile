pipeline {
    agent any

    environment {
        GOOGLE_APPLICATION_CREDENTIALS = credentials('ajaypipelineaccount')
    }

    stages {
        stage('Non Prod Infra : Creation') {
            when {
                anyOf {
                    branch 'develop'
                    branch 'test'
                }
            }
            steps {
                sh 'gcloud auth activate-service-account --key-file=$GOOGLE_APPLICATION_CREDENTIALS'
                sh 'gcloud config set project ajayjenkins'
                script {
                    echo 'Running non-prod Terraform scripts'
                    dir("ops/ArtifactRegistry/${env.BRANCH_NAME}") {
                        sh 'terraform --version'
                        sh 'terraform init'
                        sh 'terraform plan -out=output.tfplan'
                        sh 'terraform apply -auto-approve'
                    }
                }
            }
        }

        stage('Non Prod code build and docker image Creation') {
            when {
                anyOf {
                    branch 'develop'
                    branch 'test'
                }
            }
            steps {
                sh 'gcloud auth activate-service-account --key-file=$GOOGLE_APPLICATION_CREDENTIALS'
                sh 'gcloud config set project excellent-guide-410011'
                script {
                    if (env.BRANCH_NAME == 'develop') {
                        dir("ops/src/dev") {
                            echo 'Running dev build docker image'
                            sh 'docker version'
                            sh 'docker rmi -f $(docker images -q)'
                            sh 'docker images'
                            sh 'docker build -t pythondemoimage .'
                            sh 'gcloud auth configure-docker asia-south1-docker.pkg.dev'
                            sh 'docker images'
                            sh 'docker tag pythondemoimage asia-south1-docker.pkg.dev/excellent-guide-410011/anil-cicd-demo-dev-repo/pythondemoimage:latest'
                            sh 'docker push asia-south1-docker.pkg.dev/excellent-guide-410011/anil-cicd-demo-dev-repo/pythondemoimage:latest'
                        }
                    } else if (env.BRANCH_NAME == 'test') {
                        dir("ops/src/uat") {
                            echo 'Running uat build docker image'
                            sh 'docker --version'
                            sh 'docker images'
                            sh 'docker build -t pythondemoimage .'
                            sh 'gcloud auth configure-docker us-central1-a-docker.pkg.dev'
                            sh 'docker images'
                            sh 'docker tag pythondemoimage us-central1-a-docker.pkg.dev/ajayjenkins/anil-cicd-demo-uat-repo/pythondemoimage:latest'
                            sh 'docker push us-central1-a-docker.pkg.dev/ajayjenkins/anil-cicd-demo-uat-repo/pythondemoimage:latest'
                        }
                    }
                }
            }
        }

        stage('Non Prod service Creation and deployment') {
            when {
                anyOf {
                    branch 'develop'
                    branch 'test'
                }
            }
            steps {
                sh 'gcloud auth activate-service-account --key-file=$GOOGLE_APPLICATION_CREDENTIALS'
                sh 'gcloud config set project excellent-guide-410011'
                script {
                    echo 'Running non-prod Terraform scripts'
                    dir("ops/CloudRunService/${env.BRANCH_NAME}") {
                        sh 'terraform --version'
                        sh 'terraform init'
                        sh 'terraform plan -out=output.tfplan'
                        sh 'terraform apply -auto-approve'
                    }
                }
            }
        }

        stage('Production Infra : Creation') {
            when {
                branch 'main'
            }
            steps {
                sh 'gcloud auth activate-service-account --key-file=$GOOGLE_APPLICATION_CREDENTIALS'
                sh 'gcloud config set project excellent-guide-410011'
                script {
                    echo 'Running prod Terraform scripts'
                    dir("ops/ArtifactRegistry/prod") {
                        sh 'terraform --version'
                        sh 'terraform init'
                        sh 'terraform plan -out=output.tfplan'
                        sh 'terraform apply -auto-approve'
                    }
                    dir("ops/src/prod") {
                        echo 'Running prod build docker image'
                        sh 'docker --version'
                        sh 'docker images'
                        sh 'docker build -t pythondemoimage .'
                        sh 'gcloud auth configure-docker asia-south1-docker.pkg.dev'
                        sh 'docker images'
                        sh 'docker tag pythondemoimage asia-south1-docker.pkg.dev/excellent-guide-410011/anil-cicd-demo-prod-repo/pythondemoimage:latest'
                        sh 'docker push asia-south1-docker.pkg.dev/excellent-guide-410011/anil-cicd-demo-prod-repo/pythondemoimage:latest'
                    }
                    dir("ops/CloudRunService/prod") {
                        sh 'terraform --version'
                        sh 'terraform init'
                        sh 'terraform plan -out=output.tfplan'
                        sh 'terraform apply -auto-approve'
                    }
                }
            }
        }
    }

    post {
        always {
            cleanWs()
        }
    }
}
