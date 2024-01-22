pipeline{
    agent any

    environment {
        GOOGLE_APPLICATION_CREDENTIALS = credentials('ajaypipelineaccount')
    }


    stages{
        stage('Non Prod Infra : Creation'){
            when{
                anyOf{
                    branch 'develop';
                    branch 'test';
                }
            }
            steps{
                sh 'gcloud auth activate-service-account --key-file=$GOOGLE_APPLICATION_CREDENTIALS'
                sh 'gcloud config set project excellent-guide-410011'
                    script{
                        sh 'echo running non prod terraform scripts'
                        if(env.BRANCH_NAME == 'develop'){
                            dir("ops/ArtifactRegistry/dev"){
                                sh 'terraform --version'
                                sh 'terraform init'
                                sh 'terraform plan -out=output.tfplan'
                                sh 'terraform apply -auto-approve'
                            }
                        } else if(env.BRANCH_NAME == 'test'){
                            dir("ops/ArtifactRegistry/uat"){
                                sh 'terraform --version'
                                sh 'terraform init'
                                sh 'terraform plan -out=output.tfplan'
                                sh 'terraform apply -auto-approve'
                            }
                        }
                    }
                
            }
        }

        stage('Non Prod code build and docker image Creation'){
            when{
                anyOf{
                    branch 'develop';
                    branch 'test';
                }
            }
            steps{
                sh 'gcloud auth activate-service-account --key-file=$GOOGLE_APPLICATION_CREDENTIALS'
                sh 'gcloud config set project excellent-guide-410011'
                    script{
                        if(env.BRANCH_NAME == 'develop'){
                        dir("ops/Docker/dev"){
                        sh 'echo running dev build docker image '
                        sh 'docker version'
                        sh 'docker images'
                        sh 'docker build -t pythondemoimage'
                        sh 'docker images'
                        sh 'docker tag pythondemoimage asia-south1-docker.pkg.dev/excellent-guide-410011/cicd-demo-dev-repository/pythondemoimage:latest'
                        sh 'docker push asia-south1-docker.pkg.dev/excellent-guide-410011/cicd-demo-dev-repository/pythondemoimage:latest'
                        }
                    } else if(env.BRANCH_NAME == 'test'){
                        dir("ops/Docker/uat"){
                        sh 'echo running uat build docker image'
                        sh 'docker --version'
                        sh 'docker images'
                        sh 'docker build -t pythondemoimage'
                        sh 'docker images'
                        sh 'docker tag pythondemoimage asia-south1-docker.pkg.dev/excellent-guide-410011/cicd-demo-uat-repository/pythondemoimage:latest'
                        sh 'docker push asia-south1-docker.pkg.dev/excellent-guide-410011/cicd-demo-uat-repository/pythondemoimage:latest'
                        }
                    }
                
            }
        }
        }
        stage('Non Prod service Creation and deploymet '){
            when{
                anyOf{
                    branch 'develop';
                    branch 'test';
                }
            }
            steps{
                sh 'gcloud auth activate-service-account --key-file=$GOOGLE_APPLICATION_CREDENTIALS'
                sh 'gcloud config set project excellent-guide-410011'
                    script{
                        sh 'echo running non prod terraform scripts'
                        if(env.BRANCH_NAME == 'develop'){
                            dir("ops/CloudRunService/dev"){
                                sh 'terraform --version'
                                sh 'terraform init'
                                sh 'terraform plan -out=output.tfplan'
                                sh 'terraform apply -auto-approve'
                            }
                        } else if(env.BRANCH_NAME == 'test'){
                            dir("ops/CloudRunService/uat"){
                                sh 'terraform --version'
                                sh 'terraform init'
                                sh 'terraform plan -out=output.tfplan'
                                sh 'terraform apply -auto-approve'
                            }
                        }
                    }
                
            }
        }

        stage('Production Infra : Creation'){
            when{
                branch 'main';
            }
            steps{
                sh 'gcloud auth activate-service-account --key-file=$GOOGLE_APPLICATION_CREDENTIALS'
                sh 'gcloud config set project excellent-guide-410011'
                
                    script{
                        sh 'echo running prod terraform scripts'
                        if(env.BRANCH_NAME == 'main'){
                            dir("ops/ArtifactRegistry/prod"){
                                sh 'terraform --version'
                                sh 'terraform init'
                                sh 'terraform plan -out=output.tfplan'
                                sh 'terraform apply -auto-approve'
                            }
                            dir("ops/Docker/prod"){
                                sh 'echo running prod build docker image'
                                sh 'docker --version'
                                sh 'docker images'
                                sh 'docker build -t pythondemoimage'
                                sh 'docker images'
                                sh 'docker tag pythondemoimage asia-south1-docker.pkg.dev/excellent-guide-410011/cicd-demo-prod-repository/pythondemoimage:latest'
                                sh 'docker push asia-south1-docker.pkg.dev/excellent-guide-410011/cicd-demo-prod-repository/pythondemoimage:latest'
                            }
                            dir("ops/CloudRunService/prod"){
                                sh 'terraform --version'
                                sh 'terraform init'
                                sh 'terraform plan -out=output.tfplan'
                                sh 'terraform apply -auto-approve'
                            }

                        }
                        
                    }
                
            }
        }
    }
    post{
        always{
            cleanWs()
        }
    }
    
}
