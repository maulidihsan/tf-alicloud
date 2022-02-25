resource "alicloud_slb_load_balancer" "lb" {
  load_balancer_name   = var.slb_name
  internet_charge_type = var.internet_charge_type
  address_type         = var.address_type
  load_balancer_spec   = var.load_balancer_spec
  bandwidth            = var.internet_charge_type == "PayByBandwidth" ? var.bandwidth : null
  vswitch_id           = var.address_type != "internet" ? module.network.vswitch_ids.0 : null
  tags                 = var.slb_tags

  depends_on = [module.network]
}

module "network" {
  source                  = "./modules/network"
  vpc_name                = var.vpc_name
  vpc_cidr                = var.vpc_cidr
  vpc_tags                = var.vpc_tags
  vswitches               = var.vswitches
  security_groups         = var.security_groups
}

module "compute" {
  source                  = "./modules/compute"
  for_each                = {for c in var.computes : c.scaling_group_name => c }

  scaling_group_name      = each.key
  enable                  = lookup(each.value, "enable", true)
  active                  = lookup(each.value, "active", true)
  min_size                = lookup(each.value, "min_size", null)
  max_size                = lookup(each.value, "max_size", null)
  desired_capacity        = lookup(each.value, "desired_capacity", null)
  adjustment_type         = lookup(each.value, "adjustment_type", "QuantityChangeInCapacity")
  adjustment_value        = lookup(each.value, "adjustment_value", 1)
  alarm_task_metric_name  = lookup(each.value, "alarm_task_metric_name", "CpuUtilization")
  alarm_task_setting      = lookup(each.value, "alarm_task_setting", null)
  instance_types          = lookup(each.value, "instance_types", ["ecs.t6-c1m2.large"])
  instance_name           = lookup(each.value, "instance_name", null)
  image_id                = lookup(each.value, "image_id", "m-k1a2s10zs47rl5mq5tgr")
  system_disk_category    = lookup(each.value, "system_disk_category", null)
  system_disk_size        = lookup(each.value, "system_disk_size", null)
  password                = lookup(each.value, "password", null)
  tags                    = lookup(each.value, "tags", null)

  frontend_port           = lookup(each.value, "frontend_port", null)
  backend_port            = lookup(each.value, "backend_port", null)
  user_data               = <<SCRIPT
#! /bin/sh
docker run --name my-wp -e WORDPRESS_DB_HOST=${module.db["MySQL-5.6"].connection_string} \
-e WORDPRESS_DB_USER=${var.db_clusters.0.accounts.0.account_name} \
-e WORDPRESS_DB_PASSWORD=${var.db_clusters.0.accounts.0.account_password} \
-e WORDPRESS_DB_NAME=${var.db_clusters.0.databases.0.db_name} -p 8080:80 -d wordpress:latest
ufw allow 8080/tcp
SCRIPT

  security_group_ids      = module.network.security_group_ids
  vswitch_ids             = module.network.vswitch_ids
  loadbalancer_id         = alicloud_slb_load_balancer.lb.id

  depends_on = [alicloud_slb_load_balancer.lb, module.db]
}

module "db" {
  source                  = "./modules/db"
  for_each                = {for db in var.db_clusters : "${db.db_type}-${db.db_version}" => db }

  db_type                 = each.value.db_type
  db_version              = lookup(each.value, "db_version", null)
  db_node_class           = lookup(each.value, "db_node_class", "polar.mysql.g2.medium")
  db_node_count           = lookup(each.value, "db_node_count", 2)
  security_ips            = lookup(each.value, "security_ips", null)
  vswitch_id              = module.network.vswitch_ids.0
  tags                    = lookup(each.value, "tags", null)
  databases               = lookup(each.value, "databases", [])
  accounts                = lookup(each.value, "accounts", [])

  depends_on = [module.network]
}
