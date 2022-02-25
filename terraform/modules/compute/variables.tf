### IMAGE
variable "image_id" {
  description = "Image ID to be used."
  type        = string
  default     = "m-k1a2s10zs47rl5mq5tgr"
}

### ESS GROUP
variable "scaling_group_name" {
  description = "The name for autoscaling group. Default to a random string prefixed with `terraform-ess-group-`."
  type        = string
  default     = ""
}

variable "min_size" {
  description = "Minimum number of ECS instances in the scaling group"
  type        = number
  default     = 0
}

variable "max_size" {
  description = "Maximum number of ECS instance in the scaling group"
  type        = number
  default     = 2
}

variable "desired_capacity" {
  description = "Expected number of ECS instances in the scaling group."
  type        = number
  default     = 1
}

variable "default_cooldown" {
  description = "The amount of time (in seconds),after a scaling activity completes before another scaling activity can start"
  type        = number
  default     = 300
}

variable "vswitch_ids" {
  description = "List of virtual switch IDs in which the ecs instances to be launched."
  type        = list(string)
  default     = []
}

variable "removal_policies" {
  description = "RemovalPolicy is used to select the ECS instances you want to remove from the scaling group when multiple candidates for removal exist"
  type        = list(string)
  default = [
    "OldestScalingConfiguration",
    "OldestInstance",
  ]
}

variable "db_instance_ids" {
  description = "A list of rds instance ids to add to the autoscaling group. If not set, it can be retrieved automatically by specifying filter `rds_name_regex` or `rds_tags`."
  type        = list(string)
  default     = []
}

variable "loadbalancer_id" {
  description = "Load balancer id"
  type        = string
  default     = null
}

variable "multi_az_policy" {
  description = "Multi-AZ scaling group ECS instance expansion and contraction strategy. PRIORITY, BALANCE or COST_OPTIMIZED"
  type        = string
  default     = null
}

variable "on_demand_base_capacity" {
  description = "The minimum amount of the Auto Scaling group's capacity that must be fulfilled by On-Demand Instances. This base portion is provisioned first as your group scales."
  type        = number
  default     = null
}
variable "on_demand_percentage_above_base_capacity" {
  description = "Controls the percentages of On-Demand Instances and Spot Instances for your additional capacity beyond OnDemandBaseCapacity."
  type        = number
  default     = null
}
variable "spot_instance_pools" {
  description = "The number of Spot pools to use to allocate your Spot capacity. The Spot pools is composed of instance types of lowest price."
  type        = number
  default     = null
}
variable "spot_instance_remedy" {
  description = "Whether to replace spot instances with newly created spot/onDemand instance when receive a spot recycling message."
  type        = bool
  default     = null
}

### ESS CONFIG
variable "instance_types" {
  description = "A list of ECS instance types."
  type        = list(string)
  default     = ["ecs.t6-c1m2.large", "ecs.g7.large"]
}

variable "security_group_ids" {
  description = "List IDs of the security group to which a newly created instance belongs. If not set, it can be retrieved automatically by specifying filter `sg_name_regex` or `sg_tags`."
  type        = list(string)
  default     = []
}

variable "instance_name" {
  description = "Name of an ECS instance. Default to a random string prefixed with `terraform-ess-instance-`."
  type        = string
  default     = "ESS-Instance"
}

variable "scaling_configuration_name" {
  description = "Name for the autoscaling configuration. Default to a random string prefixed with `terraform-ess-configuration-`."
  type        = string
  default     = ""
}

variable "internet_charge_type" {
  description = "The ECS instance network billing type: PayByTraffic or PayByBandwidth."
  type        = string
  default     = "PayByTraffic"
}

variable "internet_max_bandwidth_in" {
  description = "Maximum incoming bandwidth from the public network"
  default     = 20
}

variable "internet_max_bandwidth_out" {
  description = "Maximum outgoing bandwidth from the public network. It will be ignored when `associate_public_ip_address` is false."
  type        = number
  default     = 0
}

variable "associate_public_ip_address" {
  description = "Whether to associate a public ip address with an instance in a VPC."
  type        = bool
  default     = false
}

variable "system_disk_category" {
  description = "Category of the system disk"
  type        = string
  default     = "cloud_efficiency"
}

variable "system_disk_size" {
  description = "Size of the system disk"
  type        = number
  default     = 20
}

variable "enable" {
  description = "Whether enable the specified scaling group(make it active) to which the current scaling configuration belongs."
  type        = bool
  default     = true
}

variable "active" {
  description = "Whether active current scaling configuration in the specified scaling group"
  type        = bool
  default     = true
}

variable "user_data" {
  description = "User-defined data to customize the startup behaviors of the ECS instance and to pass data into the ECS instance"
  type        = string
  default     = ""
}

variable "key_name" {
  description = "The name of key pair that login ECS"
  type        = string
  default     = ""
}

variable "role_name" {
  description = "Instance RAM role name"
  type        = string
  default     = ""
}

variable "force_delete" {
  description = "The last scaling configuration will be deleted forcibly with deleting its scaling group"
  type        = bool
  default     = true
}

variable "data_disks" {
  description = "Additional data disks to attach to the scaled ECS instance"
  type        = list(map(string))
  default     = []
}

variable "password_inherit" {
  description = "Specifies whether to use the password that is predefined in the image. If true, the `password` and `kms_encrypted_password` will be ignored. You must ensure that the selected image has a password configured."
  type        = bool
  default     = false
}

variable "password" {
  description = "The password of the ECS instance. It is valid when `password_inherit` is false"
  type        = string
  default     = ""
}

variable "tags" {
  description = "A mapping of tags used to create a new scaling configuration."
  type        = map(string)
  default     = {}
}

### SLB


variable "frontend_port" {
  description = "Front End Port"
  type        = number
  default     = 80
}

variable "backend_port" {
  description = "Back End Port"
  type        = number
  default     = 80
}

variable "weight" {
  description = "The weight of an ECS instance attached to the VServer Group."
  type        = number
  default     = 100
}


### ESS LIFECYCLE
variable "lifecycle_hook_name" {
  description = "The name for lifecyle hook. Default to a random string prefixed with `terraform-ess-hook-`."
  type        = string
  default     = ""
}

variable "lifecycle_transition" {
  description = "Type of Scaling activity attached to lifecycle hook. Supported value: SCALE_OUT, SCALE_IN."
  type        = string
  default     = "SCALE_OUT"
}

variable "heartbeat_timeout" {
  description = "Defines the amount of time, in seconds, that can elapse before the lifecycle hook times out. When the lifecycle hook times out, Auto Scaling performs the action defined in the default_result parameter."
  type        = number
  default     = 300
}

variable "hook_action_policy" {
  description = "Defines the action which scaling group should take when the lifecycle hook timeout elapses. Valid value: CONTINUE, ABANDON."
  type        = string
  default     = "CONTINUE"
}

### ESS SCALING RULE
variable "scaling_rule_name" {
  description = "The name for scaling rule. Default to a random string prefixed with `terraform-ess-<rule type>-`."
  type        = string
  default     = ""
}

variable "adjustment_type" {
  description = "Adjustment mode of a scaling rule"
  type        = string
  default     = "TotalCapacity"
}

variable "adjustment_value" {
  description = "The number of ECS instances to be adjusted in the scaling rule"
  type        = number
  default     = 1
}

variable "cooldown" {
  description = "The cooldown time of the scaling rule. This parameter is applicable only to simple scaling rules."
  type        = number
  default     = 0
}

variable "estimated_instance_warmup" {
  description = "The estimated time, in seconds, until a newly launched instance will contribute CloudMonitor metrics"
  type        = number
  default     = 60
}

variable "step_adjustments" {
  description = "Steps for StepScalingRule"
  type        = list(map(string))
  default     = []
}

### ESS ALARM
variable "scaling_alarm_name" {
  description = "The name for scaling alarm."
  type        = string
  default     = ""
}

variable "alarm_enable" {
  description = "Enable alarm task"
  type        = bool
  default     = true
}

variable "alarm_task_metric_type" {
  description = "The type for the alarm's associated metric"
  type        = string
  default     = "system"
}

variable "alarm_task_metric_name" {
  description = "The name for the alarm's associated metric"
  type        = string
  default     = "CpuUtilization"
}

variable "alarm_task_setting" {
  description = "The setting of monitoring index setting. It contains the following parameters: `period`(A reference period used to collect, summary, and compute data. Default to 60 seconds), `method`(The method used to statistics data, default to Average), `threshold`(Verify whether the statistics data value of a metric exceeds the specified threshold. Default to 0), `comparison_operator`(The arithmetic operation to use when comparing the specified method and threshold. Default to >=), `trigger_after`(You can select one the following options, such as 1, 2, 3, and 5 times. When the value of a metric exceeds the threshold for specified times, an event is triggered, and the specified scaling rule is applied. Default to 3 times.)"
  type        = map(string)
  default     = { period = 60, method = "Average", threshold = 0, comparison_operator = ">=", trigger_after = 3 }
}
