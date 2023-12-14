az group create -n rg-pip-prefix -l westeurope

az network public-ip prefix create --length 28 -l westeurope -n pip-prefix-demo -g rg-pip-prefix

az network public-ip create -g rg-pip-prefix -n pip-demo-01 --ip-address 172.201.45.128 --public-ip-prefix pip-prefix-demo

az network public-ip create -g rg-pip-prefix -n pip-demo-02 --ip-address 172.201.45.129 --public-ip-prefix pip-prefix-demo

az network public-ip prefix show -n pip-prefix-demo -g rg-pip-prefix

az group delete -n rg-pip-prefix --no-wait --yes