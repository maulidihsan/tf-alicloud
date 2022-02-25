terraform {
  required_version = ">= 0.12.0"

  required_providers {
    alicloud = {
      source  = "aliyun/alicloud"
      version = ">= 1.156.0"
    }
  }
}
