output "this_autoscaling_group" {
  description = "the autoscaling group"
  value       = alicloud_ess_scaling_group.ess_group
}

output "this_autoscaling_group_config" {
  description = "the autoscaling group config"
  value       = alicloud_ess_scaling_configuration.this
}

output "this_slb_listener" {
  description = "the slb"
  value       = alicloud_slb_listener.lb_listener
}