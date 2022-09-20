FROM openjdk:11-jdk

RUN apt-get update -y && apt-get install -y curl sudo

#Install docker
RUN curl -sSL https://get.docker.com/ | sh

ARG user=jenkins
ARG group=jenkins
ARG uid=10000
ARG gid=10000

ENV HOME /home/${user}
RUN groupadd -g ${gid} ${group}
RUN useradd -c "Jenkins user" -d $HOME -u ${uid} -g ${gid} -m ${user}
RUN usermod -aG docker ${user}
RUN usermod -aG sudo ${user}

ARG JVERSION=4.13.1
ARG AGENT_WORKDIR=/home/${user}/agent

RUN curl --create-dirs -sSLo /usr/share/jenkins/slave.jar https://repo.jenkins-ci.org/public/org/jenkins-ci/main/remoting/${JVERSION}/remoting-${JVERSION}.jar \
  && chmod 755 /usr/share/jenkins \
  && chmod 644 /usr/share/jenkins/slave.jar

#docker compose cli
RUN curl -L https://github.com/docker/compose/releases/download/v2.11.0/docker-compose-`uname -s`-`uname -m` -o /usr/local/bin/docker-compose \
    && chmod +x /usr/local/bin/docker-compose

COPY  jenkins-slave /usr/local/bin/jenkins-slave
RUN chmod 777 /usr/local/bin/jenkins-slave

RUN echo 'jenkins ALL=(ALL) NOPASSWD:ALL'| sudo EDITOR='tee -a' visudo

USER ${user}
ENV AGENT_WORKDIR=${AGENT_WORKDIR}
RUN mkdir /home/${user}/.jenkins && mkdir -p ${AGENT_WORKDIR}

VOLUME /home/${user}/.jenkins
VOLUME ${AGENT_WORKDIR}
WORKDIR /home/${user}

USER root
RUN curl "https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip" -o "awscliv2.zip"
RUN unzip awscliv2.zip \
  && ./aws/install -i /usr/local/aws-cli -b /usr/local/bin

ENTRYPOINT ["/usr/local/bin/jenkins-slave"]
