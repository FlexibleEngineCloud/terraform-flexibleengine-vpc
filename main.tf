terraform {
  required_version = ">= 0.10.3" # introduction of Local Values configuration language feature
}

### VPC creation
resource "flexibleengine_vpc_v1" "vpc" {
  # Create the VPC
  count = "${var.create_vpc ? 1 : 0}"

  name = "${var.vpc_name}"
  cidr = "${var.vpc_cidr}"
}

resource "flexibleengine_vpc_subnet_v1" "vpc_subnets" {
  # Create subnets
  count = "${var.create_vpc && length(var.vpc_subnets) > 0 ? length(var.vpc_subnets) : 0}"

  name          = "${lookup(var.vpc_subnets[count.index], "subnet_name")}"
  cidr          = "${lookup(var.vpc_subnets[count.index], "subnet_cidr")}"
  gateway_ip    = "${lookup(var.vpc_subnets[count.index], "subnet_gateway_ip")}"
  primary_dns   = "${var.primary_dns}"
  secondary_dns = "${var.secondary_dns}"
  vpc_id        = "${flexibleengine_vpc_v1.vpc.id}"
}

### NAT Gateway creation
data "flexibleengine_vpc_subnet_v1" "nat_gateway_subnet" {
  count      = "${var.create_vpc && var.enable_nat_gateway ? 1 : 0}"
  name       = "${var.nat_gateway_subnet_name}"
  depends_on = ["flexibleengine_vpc_subnet_v1.vpc_subnets"]
}

resource "flexibleengine_nat_gateway_v2" "nat_gateway" {
  # Create the NAT Gateway
  count = "${var.create_vpc && var.enable_nat_gateway ? 1 : 0}"

  name                = "${var.nat_gateway_name}"
  spec                = "${var.nat_gateway_type}"
  router_id           = "${flexibleengine_vpc_v1.vpc.id}"
  internal_network_id = "${data.flexibleengine_vpc_subnet_v1.nat_gateway_subnet.id}"

  lifecycle = {
    ignore_changes = ["internal_network_id"]
  }
}

## SNAT rules
data "flexibleengine_vpc_subnet_v1" "snat_subnets" {
  # get the subnet ids of subnets in vpc_snat_subnets list
  count      = "${var.create_vpc && length(var.vpc_snat_subnets) > 0 ? length(var.vpc_snat_subnets) : 0}"
  name       = "${element(var.vpc_snat_subnets, count.index)}"
  depends_on = ["flexibleengine_vpc_subnet_v1.vpc_subnets"]
}

resource "flexibleengine_networking_floatingip_v2" "eip" {
  # Create the EIP for SNAT rule
  count = "${var.create_vpc && var.enable_nat_gateway ? 1 : 0}"

  pool = "${var.eip_pool_name}"
}

resource "flexibleengine_nat_snat_rule_v2" "snat" {
  # Create SNAT Rules
  count = "${var.create_vpc && length(var.vpc_snat_subnets) > 0 ? length(var.vpc_snat_subnets) : 0}"

  nat_gateway_id = "${flexibleengine_nat_gateway_v2.nat_gateway.id}"
  network_id     = "${element(data.flexibleengine_vpc_subnet_v1.snat_subnets.*.id, count.index)}"
  floating_ip_id = "${flexibleengine_networking_floatingip_v2.eip.id}"
}
