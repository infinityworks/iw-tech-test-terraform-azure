# iw-tech-test-terraform-azure

The task will be provided to you as part of the interview process.

## DevContainer setup (VSCode)

Install the extention `ms-vscode-remote.remote-containers`
Reopen the unbalaced directory in the container
wait... (approx 5 minutes) read the log

## Docker Setup (Generic IDE)

From the project folder execute the `run-docker.sh` script

```shell
./run-docker.sh
```

wait... (approx 5 minutes)

The workspace is mounted in the directory `/workspaces/iw-tech-test-terraform-azure/`

## Azure credentails (ACloud Guru sandbox)

Prerequisites:
* Azure CLI
* jq
* Terraform 1.0 or above

> Login to Azure 

```shell
az login
```

This will open a browser. You will be provided with a username/password.

Using the Azure CLI, find the Resource Group name 

```shell
az group list | jq -r ".[].name"
```

Update the `project.tf` file at line[1] to include the name returned from the Azure CLI

```code
data "azurerm_resource_group" "main-resource-group" {
  name = "x-xxxxxxx-playground-sandbox"
}
```
