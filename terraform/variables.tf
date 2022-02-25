variable "region" {
  description = "Region selector"
  type        = string
  default     = "ap-southeast-5"
}

variable "computes" {
  description = "Auto-Scale ECS definition"
  type        = any
  default     = []
}

variable "db_clusters" {
  description = "PolarDB clusters"
  type        = any
  default     = []
}


### VPC
variable "vpc_name" {
  description = "VPC name"
  type        = string
  default     = "TF-VPC"
}

variable "vpc_cidr" {
  description = "VPC (Network) CIDR Block"
  type        = string
  default     = "172.16.0.0/12"
}

variable "vpc_tags" {
  description = "Tags assigned to the vpc"
  type        = map(string)
  default     = null
}

variable "vswitches" {
  description = "List of VSwitches (Subnet)"
  type        = list(map(string))
}

variable "security_groups" {
  description = "List of Security Group"
  type        = any
  default     = []
}

# SLB
variable "slb_name" {
  description = "SLB Name"
  type        = string
  default     = "slb-test"
}

variable "address_type" {
  description = "The network type of the SLB instance."
  type        = string
  default     = "internet"
}

variable "internet_charge_type" {
  description = "internet_charge_type"
  type        = string
  default     = "PayByTraffic"
}

variable "bandwidth" {
  description = "Valid value is between 1 and 1000 if PayByBandwidth"
  type        = number
  default     = 20
}

variable "load_balancer_spec" {
  description = "Load balancer spec"
  type        = string
  default     = "slb.s1.small"
}

variable "load_balancer_vswitch" {
  description = "Load balancer vswitch id"
  type        = string
  default     = ""
}

variable "slb_tags" {
  description = "Tags assigned to the vpc"
  type        = map(string)
  default     = {}
}