locals {
  subnets_size = 8

  storage_instace = {
	Dev = 10,
	Hom = 20,
	Prd = 50,
  }

  range_ip = {
	Dev = "172.26.0.0/16",
	Hom = "172.27.0.0/16",
	Prd = "172.28.0.0/16",
  }

  storage_rds = {
	Dev = 20,
	Hom = 30,
	Prd = 50,
  }

  ingress_web_rules = [{
	port = 80,
	description = "Port 80"
  },
  {
    port = 443,
	description = "Port 443"
  }]

  ingress_db_rules = [{
	port = 3306,
	description = "Port 3306"
  }]
}