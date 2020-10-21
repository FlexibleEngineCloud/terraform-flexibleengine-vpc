#!/bin/sh

command -v terraform >/dev/null 2>&1 || { echo >&2 "terraform required but it's not installed.  Aborting."; exit 1; }

DATE=$(date +%F_%H-%M)

echo
echo "Save current Terraform state to TerraformState_Save_${DATE}.tfstate "

terraform state pull > TerraformState_Save_${DATE}.tfstate

for resource in $(terraform state list | grep module.vpc.flexibleengine_vpc_subnet_v1.vpc_subnets)
do
	echo "Change ressource $resource to module.vpc.flexibleengine_vpc_subnet_v1.vpc_subnets[\"${INDEX_NAME}\"]"
	INDEX_NAME=$(terraform state show "$resource" | grep cidr | awk -F"= " '{print $2}' | tr -d "\"")
	terraform state mv "$resource" "module.vpc.flexibleengine_vpc_subnet_v1.vpc_subnets[\"${INDEX_NAME}\"]"
done

terraform plan
