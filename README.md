# mb-eye-jenkins-slave-build


These are pipeline files.

This is the slave container build.  Its design to sit within the kubernetes cluster, and each pipeline instance used in the Master will
spin up a new Jenkins slave container.  This allows for scalability.  In addition, its easier for the Jenkins slave to use kubectl within
the cluster since its a member of the cluster, and has been granted appropriate permissions (see Jenkins Master Build Repo for that - its in the
jenkins.rbac.yaml file)

This method of running Jenkins within Kubernetes of course relies on the Jenkins Kubernetes plugin.

The jenkins-slave file is an official script from jenkins that is required for the DockerImage build.  It will incorporate the script.
Without the script being copied into the DockerImage - the build will not work.

In addition - I added the AWS command line tools to the image so that it could interact with AWS ECR in order to fetch images,
or perform other tasks.

Another interesting thing to note about this build - is that much of the configuration required takes place in the Jenkins UI.
In this case - I have chosen to use ECR repo in AWS to pull the image.  There are two levels of authentication required in order to do this.
First - a secret needs to be generated on the Kubernetes cluster, which allows the cluster to access ECR.
In addition, the Master also has an AWS account tied to it in a secret in the Jenkins UI (not on the cluster) that is used in order to
connect to ECR and perform the build.

The method to do generate and use the secret is below:

 first on the kubernetes node in the cluster do the following:
 
 aws ecr get-login-password --region <insert your region> | docker login --username AWS --password-stdin <youraccountname>.dkr.ecr.us-east-1.amazonaws.com

Then once that is done you can do the following:

kubectl create secret generic regcred \
--from-file=.dockerconfigjson=/home/ec2-user/.docker/config.json> \
--type=kubernetes.io/dockerconfigjson

