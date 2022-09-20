//Purpose of this pipeline is to get the Jenkins file and Docker File from the repo and then build the Jenkins slave image and push it to the ECR.
//This will allow future revisions to the image and pipeline faster

pipeline {
    agent any
     options {
        skipStagesAfterUnstable()
    }

environment 
    {
        PROJECT = 'jenkins_slave'
        ECRURL = 'https://633706706076.dkr.ecr.us-east-1.amazonaws.com'
        ECRCRED = 'ecr:us-east-1:aws-main-admin-user'
    }

stages { 
    stage('Clone repository') { 
            steps { 
                script{
                checkout scm
                }
            }
    }   
    stage('Build docker image') {
        steps {
            script{ 
                jenkins_slave = docker.build("jenkins_slave")
            }
        }
    }
     stage('Deploy') {
            steps {
                script{
                        docker.withRegistry(ECRURL, ECRCRED) {

                        docker.image(PROJECT).push("latest")
                }
            }
        }
    }
}    
}

