# OPNsense Firewall with Load Balancer for inbound and outbound traffic

## Learnings

"The Load balancer will use the next IP once the connections can no longer be made with the current IP in use."
"The outbound rule will automatically use other public IP addresses contained within the public IP prefix after no more outbound connections can be made with the current IP in use from the prefix."
Src: https://learn.microsoft.com/en-us/azure/load-balancer/outbound-rules#scale

The Load Balancer will not distribute evenly the traffic between the multiple IPs of the LB's frontend.
