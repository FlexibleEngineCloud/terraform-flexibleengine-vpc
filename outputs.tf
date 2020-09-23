output "vpc_id" {
  description = "ID of the created vpc"
  value       = flexibleengine_vpc_v1.vpc[0].id
}

output "vpc_name" {
  description = "Name of the created vpc"
  value       = flexibleengine_vpc_v1.vpc[0].name
}

output "subnet_ids" {
  description = "list of IDs of the created subnets"
  value       = [for subnet in flexibleengine_vpc_subnet_v1.vpc_subnets : subnet.subnet_id]
}

output "gateway_id" {
  description = "id of NAT gateway"
  value       = flexibleengine_nat_gateway_v2.nat_gateway.*.id
}

output "network_ids" {
  description = "list of IDs of the created networks"
  value       = [for subnet in flexibleengine_vpc_subnet_v1.vpc_subnets : subnet.id]
}

output "snat_eip" {
  description = "The Public IP adress of the SNAT rule"
  value       = var.new_eip ? [for publicip in flexibleengine_vpc_eip_v1.new_eip.*.publicip : lookup(element(publicip, 0), "ip_address")] : null
}
