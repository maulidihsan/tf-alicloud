variable "access_key" {
  type        = string
  description = "Alicloud Access Key"
}

variable "secret_key" {
  type        = string
  description = "Alicloud Secret Key"
}

variable "region" {
  type        = string
  description = "The region in which to launch the instance used to create the image. "
  default     = "asia-southeast2-a"
}

variable "ssh_username" {
  type        = string
  description = "The username to connect to SSH with. Automatically created by packer if it doesn't exist"
  default     = "root"
}

variable "source_image" {
  type        = string
  description = "Source image to use to create the new image from"
  default     = null
}

variable "image_name" {
  type        = string
  description = "The unique name of the resulting image"
}

variable "image_family" {
  type        = string
  description = "The name of the image family to which the resulting image belongs"
  default     = null
}

variable "instance_type" {
  type        = string
  description = "The machine type for builder instance."
  default     = "n1-standard-1"
}

