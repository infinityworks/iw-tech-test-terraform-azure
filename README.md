# iw-tech-test-terraform-azure

Technical test for Engineers using azure terraform

## NB

Task is based of of Richard harper AWS techincal test and is work in progress 

Original repo https://github.com/infinityworks/iw-tech-test-terraform

Any feedback is welcome and encouraged

email: tom.atkinson@infinityworks.com

# Task

There is a web server here which is listening on port 80. Modify the Terraform configuration to make it high availability. Anything else to improve?

# Validation

Can withstand loss of an availability zone.
Reasonable security.

## DevContainer setup (VSCODE)

Install the extention `ms-vscode-remote.remote-containers`
Reopen the unbalaced directory in the container
wait... (approx 5 minutes) read the log

## Docker Setup (Generic IDE)

From the project folder execute `the run-docker'sh` script

```shell
./run-docker.sh
```

wait... (approx 5 minutes)

The workspace is mounted in the directory `/workspaces/iw-tech-test-terraform-azure/`

## Azure credentails (ACloud Guru sandbox)

> Login to Azure 

```shell
az login

```

This will open a broswer you will be provided with a username/password

Using the Azure CLI Find the Resource Group name 

```shell
az group list | jq -r ".[].name"
```

Update the `project.tf` file at line[1] to include the name returned from the Azure CLI

```code
data "azurerm_resource_group" "main-resource-group" {
  name = "x-xxxxxxx-playground-sandbox"
}
```
