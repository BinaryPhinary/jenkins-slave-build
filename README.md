# mb-eye-jenkins-slave-build

This is the slave container build.  Its design to sit within the kubernetes cluster, and each pipeline instance used in the Master will
spin up a new Jenkins slave container.  This allows for scalability.  In addition, its easier for the Jenkins slave to use kubectl within
the cluster since its a member of the cluster, and has been granted appropriate permissions (see Jenkins Master Build Repo for that)

This method of running Jenkins within Kubernetes of course relies on the Jenkins Kubernetes plugin.

The jenkins-slave file is an official script from jenkins that is required for the DockerImage build.  It will incorporate the script.
Without the script being copied into the DockerImage - the build will not work.
