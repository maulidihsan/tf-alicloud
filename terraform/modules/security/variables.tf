variable "security_group_name" {
  description = "Security Group name"
  type        = string
  default     = ""
}

variable "vpc_id" {
	description	= "VPC ID"
	type				= string
}

variable "tags" {
	description	= "Apply tags to security group"
	type				= map(string)
	default			= {}
}

variable "ingress_rule" {
	description	= "Ingress Rule Specifications"
	type				= list(map(string))
	default			= []
}

variable "egress_rule" {
	description	= "Egress Rule Specifications"
	type				= list(map(string))
	default			= []
}
