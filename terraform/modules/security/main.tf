locals {
  security_group_name = var.security_group_name != "" ? var.security_group_name : "terraform-security-group-${random_uuid.this.result}"
}

resource "random_uuid" "this" {}

resource "alicloud_security_group" "this" {
  name        = local.security_group_name
  description = "Managed by Terrraform"
  vpc_id      = var.vpc_id
  tags        = var.tags
}

resource "alicloud_security_group_rule" "ingress" {
  for_each = { for i in var.ingress_rule : i.port_range => i }

  type                      = "ingress"
  description               = "Managed by Terraform"
  ip_protocol               = lookup(each.value, "ip_protocol", null)
  port_range                = lookup(each.value, "port_range", "-1/-1")
  nic_type                  = lookup(each.value, "nic_type", "internet")
  policy                    = lookup(each.value, "policy", "accept")
  priority                  = lookup(each.value, "priority", 1)
  source_security_group_id  = lookup(each.value, "nic_type", "internet") == "intranet" ? lookup(each.value, "source_security_group_id", null) : null
  security_group_id         = alicloud_security_group.this.id
  cidr_ip                   = lookup(each.value, "cidr_ip", null)
}

resource "alicloud_security_group_rule" "egress" {
  for_each = { for i in var.egress_rule : i.port_range => i }

  type                      = "egress"
  description               = "Managed by Terraform"
  ip_protocol               = lookup(each.value, "ip_protocol", null)
  port_range                = lookup(each.value, "port_range", "-1/-1")
  nic_type                  = lookup(each.value, "nic_type", "internet")
  policy                    = lookup(each.value, "policy", "accept")
  priority                  = lookup(each.value, "priority", 1)
  source_security_group_id  = lookup(each.value, "nic_type", "internet") == "intranet" ? lookup(each.value, "source_security_group_id", null) : null
  security_group_id         = alicloud_security_group.this.id
  cidr_ip                   = lookup(each.value, "cidr_ip", null)
}
