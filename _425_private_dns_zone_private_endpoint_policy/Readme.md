# Automating records creation with Azure Policy


> Note that deleting the Policy assignment deletes the remediation as well. This means the DNS records will be removed in our scenario.

> Note that Azure triggers the policies every 24 hours. But you can manually trigger a compliance evaluation using the following command.

```sh
az policy state trigger-scan # trigger for all subscription
# OR
az policy state trigger-scan -g <resource-group-name> # trigger for a specific resource group
```