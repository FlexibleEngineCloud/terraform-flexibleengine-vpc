variable "create_vpc" {
  description = "Controls if VPC should be created (it affects almost all resources)"
  default     = true
  type        = bool
}

variable "vpc_name" {
  description = "Name of the VPC to create"
  default     = "vpc-main"
  type        = string
}

variable "vpc_cidr" {
  description = "The CIDR for the VPC. Default value is a valid CIDR, but not acceptable by FlexibleEngine and should be overridden"
  default     = "0.0.0.0/0"
  type        = string
}

variable "vpc_subnets" {
  description = "json description of subnets to create"
  default     = []
  type = list(object({
    subnet_name       = string
    subnet_cidr       = string
    subnet_gateway_ip = string
  }))
}

variable "vpc_snat_subnets" {
  description = "list of snat subnet names"
  default     = []
  type        = list
}

variable "primary_dns" {
  description = "IP address of primary DNS"
  default     = "100.125.0.41"
  type        = string
}

variable "secondary_dns" {
  description = "IP address of secondary DNS"
  default     = "100.126.0.41"
  type        = string
}

variable "enable_nat_gateway" {
  description = "Should be true if you want to provision NAT Gateways for your networks"
  default     = false
  type        = bool
}

variable "nat_gateway_name" {
  description = "Name of the NAT gateway"
  default     = ""
  type        = string
}

variable "nat_gateway_type" {
  description = "Type of NAT gateway. 4 values (1,2,3,4). 1 is small type, and 4 the Extra-large"
  default     = "1"
  type        = number
}

variable "nat_gateway_subnet_name" {
  description = "Name of subnet used by the NAT Gateway"
  default     = ""
  type        = string
}

variable "new_eip" {
  description = "Whether or not attach new Elastic IP (public IP) to NAT Gateway"
  default     = false
  type        = bool
}

variable "eip_bandwidth" {
  description = "Bandwidth of the EIP in Mbit/s"
  default     = null
  type        = number
}

variable "existing_eip_id" {
  description = "ID of an existing EIP"
  default     = null
  type        = string
}

variable "eip_pool_name" {
  description = "Name of eip pool"
  default     = "admin_external_net"
  type        = string
}
