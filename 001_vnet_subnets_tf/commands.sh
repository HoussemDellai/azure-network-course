# cd into the current directory

terraform init

terraform plan -out tfplan

terraform apply tfplan

terraform destroy -auto-approve