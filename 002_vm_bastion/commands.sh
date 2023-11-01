# cd into the current directory

terraform init

terraform plan -out tfplan

terraform apply tfplan

terraform destroy -auto-approve

# connect to an azure vm through bastion

hostname -i 

curl localhost

curl 10.0.1.4