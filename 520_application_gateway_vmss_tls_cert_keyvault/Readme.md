# Azure Application Gateway with TLS certificate in Key vault

![](images/architecture.png)

You need to register feature `EnableApplicationGatewayNetworkIsolation` using the following Azure CLI command before applying the Terraform code:

```sh
az feature register --name EnableApplicationGatewayNetworkIsolation --namespace Microsoft.Network
```

To deploy the resources, run the following commands in the directory containing the Terraform code:

```sh
terraform init
terraform apply -auto-approve
```
