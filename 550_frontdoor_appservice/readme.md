# Exposing Azure App Service using Front Door

## Objective

In this lab, you will learn how to use Azure Front Door to expose an Azure App Service. We will use Terraform to automate the deployment of the necessary resources.

## Prerequisites

- An Azure subscription
- Terraform installed on your local machine
- Basic knowledge of Terraform and Azure services

## Deploying the solution

Run the following commands to deploy the solution using `terraform`:

```sh
terraform init
terraform plan -out=tfplan
terraform apply tfplan
```

## Conclusion
By following these steps, you have successfully exposed an Azure App Service using Azure Front Door with Terraform.