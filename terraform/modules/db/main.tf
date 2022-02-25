resource "alicloud_polardb_cluster" "cluster" {
  db_type       = var.db_type
  db_version    = var.db_version
  pay_type      = "PostPaid"
  db_node_class = var.db_node_class
  db_node_count = var.db_node_count
  vswitch_id    = var.vswitch_id
  security_ips  = var.security_ips
  tags          = var.tags
  description   = "Managed by Terraform"
}

resource "alicloud_polardb_database" "db" {
  for_each           = { for db in var.databases : db.db_name => db }
  db_cluster_id      = alicloud_polardb_cluster.cluster.id
  db_name            = each.key
  character_set_name = lookup(each.value, "character_set_name", "utf8")
  db_description     = lookup(each.value, "db_description", "Managed by Terraform")
}

resource "alicloud_polardb_account" "account" {
  for_each            = { for acc in var.accounts : acc.account_name => acc }
  db_cluster_id       = alicloud_polardb_cluster.cluster.id
  account_name        = each.key
  account_type        = lookup(each.value, "account_type", "Normal")
  account_password    = lookup(each.value, "account_password", null)
  account_description = lookup(each.value, "account_description", null)

  depends_on = [alicloud_polardb_database.db]
}

resource "alicloud_polardb_account_privilege" "privilege" {
  for_each            = { for acc in var.accounts : acc.account_name => acc }
  db_cluster_id       = alicloud_polardb_cluster.cluster.id
  account_name        = each.key
  account_privilege   = lookup(each.value, "account_privilege", "ReadOnly")
  db_names            = lookup(each.value, "db_names", [])

  depends_on = [alicloud_polardb_account.account]
}
