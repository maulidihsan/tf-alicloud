packer {
  required_plugins {
    alicloud = {
      version = ">= 0.0.1"
      source  = "github.com/hashicorp/alicloud"
    }
  }
}

locals {
  image_name = "${var.image_name}-${formatdate("DDMMYY", timestamp())}"
}

source "alicloud-ecs" "ecs-docker" {
  access_key           = var.access_key
  secret_key           = var.secret_key
  region               = var.region
  zone_id              = "ap-southeast-5a"
  image_name           = local.image_name
  image_family         = var.image_family
  source_image         = var.source_image
  ssh_username         = var.ssh_username
  instance_type        = var.instance_type
  internet_charge_type = "PayByTraffic"
  image_force_delete   = true
  run_tags = {
    "Built by"   = "Packer"
    "Managed by" = "Packer"
  }
  skip_region_validation = false
  skip_image_validation  = false
}

build {
  sources = ["sources.alicloud-ecs.ecs-docker"]
  provisioner "shell" {
    scripts = ["scripts/setup.sh"]
  }
}
