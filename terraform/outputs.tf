output "security_group_ids" {
  description = "sg id on vpc"
  value       = module.network.security_group_ids
}

output "compute" {
  description = "db connection"
  value       = module.compute
}

output "db_string" {
  description = "db connection"
  value       = module.db
}

output "website_access" {
  value = alicloud_slb_load_balancer.lb
}