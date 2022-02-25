variable "db_type" {
  description = "Database type."
  type        = string
}

variable "db_version" {
  description = "Database version"
  type        = string
}

variable "db_node_class" {
  description = "The db_node_class of cluster node."
  type        = string
  default     = "polar.mysql.g2.medium"
}

variable "db_node_count" {
  description = "Number of the PolarDB cluster nodes"
  type        = number
  default     = 2
}

variable "security_ips" {
  description = "List of IP addresses allowed to access all databases of an cluster."
  type        = list(string)
  default     = []
}

variable "vswitch_id" {
  description = "The virtual switch ID to launch DB instances in one VPC"
  type        = string
  default     = null
}

variable "tags" {
  description = "A mapping of tags to assign to the resource."
  type        = map(string)
  default     = {}
}

variable "databases" {
  description = "Created Databases"
  type        = list(map(string))
  default     = []
}

variable "accounts" {
  description = "Created Databases"
  type        = any
  default     = []
}
