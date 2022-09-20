# mb-eye-jenkins-slave-build

This is the slave container build.  Its design to sit within the kubernetes cluster, and each pipeline instance used in the Master will
spin up a new Jenkins slave container.  This allows for scalability.  In addition, its easier for the Jenkins slave to use kubectl within
the cluster since its a member of the cluster, and has been granted appropriate permissions (see Jenkins Master Build Repo for that)

This method of running Jenkins within Kubernetes of course relies on the Jenkins Kubernetes plugin.

The jenkins-slave file is an official script from jenkins that is required for the DockerImage build.  It will incorporate the script.
Without the script being copied into the DockerImage - the build will not work.

Another interesting thing to note about this build - is that much of the configuration required takes place in the Jenkins UI.
In this case - I have chosen to use ECR repo in AWS to pull the image.  This required a secret to be generated on the Kubernetes cluster,
which allows the cluster to access ECR.  In addition, the Master also has an AWS account tied to it in a secret that is used in order to
connect to ECR and perform the build.
