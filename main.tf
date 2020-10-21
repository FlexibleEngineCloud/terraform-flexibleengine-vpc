### VPC creation
resource "flexibleengine_vpc_v1" "vpc" {
  # Create the VPC
  count = var.create_vpc ? 1 : 0

  name = var.vpc_name
  cidr = var.vpc_cidr
}

resource "flexibleengine_vpc_subnet_v1" "vpc_subnets" {
  # Create subnets
  for_each = local.vpc_subnets_map
  
  name          = each.value.subnet_name
  cidr          = each.key
  gateway_ip    = each.value.subnet_gateway_ip
  primary_dns   = var.primary_dns
  secondary_dns = var.secondary_dns
  vpc_id        = flexibleengine_vpc_v1.vpc[0].id
}

### NAT Gateway creation
data "flexibleengine_vpc_subnet_v1" "nat_gateway_subnet" {
  count      = var.create_vpc && var.enable_nat_gateway ? 1 : 0
  name       = var.nat_gateway_subnet_name
  depends_on = [flexibleengine_vpc_subnet_v1.vpc_subnets]
}

resource "flexibleengine_nat_gateway_v2" "nat_gateway" {
  # Create the NAT Gateway
  count = var.create_vpc && var.enable_nat_gateway ? 1 : 0

  name                = var.nat_gateway_name
  spec                = var.nat_gateway_type
  router_id           = flexibleengine_vpc_v1.vpc[0].id
  internal_network_id = data.flexibleengine_vpc_subnet_v1.nat_gateway_subnet[0].id

  lifecycle {
    ignore_changes = [internal_network_id]
  }
}

locals {
 
  vpc_subnets_keys = [for subnet in var.vpc_subnets : subnet.subnet_cidr]
  vpc_subnets_values = [for subnet in var.vpc_subnets : subnet]
  vpc_subnets_map = zipmap(local.vpc_subnets_keys, local.vpc_subnets_values)

  # vpc_snat_subnets_map_network_id = zipmap(var.vpc_snat_subnets, var.vpc_snat_subnets)
  # vpc_snat_subnets_map_network_id = zipmap(local.vpc_subnets_keys, local.vpc_subnets_keys)
  vpc_subnets_cidr = [for subnet_name in var.vpc_snat_subnets : [for subnet in var.vpc_subnets : (lookup(var.vpc_subnets, subnet_name))]]
  vpc_subnets_cidr_map = zipmap(local.vpc_subnets_cidr, local.vpc_subnets_cidr)

}

resource "flexibleengine_vpc_eip_v1" "new_eip" {
  # Create the EIP for SNAT rule
  count = var.create_vpc && var.enable_nat_gateway && var.new_eip ? 1 : 0
  publicip {
    type = "5_bgp"
  }
  bandwidth {
    name        = "bandwidth-${var.nat_gateway_name}"
    size        = var.eip_bandwidth
    share_type  = "PER"
    charge_mode = "traffic"
  }
}

resource "flexibleengine_nat_snat_rule_v2" "snat" {
  # Create SNAT Rules
  # for_each = local.vpc_snat_subnets_map_network_id
  for_each = local.vpc_subnets_cidr_map
  
  nat_gateway_id = flexibleengine_nat_gateway_v2.nat_gateway[0].id
  network_id=flexibleengine_vpc_subnet_v1.vpc_subnets[each.value].id
  floating_ip_id = var.new_eip ? flexibleengine_vpc_eip_v1.new_eip[0].id : var.existing_eip_id
}
