locals {
  scaling_group_name              = var.scaling_group_name != "" ? var.scaling_group_name : "terraform-ess-group-${random_uuid.this.result}"
  scaling_configuration_name      = var.scaling_configuration_name != "" ? var.scaling_configuration_name : "terraform-ess-configuration-${random_uuid.this.result}"
  lifecycle_hook_name             = var.lifecycle_hook_name != "" ? var.lifecycle_hook_name : "terraform-ess-hook-${random_uuid.this.result}"
  scaling_rule_name               = var.scaling_rule_name != "" ? var.scaling_rule_name : "terraform-ess-rule-${random_uuid.this.result}"
  scaling_alarm_name              = var.scaling_alarm_name != "" ? var.scaling_alarm_name : "terraform-ess-alarm-${random_uuid.this.result}"
}

resource "random_uuid" "this" {}

resource "alicloud_slb_server_group" "lb_group" {
  load_balancer_id = var.loadbalancer_id
  name             = "${var.scaling_group_name}-server-group-${random_uuid.this.result}"
}

resource "alicloud_slb_listener" "lb_listener" {
  frontend_port             = var.frontend_port
  backend_port              = var.backend_port
  load_balancer_id          = var.loadbalancer_id
  protocol                  = "http"
  health_check              = "on"
  health_check_uri          = "/"
  health_check_connect_port = var.backend_port
  healthy_threshold         = 8
  unhealthy_threshold       = 8
  health_check_timeout      = 100
  health_check_interval     = 5
  health_check_http_code    = "http_2xx,http_3xx"
  x_forwarded_for {
    retrive_slb_ip = true
    retrive_slb_id = true
  }
  request_timeout = 80
  idle_timeout    = 30
  bandwidth                 = var.internet_max_bandwidth_in
  server_group_id           = alicloud_slb_server_group.lb_group.id
}

resource "alicloud_ess_scalinggroup_vserver_groups" "this" {
  scaling_group_id      = alicloud_ess_scaling_group.ess_group.id
  vserver_groups {
    loadbalancer_id = var.loadbalancer_id
    vserver_attributes {
      port             = var.backend_port
      vserver_group_id = alicloud_slb_server_group.lb_group.id
      weight           = var.weight
    }
  }
}

resource "alicloud_ess_scaling_group" "ess_group" {
  scaling_group_name                       = local.scaling_group_name
  max_size                                 = var.max_size
  min_size                                 = var.min_size
  desired_capacity                         = var.desired_capacity
  default_cooldown                         = var.default_cooldown
  vswitch_ids                              = length(var.vswitch_ids) > 0 ? var.vswitch_ids : null
  removal_policies                         = var.removal_policies
  loadbalancer_ids                         = [var.loadbalancer_id]
  multi_az_policy                          = var.multi_az_policy
  on_demand_base_capacity                  = var.on_demand_base_capacity
  on_demand_percentage_above_base_capacity = var.on_demand_percentage_above_base_capacity
  spot_instance_pools                      = var.spot_instance_pools
  spot_instance_remedy                     = var.spot_instance_remedy
}

resource "alicloud_ess_scaling_configuration" "this" {
  scaling_group_id           = alicloud_ess_scaling_group.ess_group.id
  image_id                   = var.image_id
  instance_types             = var.instance_types
  security_group_ids         = var.security_group_ids
  instance_name              = var.instance_name
  scaling_configuration_name = local.scaling_configuration_name
  internet_charge_type       = var.internet_charge_type
  internet_max_bandwidth_in  = var.internet_max_bandwidth_in
  internet_max_bandwidth_out = var.associate_public_ip_address ? var.internet_max_bandwidth_out : 0
  system_disk_category       = var.system_disk_category
  system_disk_size           = var.system_disk_size
  enable                     = var.enable
  active                     = var.active
  user_data                  = base64encode(var.user_data)
  key_name                   = var.key_name
  role_name                  = var.role_name
  force_delete               = var.force_delete
  password_inherit           = var.password_inherit
  password                   = var.password_inherit == true ? "" : var.password
  tags                       = var.tags
  dynamic "data_disk" {
    for_each = var.data_disks
    content {
      delete_with_instance = lookup(data_disk.value, "delete_with_instance", null)
      snapshot_id          = lookup(data_disk.value, "snapshot_id", null)
      size                 = lookup(data_disk.value, "size", null)
      category             = lookup(data_disk.value, "category", null)
    }
  }

  depends_on = [alicloud_ess_scaling_group.ess_group]
}

resource "alicloud_ess_lifecycle_hook" "this" {
  scaling_group_id      = alicloud_ess_scaling_group.ess_group.id
  name                  = local.lifecycle_hook_name
  lifecycle_transition  = var.lifecycle_transition
  heartbeat_timeout     = var.heartbeat_timeout
  default_result        = var.hook_action_policy
}

resource "alicloud_ess_scaling_rule" "scaling_rule" {
  scaling_group_id          = alicloud_ess_scaling_group.ess_group.id
  scaling_rule_name         = local.scaling_rule_name
  scaling_rule_type         = length(var.step_adjustments) > 0 ? "StepScalingRule" : "SimpleScalingRule"
  adjustment_type           = var.adjustment_type
  adjustment_value          = length(var.step_adjustments) > 0 ? null : var.adjustment_value
  cooldown                  = var.cooldown
  estimated_instance_warmup = var.estimated_instance_warmup
  dynamic "step_adjustment" {
    for_each = var.step_adjustments
    content {
      metric_interval_lower_bound = lookup(step_adjustment.value, "lower_limit", null)
      metric_interval_upper_bound = lookup(step_adjustment.value, "upper_limit", null)
      scaling_adjustment          = lookup(step_adjustment.value, "adjustment_value", null)
    }
  }

  depends_on = [alicloud_ess_scaling_configuration.this]
}

resource "alicloud_ess_alarm" "this" {
  scaling_group_id    = alicloud_ess_scaling_group.ess_group.id
  name                = local.scaling_alarm_name
  description         = "An alarm task managed by Terraform"
  enable              = var.alarm_enable
  alarm_actions       = [alicloud_ess_scaling_rule.scaling_rule.ari]
  metric_type         = var.alarm_task_metric_type
  metric_name         = var.alarm_task_metric_name
  period              = lookup(var.alarm_task_setting, "period", null)
  statistics          = lookup(var.alarm_task_setting, "method", null)
  threshold           = lookup(var.alarm_task_setting, "threshold", null)
  comparison_operator = lookup(var.alarm_task_setting, "comparison_operator", null)
  evaluation_count    = lookup(var.alarm_task_setting, "trigger_after", null)
}
