variable "vpc_name" {
  description = "VPC name"
  type        = string
  default     = "TF-VPC"
}

variable "vpc_description" {
  description = "VPC description"
  type        = string
  default     = "Managed by Terraform"
}

variable "vpc_cidr" {
  description = "VPC (Network) CIDR Block"
  type        = string
  default     = "172.16.0.0/12"
}

variable "resource_group_id" {
  description = "The Id of resource group which the instance belongs."
  type        = string
  default     = null
}

variable "vpc_tags" {
  description = "Tags assigned to the vpc"
  type        = map(string)
  default     = {}
}

# VSwitch variables
variable "vswitches" {
  description = "List of VSwitches (Subnet)"
  type        = any
  default     = []
}

variable "security_groups" {
  description = "List of Security Groups"
  type        = any
  default     = []
}

# // According to the vswitch cidr blocks to launch several vswitches
# variable "destination_cidrs" {
#   description = "List of destination CIDR block of virtual router in the specified VPC."
#   type        = list(string)
#   default     = []
# }

# variable "nexthop_ids" {
#   description = "List of next hop instance IDs of virtual router in the specified VPC."
#   type        = list(string)
#   default     = []
# }
