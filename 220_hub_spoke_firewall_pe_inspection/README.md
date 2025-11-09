# Introduction to Azure Firewall

![](images/architecture.png)

## Deploy terraform template

```sh
terraform init
terraform apply -auto-apply
```

curl 10.2.1.4 --header 'Host: inspector-gadget.yellowriver-98afd79e.swedencentral.azurecontainerapps.io'

sudo docker run -d -p 80:80 jelledruyts/inspectorgadget

 curl 10.2.2.5/api/introspector | jq .request[7]


## More resources

Exploring Private Endpoint routing in Azure: https://denishartl.com/2025/10/17/exploring-private-endpoint-routing-in-azure/