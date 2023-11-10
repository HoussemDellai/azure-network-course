# Azure Route Table and UDR

## Introduction

You will learn how to use Route Table and create custom routes.

## Deploy the demo lab

The demo lab is shown on the following architecture diagram.
![](images/architecture.png)

It is scripted in Terraform. 
To deploy it, simply run the terraform commands.

```sh
terraform init
terraform apply -auto-approve
```

The deployment will take about 13 minutes.
After that, you will be ready to connect to the VMs.

## Clean up resources

```sh
terraform destroy -auto-approve
```