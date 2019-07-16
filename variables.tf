variable "create_vpc" {
  description = "Controls if VPC should be created (it affects almost all resources)"
  default     = true
}

variable "vpc_name" {
  description = "Name of the VPC to create"
  default     = ""
}

variable "vpc_cidr" {
  description = "The CIDR for the VPC. Default value is a valid CIDR, but not acceptable by FlexibleEngine and should be overridden"
  default     = "10.0.0.0/16"
}

variable "vpc_subnets" {
  description = "json description of subnets to create"
  default     = []
}

variable "vpc_snat_subnets" {
  description = "json name description of subnets included in SNAT rules"
  default     = [""]
}

variable "primary_dns" {
  description = "IP address of primary DNS"
  default     = "100.125.0.41"
}

variable "secondary_dns" {
  description = "IP address of secondary DNS"
  default     = "100.126.0.41"
}

variable "enable_nat_gateway" {
  description = "Should be true if you want to provision NAT Gateways for your networks"
  default     = false
}

variable "nat_gateway_name" {
  description = "Name of the NAT gateway"
  default     = ""
}

variable "nat_gateway_type" {
  description = "Type of NAT gateway. 4 values (1,2,3,4). 1 is small type, and 4 the Extra-large"
  default     = "1"
}

variable "nat_gateway_subnet_name" {
  description = "Name of subnet used by the NAT Gateway"
  default     = ""
}

variable "eip_pool_name" {
  description = "Name of eip pool"
  default     = "admin_external_net"
}
