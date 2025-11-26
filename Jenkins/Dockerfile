FROM jenkins/jenkins:lts

USER root

# Instalar dependencias y Docker CLI
RUN apt-get update && apt-get install -y \
    curl \
    apt-transport-https \
    ca-certificates \
    gnupg \
    lsb-release \
    docker.io

# Instalar kubectl (versión fija)
RUN curl -LO "https://dl.k8s.io/release/v1.32.0/bin/linux/amd64/kubectl" \
    && install -o root -g root -m 0755 kubectl /usr/local/bin/kubectl \
    && rm kubectl

USER jenkins
