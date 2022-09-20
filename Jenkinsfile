//Purpose of this pipeline is to get the Jenkins file and Docker File from the repo and then build the Jenkins slave image and push it to the ECR.
//This will allow future revisions to the image and pipeline faster

pipeline {
    agent any
     options {
        skipStagesAfterUnstable()
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
                        docker.withRegistry('https://633706706076.dkr.ecr.us-east-1.amazonaws.com/jenkins-slave-pipeline', 'ecr:us-east-1:aws-main-admin-user') {
                        jenkins_slave.push("${env.BUILD_NUMBER}")
                        jenkins_slave.push("latest")
                }
            }
        }
    }
}    
}

