module "vpc" {
  source = "../.."
  vpc_name = "vpc_example"
  vpc_cidr = "10.0.0.0/16"

  vpc_subnets = [
    {
      subnet_name       = "subnet-0"
      subnet_cidr       = "10.0.1.0/24"
      subnet_gateway_ip = "10.0.1.1"
    },
    {
      subnet_name       = "subnet-1"
      subnet_cidr       = "10.0.2.0/24"
      subnet_gateway_ip = "10.0.2.1"
    },
  ]

  vpc_snat_subnets = ["subnet-0"]

  enable_nat_gateway = true
  existing_eip_id         = "<EIP_ID>"
  eip_bandwidth = 500
  nat_gateway_name = "natg-0"
  nat_gateway_type = "1"
  nat_gateway_subnet_name = "subnet-0"
}
