# Flexible Engine VPC Terraform Module

Terraform module which creates VPC, subnets, NAT gateway resources and SNAT rules on Flexible Engine

## TF Version : 0.12

## Usage : Terraform

```hcl
module "vpc" {
  source = "modules/terraform-fe-vpc"

  vpc_name = "my-vpc"
  vpc_cidr = "10.0.0.0/16"

  vpc_subnets = [
    {
      subnet_name       = "my-public-subnet-1"
      subnet_cidr       = "10.0.1.0/24"
      subnet_gateway_ip = "10.0.1.1"
    },
    {
      subnet_name       = "my-public-subnet-2"
      subnet_cidr       = "10.0.2.0/24"
      subnet_gateway_ip = "10.0.2.1"
    },
    {
      subnet_name       = "my-private-subnet"
      subnet_cidr       = "10.0.3.0/24"
      subnet_gateway_ip = "10.0.3.1"
    },
  ]

  vpc_snat_subnets = [
    "my-public-subnet-1",
    "my-public-subnet-2"
  ]

  enable_nat_gateway      = true
  nat_gateway_name        = "my-nat-gateway"
  nat_gateway_type        = "1"
  nat_gateway_subnet_name = "my-public-subnet-1"
}
```

## Usage : Terragrunt

```hcl
################################
### Terragrunt Configuration ###
################################

terraform {
  source = "git::https://github.com/terraform-flexibleengine-modules/terraform-flexibleengine-vpc"

}

include {
  path = find_in_parent_folders()
}

##################
### Parameters ###
##################

inputs = {
  vpc_name = "vpc-main"
  vpc_cidr = "192.168.0.0/16"
  vpc_subnets = [
    {
      subnet_name       = "subnet-1"
      subnet_cidr       = "192.168.1.0/24"
      subnet_gateway_ip = "192.168.1.253"
    }
  ]
  vpc_snat_subnets = [
    "subnet-1"
  ]
  enable_nat_gateway      = true
  nat_gateway_name        = "nat-gateway-1"
  nat_gateway_type        = "1"
  nat_gateway_subnet_name = "subnet-1"
}

```

<!-- BEGINNING OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|:----:|:-----:|:-----:|
| create\_vpc | Controls if VPC should be created (it affects almost all resources) | bool | `"true"` | no |
| eip\_pool\_name | Name of eip pool | string | `"admin_external_net"` | no |
| enable\_nat\_gateway | Should be true if you want to provision NAT Gateways for your networks | bool | `"false"` | no |
| nat\_gateway\_name | Name of the NAT gateway | string | `""` | no |
| nat\_gateway\_subnet\_name | Name of subnet used by the NAT Gateway | string | `""` | no |
| nat\_gateway\_type | Type of NAT gateway. 4 values (1,2,3,4). 1 is small type, and 4 the Extra-large | number | `"1"` | no |
| primary\_dns | IP address of primary DNS | string | `"100.125.0.41"` | no |
| secondary\_dns | IP address of secondary DNS | string | `"100.126.0.41"` | no |
| vpc\_cidr | The CIDR for the VPC. Default value is a valid CIDR, but not acceptable by FlexibleEngine and should be overridden | string | `"0.0.0.0/0"` | no |
| vpc\_name | Name of the VPC to create | string | `"vpc-main"` | no |
| vpc\_snat\_subnets | json description of subnets included in SNAT rules | list(string) | `[]` | no |
| vpc\_subnets | json description of subnets to create | object | `[]` | no |

## Outputs

| Name | Description |
|------|-------------|
| gateway\_id | id of NAT gateway |
| network\_ids | list of IDs of the created networks |
| subnet\_ids | list of IDs of the created subnets |
| vpc\_id | ID of the created vpc |

<!-- END OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
