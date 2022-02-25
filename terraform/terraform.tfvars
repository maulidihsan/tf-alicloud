region = "ap-southeast-5"
vpc_name  = "test"
vpc_cidr  = "172.16.0.0/16"
vpc_tags  = {
  Environment = "test"
}
vswitches = [
  {
    vswitch_name = "test-subnet",
    cidr_block   = "172.16.1.0/24",
    zone_id      = "ap-southeast-5a"
  }
]
security_groups = [
  {
    security_group_name = "wp-sg",
    ingress_rule = [
      {
        ip_protocol = "tcp",
        nic_type    = "intranet",
        port_range  = "8080/8080",
        priority    = 1,
        cidr_ip     = "0.0.0.0/0"
      },
      {
        ip_protocol = "tcp",
        nic_type    = "intranet",
        port_range  = "22/22",
        priority    = 1,
        cidr_ip     = "100.104.0.0/16"
      }
    ]
    egress_rule = []
  }
]

slb_name = "test-lb"

computes = [
  {
    scaling_group_name = "wp",
    alarm_task_setting = { period = 60, method = "Average", threshold = 50, comparison_operator = ">=", trigger_after = 3 },
    image_id = "m-k1a27kbtn9kn2e51v1kc",
    password = "!qaz2WSX",
    min_size = 0,
    max_size = 2,
    desired_capacity = 1,
    instance_name = "wp",
    frontend_port = 80,
    backend_port = 8080
  }
]

db_clusters = [
  {
    db_type = "MySQL",
    db_version = "5.6",
    security_ips = ["172.16.1.0/24"],
    tags = {
      Environment = "test"
    }
    databases = [{
      db_name = "test-db"
    }]
    accounts = [{
      account_name = "user",
      account_privilege = "ReadWrite"
      account_password = "test12345!!",
      db_names  = ["test-db"]
    }]
  }
]