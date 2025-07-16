# Azure Virtual Wan and Virtual Hub

In this lab you will explore `Azure Virtual WAN` and `Virtual Hub` with two hubs, each with a firewall. The focus is on understanding how traffic flows between VNets in different hubs when firewalls are configured.

![architecture](./images/architecture.png)

## Deploying the resources

To deploy the resources, run the following commands:

```sh
$env:ARM_SUBSCRIPTION_ID=(az account show --query id -o tsv)

terraform init
terraform apply -auto-approve
```

This will take about 45 minutes. Then the following resources will be created:

![resources](./images/resources.png)

## Testing connection from Spoke VNET01 to VNET02 in Hub01

To check that VNETs in the same `virtual Hub` can communicate, you can use the VM Spoke01 in Hub01 to ping the VM in Spoke02 in the same hub. And as each VM exposes an Nginx app, you can also access the Nginx app in Spoke02 from Spoke01 using the curl command. 

From VM Spoke01, navigate to `run command` feature and run the following:

```sh
# Ping the VM in Spoke02
ping 10.2.0.4

# Access the Nginx app in Spoke02
curl 10.2.0.4
```

You should see a response from the Nginx app running on the VM in Spoke02.

Do the same from VM Spoke02 to Spoke01:

```sh
# Ping the VM in Spoke01
ping 10.2.0.4

# Access the Nginx app in Spoke01
curl 10.2.0.4
```

## Testing connection from Hub01 VNET01 to Hub02 VNET03

Now we want to check if the VNETs in different hubs can communicate. From VM Spoke01 in Hub01, you can ping the VM in Spoke03 in Hub02 and access its Nginx app.

From VM Spoke01, run the following commands:

```sh
# Ping the VM in Spoke03
ping 10.3.0.4

# Access the Nginx app in Spoke03
curl 10.3.0.4
```

You should see a response from the Nginx app running on the VM in Spoke03.

## Learnings

* Without Firewall and without Route Table, the traffic between VNets in the same and across Virtual Hubs is allowed.

