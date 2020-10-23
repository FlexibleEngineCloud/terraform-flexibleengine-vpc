#!/bin/sh

command -v terraform >/dev/null 2>&1 || { echo >&2 "terraform required but it's not installed.  Aborting."; exit 1; }

DATE=$(date +%F_%H-%M)

echo
echo "Save current Terraform state to TerraformState_Save_${DATE}.tfstate "

terraform state pull > TerraformState_Save_${DATE}.tfstate

display_changes() {
	for vpc_module_name in $(terraform state list -state TerraformState_Save_${DATE}.tfstate | grep flexibleengine_vpc_v1.vpc | awk -F"." '{print $2}')
	do

		for resource in $(terraform state list -state TerraformState_Save_${DATE}.tfstate | grep module.${vpc_module_name}.flexibleengine_vpc_subnet_v1.vpc_subnets)
		do
			echo
			INDEX_NAME=$(terraform state show -state TerraformState_Save_${DATE}.tfstate "$resource" | grep cidr | awk -F"= " '{print $2}' | tr -d "\"")
			echo "Old resource name: $resource"
			echo "New resource name: to module.${vpc_module_name}.flexibleengine_vpc_subnet_v1.vpc_subnets[\"${INDEX_NAME}\"]"
		done
	done
}

apply_changes() {
	for vpc_module_name in $(terraform state list -state TerraformState_Save_${DATE}.tfstate | grep flexibleengine_vpc_v1.vpc | awk -F"." '{print $2}')
	do

		for resource in $(terraform state list -state TerraformState_Save_${DATE}.tfstate | grep module.${vpc_module_name}.flexibleengine_vpc_subnet_v1.vpc_subnets)
		do
			echo
			echo "Change ressource $resource to module.${vpc_module_name}.flexibleengine_vpc_subnet_v1.vpc_subnets[\"${INDEX_NAME}\"]"
			INDEX_NAME=$(terraform state show -state TerraformState_Save_${DATE}.tfstate "$resource" | grep cidr | awk -F"= " '{print $2}' | tr -d "\"")
			terraform state mv "$resource" "module.${vpc_module_name}.flexibleengine_vpc_subnet_v1.vpc_subnets[\"${INDEX_NAME}\"]"
		done
	done
}

# Display the changes
display_changes

# Ask for apply
echo
echo "Do you want to apply these changes? (y|n)"
read answer
echo
case $answer in
	Y|y)
		apply_changes
		;;
	N|n)
		exit
		;;
	* )
		echo "Please answer \"y\" or \"n\"."
		;;
esac
