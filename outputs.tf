output "vpc_id" {
  description = "ID of the created vpc"
  value       = flexibleengine_vpc_v1.vpc[0].id
}

output "subnet_ids" {
  description = "list of IDs of the created subnets"
  value       = flexibleengine_vpc_subnet_v1.vpc_subnets.*.subnet_id
}

output "gateway_id" {
  description = "id of NAT gateway"
  value       = flexibleengine_nat_gateway_v2.nat_gateway.*.id
}

output "network_ids" {
  description = "list of IDs of the created networks"
  value       = flexibleengine_vpc_subnet_v1.vpc_subnets.*.id
}

