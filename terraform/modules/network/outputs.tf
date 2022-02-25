output "vpc_id" {
  description = "vpc id"
  value       = alicloud_vpc.vpc.id
}

output "vpc_name" {
  description = "vpc name"
  value       = alicloud_vpc.vpc.name
}

output "cidr_block" {
  description = "vpc cidr block"
  value       = alicloud_vpc.vpc.cidr_block
}

output "vswitch_ids" {
  description = "vswitches id on vpc"
  value       = [for v in alicloud_vswitch.vswitch : v.id]
}

output "vswitch_cidrs" {
  description = "vswitches id on vpc"
  value       = [for v in alicloud_vswitch.vswitch : v.cidr_block]
}

output "security_group_ids" {
  description = "sg id on vpc"
  value       = [for sg in module.security_group : sg.id]
}
