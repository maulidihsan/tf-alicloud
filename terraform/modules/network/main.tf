# VPC Block
resource "alicloud_vpc" "vpc" {
  vpc_name          = var.vpc_name
  cidr_block        = var.vpc_cidr
  resource_group_id = var.resource_group_id
  description       = var.vpc_description
  tags              = var.vpc_tags
}

resource "alicloud_eip_address" "internet_access" {
  for_each             = local.vswitches
  address_name         = "${each.key}-eip"
}

resource "alicloud_eip_association" "eip_nat" {
  for_each      = local.vswitches
  allocation_id = alicloud_eip_address.internet_access[each.key].id
  instance_id   = alicloud_nat_gateway.nat[each.key].id
}

resource "alicloud_snat_entry" "default" {
  for_each          = local.vswitches
  snat_table_id     = alicloud_nat_gateway.nat[each.key].snat_table_ids
  source_vswitch_id = alicloud_vswitch.vswitch[each.key].id
  snat_ip           = alicloud_eip_address.internet_access[each.key].ip_address

  depends_on        = [alicloud_eip_association.eip_nat]
}

resource "alicloud_nat_gateway" "nat" {
  for_each         = local.vswitches

  vpc_id           = alicloud_vpc.vpc.id
  nat_gateway_name = "${var.vpc_name}-nat"
  payment_type     = "PayAsYouGo"
  nat_type         = "Enhanced"
  vswitch_id       = alicloud_vswitch.vswitch[each.key].id

  depends_on       = [alicloud_vswitch.vswitch]
}


# Subnet Block
locals {
  vswitches = {
    for x in var.vswitches : "${x.zone_id}-${x.vswitch_name}" => x
  }
  sg = {
    for x in var.security_groups : x.security_group_name => x
  }
}

resource "alicloud_vswitch" "vswitch" {
  for_each     = local.vswitches

  vswitch_name = each.value.vswitch_name
  cidr_block   = each.value.cidr_block
  zone_id      = each.value.zone_id

  description  = lookup(each.value, "description", null)
  tags         = var.vpc_tags
  vpc_id       = alicloud_vpc.vpc.id
}

module "security_group" {
  source       = "../security"
  for_each     = local.sg

  security_group_name     = each.key
  vpc_id                  = alicloud_vpc.vpc.id
  tags                    = lookup(each.value, "tags", null)
  ingress_rule            = lookup(each.value, "ingress_rule", [])
  egress_rule             = lookup(each.value, "egress_rule", [])
}
