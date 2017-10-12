# Hadoop Infra Deployment

This project will set up a Hadoop cluster and install/configure Ambari server and agents by using Terraform.

### Prerequisites

- [Terraform](https://www.terraform.io/downloads.html)

### Configuration

Update the "\*.tfvars" files with the right parameters:
* Development params file: "./environments/development/variables/\*.tfvars"
* Production params file: "./environments/production/variables/\*.tfvars"

### Set-up and run

* Initialization
```
cd ./hadoop_dev
terraform init
```
* Plan/Deploy/Destroy development environment:
```
# PLAN
terraform plan \
-state="./environments/development/dev.state" \
-var-file="./environments/development/variables/global.tfvars" \
-var-file="./environments/development/variables/ambari_agent.tfvars" \
-var-file="./environments/development/variables/ambari_server.tfvars"

# APPLY 
terraform apply \
-state="./environments/development/dev.state" \
-var-file="./environments/development/variables/global.tfvars" \
-var-file="./environments/development/variables/ambari_agent.tfvars" \
-var-file="./environments/development/variables/ambari_server.tfvars"

# DESTROY
terraform destroy -force \
-state="./environments/development/dev.state" \
-var-file="./environments/development/variables/global.tfvars" \
-var-file="./environments/development/variables/ambari_agent.tfvars" \
-var-file="./environments/development/variables/ambari_server.tfvars"
```

* Plan/Deploy/Destroy production environment:
```
# PLAN
terraform plan \
-state="./environments/production/prod.state" \
-var-file="./environments/production/variables/global.tfvars" \
-var-file="./environments/production/variables/ambari_agent.tfvars" \
-var-file="./environments/production/variables/ambari_server.tfvars"

# APPLY 
terraform apply \
-state="./environments/production/prod.state" \
-var-file="./environments/production/variables/global.tfvars" \
-var-file="./environments/production/variables/ambari_agent.tfvars" \
-var-file="./environments/production/variables/ambari_server.tfvars"

# DESTROY
terraform destroy -force \
-state="./environments/production/prod.state" \
-var-file="./environments/production/variables/global.tfvars" \
-var-file="./environments/production/variables/ambari_agent.tfvars" \
-var-file="./environments/production/variables/ambari_server.tfvars"
```