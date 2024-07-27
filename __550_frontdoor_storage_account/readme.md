<!-- https://github.com/Azure/terraform/blob/master/quickstart/101-front-door-premium-storage-blobs-private-link -->

# Azure Front Door Premium with blob origin and Private Link

This quickstart deploys an [Azure Front Door Premium profile](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/cdn_frontdoor_profile) with an Azure Storage blob container origin, using a private endpoint to access the storage account.

## Architecture

![Architecture diagram showing traffic flowing through Front Door to the storage account.](images/diagram.png)

The data flows through the solution are:

1. The client establishes a connection to Azure Front Door by using a custom domain name. The client's connection terminates at a nearby Front Door point of presence (PoP).
1. The Front Door web application firewall (WAF) scans the request. If the WAF determines the request's risk level is too high, it blocks the request and Front Door returns an HTTP 403 error response.
1. If the Front Door PoP's cache contains a valid response for this request, Front Door returns the response immediately.
1. Otherwise, the PoP sends the request to the origin storage account, wherever it is in the world, by using Microsoft's backbone network. The PoP connects to the storage account by using a separate, long-lived, TCP connection. In this scenario, Private Link is used to securely connect to the storage account.
1. The storage account sends a response to the Front Door PoP.
1. When the PoP receives the response, it stores it in its cache for subsequent requests.
1. The PoP returns the response to the client.
1. Any requests directly to the storage account through the internet are blocked by the Azure Storage firewall.

## Usage

### Approve custom domain

After you deploy the Terraform file, you need to validate your ownership of the custom domain by updating your DNS server. You must create a TXT record with the name specified in the `customDomainValidationDnsTxtRecordName` deployment output, and use the value specified in the `customDomainValidationDnsTxtRecordValue` deployment output. You must the validation before the time specified in the `customDomainValidationExpiry` deployment output.

Front Door validates your domain ownership and updates the status automatically. You can monitor the validation process, or trigger an immediate validation, in the domain configuration in the Azure portal.

Next, you should configure your DNS server with a CNAME record to direct the traffic to Front Door. You must create a CNAME record at the host name you specified in the `customDomainName` deployment parameter, and use the value specified in the `frontDoorEndpointHostName` deployment output.

### Approve private endpoint connection

You need to approve the private endpoint connection to your storage account. This step is necessary because the private endpoint created by Front Door is deployed into a Microsoft-owned Azure subscription, and cross-subscription private endpoint connections require explicit approval. To approve the private endpoint:

1. Open the Azure portal and navigate to the storage account.
2. Click the **Networking** tab, and then click the **Private endpoint connections** tab.
3. Select the private endpoint that is awaiting approval, and click the **Approve** button. This can take a couple of minutes to complete.

After approving the private endpoint, wait a few minutes before you attempt to access your Front Door endpoint to allow time for Front Door to propagate the settings throughout its network.

### Access the storage account

You can then access the Front Door endpoint. The hostname is emitted as an output from the deployment - the output is named `frontDoorEndpointHostName`. You should see a page saying _The specified resource does not exist_. This is returned by Azure Storage because no files have been uploaded to the blob container and therefore there is no content to show yet. If you see a different error page, wait a few minutes and try again.

You can also attempt to access the Azure Storage blob hostname directly. The hostname is also emitted as an output from the deployment - the output is named `blobEndpointHostName`. You should see an error saying _This request is not authorized to perform this operation_ error, since your storage account is configured to not accepts requests that come from the internet.

## Resources

| Terraform Resource Type | Description |
| - | - |
| `azurerm_resource_group` | The resource group for all the deployed resources.|
| `azurerm_cdn_frontdoor_profile` | The Front Door profile. |
| `azurerm_cdn_frontdoor_endpoint` | The Front Door endpoint. |
| `azurerm_cdn_frontdoor_origin_group` | The Front Door origin group. |
| `azurerm_cdn_frontdoor_origin` | The Front Door origin, which refers to the storage account. |
| `azurerm_cdn_frontdoor_route` | The Front Door route. |
| `azurerm_cdn_frontdoor_custom_domain` | The Front Door custom domain. See above for details on custom domain provisioning. |
| `azurerm_cdn_frontdoor_firewall_policy` | The WAF policy. |
| `azurerm_cdn_frontdoor_security_policy` | The Front Door security policy, which associates the WAF policy with the custom domain. |
| `azurerm_storage_account` | The Azure Storage account. |
| `azapi_resource` | The blob container within the Azure Storage account. |
| `random_id` | Two random identifier generators to generate a unique Front Door endpoint resource name and storage account name. |

## Variables

| Name | Description | Default Value |
|-|-|-|
| `location` | The location for all the deployed resources. | `westus3` |
| `front_door_private_link_location` | The location that the Private Link connection will terminate in when connecting to the origin. This must be one of the [locations in which Private Link origins are available for Front Door](https://learn.microsoft.com/azure/frontdoor/private-link#region-availability). | `westus3` |
| `resource_group_name` | The name of the resource group. | `FrontDoor` |
| `storage_account_tier` | The tier of the storage account. | `Standard` |
| `storage_account_replication_type` | The level of replication to be configured for the storage account. | `LRS` |
| `storage_account_blob_container_name` | The name of the blob container. | `mycontainer` |
| `waf_mode` | The mode that the WAF should be deployed using. In 'Prevention' mode, the WAF will block requests it detects as malicious. In 'Detection' mode, the WAF will not block requests and will simply log the request.' | `Prevention` |
| `custom_domain_name` | The custom domain name to associate with your Front Door endpoint. | |
