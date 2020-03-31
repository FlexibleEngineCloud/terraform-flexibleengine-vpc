output "snat_eip" {
  description = "The Public IP adress of the SNAT rule"
  value       = module.vpc.snat_eip
}

output "gateway_id" {
  description = "ID of NAT gateway"
  value       = module.vpc.gateway_id
}

output "subnet_ids" {
  description = "List of IDs of the created subnets with snat rule"
  value       = module.vpc.snat_eip
}

output "vpc_id" {
  description = "The Public IP adress of the SNAT rule"
  value       = module.vpc.vpc_id
}
