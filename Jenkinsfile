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
                sh 'gcloud config set project ajayjenkins'
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
                // Add Jenkins user to the docker group
                // sh 'sudo usermod -aG docker jenkins'
                // Restart Jenkins to apply group changes
                // sh 'sudo systemctl restart jenkins'
                    script{
                        if(env.BRANCH_NAME == 'develop'){
                        dir("ops/src/dev"){
                        sh 'echo running dev build docker image '
                        sh 'docker version'
                        sh 'docker rmi -f $(docker images -q)'
                        sh 'docker images'
                        sh 'docker build -t pythondemoimage .'
                        // Authenticate Docker to Google Cloud Artifact Registry
                        sh 'gcloud auth configure-docker us-central1-docker.pkg.dev'
                        sh 'docker images'
                        sh 'docker tag pythondemoimage us-central1-docker.pkg.dev/ajayjenkins/ajay-pipeline/pythondemoimage:latest'
                        sh 'docker push us-central1-docker.pkg.dev/ajayjenkins/ajay-pipeline/pythondemoimage:latest'
                        }
                    } else if(env.BRANCH_NAME == 'test'){
                        dir("ops/src/uat"){
                        sh 'echo running uat build docker image'
                        sh 'docker --version'
                        sh 'docker images'
                        sh 'docker build -t pythondemoimage'
                        sh 'gcloud auth configure-docker us-central1-docker.pkg.dev'
                        sh 'docker images'
                        sh 'docker tag pythondemoimage us-central1-docker.pkg.dev/ajayjenkins/anil-cicd-demo-uat-repo/pythondemoimage:latest'
                        sh 'docker push us-central1-docker.pkg.dev/ajayjenkins/anil-cicd-demo-uat-repo/pythondemoimage:latest'
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
                            dir("ops/src/prod"){
                                sh 'echo running prod build docker image'
                                sh 'docker --version'
                                sh 'docker images'
                                sh 'docker build -t pythondemoimage'
                                sh 'gcloud auth configure-docker asia-south1-docker.pkg.dev'
                                sh 'docker images'
                                sh 'docker tag pythondemoimage asia-south1-docker.pkg.dev/excellent-guide-410011/anil-cicd-demo-prod-repo/pythondemoimage:latest'
                                sh 'docker push asia-south1-docker.pkg.dev/excellent-guide-410011/anil-cicd-demo-prod-repo/pythondemoimage:latest'
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
