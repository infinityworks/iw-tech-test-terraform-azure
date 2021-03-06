#-------------------------------------------------------------------------------------------------------------
# Copyright (c) Microsoft Corporation. All rights reserved.
# Licensed under the MIT License. See https://go.microsoft.com/fwlink/?linkid=2090316 for license information.
#-------------------------------------------------------------------------------------------------------------

# Pick any base image, but if you select node, skip installing node. 😊
FROM debian:10

# Avoid warnings by switching to noninteractive
ENV DEBIAN_FRONTEND=noninteractive

# Terraform and tflint versions
ARG TERRAFORM_VERSION=1.1.2
ARG TFLINT_VERSION=0.15.4

# This Dockerfile adds a non-root user with sudo access. Use the "remoteUser"
# property in devcontainer.json to use it. On Linux, the container user's GID/UIDs
# will be updated to match your local UID/GID (when using the dockerFile property).
# See https://aka.ms/vscode-remote/containers/non-root-user for details.
ARG USERNAME=vscode
ARG USER_UID=1000
ARG USER_GID=$USER_UID

# Configure apt and install packages
RUN apt-get update \
    && apt-get -y install --no-install-recommends apt-utils dialog 2>&1 \
    #
    # install git iproute2, required tools installed
    && apt-get install -y \
    bash-completion \
    git \
    openssh-client \
    less \
    curl \
    fd-find \
    ripgrep \
    procps \
    unzip \
    apt-transport-https \
    ca-certificates \
    gnupg-agent \
    software-properties-common \
    python3-pip \
    lsb-release 2>&1
    # Install Docker CE CLI.
    #
RUN curl -fsSL https://download.docker.com/linux/$(lsb_release -is | tr '[:upper:]' '[:lower:]')/gpg | apt-key add - 2>/dev/null \
    & add-apt-repository "deb [arch=$(dpkg --print-architecture)] https://download.docker.com/linux/$(lsb_release -is | tr '[:upper:]' '[:lower:]') $(lsb_release -cs) stable" \
    && apt-get update \
    && apt-get install -y docker-ce-cli
RUN pip3 install tabulate
    # Azure CLI
    #
COPY library-scripts/*.sh /tmp/library-scripts/
RUN ./tmp/library-scripts/azcli-debian.sh
    # Install Terraform, tflint, and graphviz
    #
RUN mkdir -p /tmp/docker-downloads \
    && curl -sSL -o /tmp/docker-downloads/terraform.zip https://releases.hashicorp.com/terraform/${TERRAFORM_VERSION}/terraform_${TERRAFORM_VERSION}_linux_amd64.zip \
    && unzip /tmp/docker-downloads/terraform.zip \
    && mv terraform /usr/local/bin \
    && curl -sSL -o /tmp/docker-downloads/tflint.zip https://github.com/wata727/tflint/releases/download/v${TFLINT_VERSION}/tflint_linux_amd64.zip \
    && unzip /tmp/docker-downloads/tflint.zip \
    && mv tflint /usr/local/bin \
    && cd ~ \
    && rm -rf /tmp/docker-downloads \
    && apt-get install -y graphviz \
    && apt-get install -y jq
    # And Adrian's fork of `terraform-lsp`
    #
RUN curl -sL https://github.com/awilkins/terraform-lsp/releases/download/v0.0.11-beta1-atw/terraform-lsp_0.11-beta1-atw_linux_amd64.tar.gz | tar -xz -C /usr/local/bin/
    # Create a non-root user to use if preferred - see https://aka.ms/vscode-remote/containers/non-root-user.
    #
RUN groupadd --gid $USER_GID $USERNAME \
    && useradd -s /bin/bash --uid $USER_UID --gid $USER_GID -m $USERNAME
    # Alias for fd
    #
RUN echo "alias fd=fdfind" >> /home/${USERNAME}/.bashrc
    # Starship prompt
    #
RUN curl -fsSL https://starship.rs/install.sh | sh -s -- --yes \
    && echo 'eval "$(starship init bash)"' >> /home/$USERNAME/.bashrc \
    && echo 'source <(awless completion bash)' >> /home/$USERNAME/.bashrc
    # git-secrets to help prevent committing secrets to git
    #
RUN mkdir -p /tmp/secrets && cd /tmp/secrets \
    && git clone https://github.com/awslabs/git-secrets.git \
    && cd git-secrets \
    && make install
    # [Optional] Add sudo support for the non-root user
    #
RUN apt-get install -y sudo \
    && echo $USERNAME ALL=\(root\) NOPASSWD:ALL > /etc/sudoers.d/$USERNAME\
    && chmod 0440 /etc/sudoers.d/$USERNAME
    # Clean up
    #
RUN apt-get autoremove -y \
    && apt-get clean -y \
    && rm -rf /var/lib/apt/lists/*
    # Install BpyTop
    #
RUN pip3 install bpytop

RUN git secrets --install ~/.git-templates/git-secrets \
    && git config --global init.templateDir ~/.git-templates/git-secrets

# Switch back to dialog for any ad-hoc use of apt-get
ENV DEBIAN_FRONTEND=dialog
# Command line use of git needs an editor
ENV EDITOR=code

RUN mkdir --parent /workspaces/iw-tech-test-terraform-azure /home/vscode/.terraform.d/plugin-cache
RUN chmod 777 --recursive /home/vscode/.terraform.d/plugin-cache