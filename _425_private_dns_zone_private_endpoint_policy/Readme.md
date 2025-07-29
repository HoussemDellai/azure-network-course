# Automating records creation with Azure Policy


Trigger a policy compliance evaluation for a scope.

```sh
az policy state trigger-scan
```

> Note that deleting the Policy assignment deletes the remediation as well. This means the DNS records will be removed in our scenario.