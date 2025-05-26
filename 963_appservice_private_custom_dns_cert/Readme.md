# App Service Private Endpoint with Custom DNS and Certificate

This lab adresses the issue of using a private endpoint for an Azure App Service with a custom domain and certificate. In this case the verification of the custom domain name on the private DNS Zone will fail because the App Service is not publicly accessible. While waiting for a clean solution from Azure, the available solutions today are :

* Exposing the same custom domain name on a public DNS Zone to verify domain ownership there.

* Use `Application Gateway` in front of `App Service` to handle the domain verification.

This lab will explore the first solution.