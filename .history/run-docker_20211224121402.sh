#!/bin/bash

# Create the container, with uid & gid same as the outer user as you will need to mount directories internal to the docker with permissions at access files.
docker build  \
  --tag iw-tech-test-terraform-azure \
  --build-arg USER_UID=$(id -u) \
  --build-arg USER_GID=$(id -g) \
   .devcontainer

# create a local bash history file outside of the container to persist terminal history.
touch $HOME/.iw_tech_test_terraform_azure_bash_history

# Run the container mounting folders.
docker run --interactive --tty \
  --mount type=bind,source="$HOME/.iw_tech_test_terraform_azure_bash_history",target="/home/vscode/.bash_history" \
  --mount type=bind,source="$HOME/.ssh",target="/home/vscode/.ssh" \
  --mount type=bind,source="$(pwd)",target="/workspaces/iw-tech-test-terraform-azure" \
  --user vscode \
  iw-tech-test-terraform-azure
