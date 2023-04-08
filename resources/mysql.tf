resource "aws_db_subnet_group" "main" {
  name = "db-subnet-group-mysql-${lower(terraform.workspace)}"
  subnet_ids = [for k, v in aws_subnet.private : aws_subnet.private[k].id]

  tags = {
    Name = "${var.project_name}-db-subnet-group-${lower(terraform.workspace)}"
  }
}

resource "aws_db_instance" "main" {
  allocated_storage = local.storage_rds[terraform.workspace]
  backup_retention_period = terraform.workspace == "Prd" ? 30 : 7
  db_subnet_group_name = aws_db_subnet_group.main.name
  engine = "mysql"
  engine_version = "8.0.32"
  identifier = "rds-mysql-${lower(terraform.workspace)}"
  instance_class = "db.t3.micro"
  multi_az = terraform.workspace == "Prd" ? true : false
  db_name = "mydb"
  password = "admin123456"
  publicly_accessible = false
  storage_encrypted = true
  storage_type = "gp3"
  username = "mydb"
  backup_window = "22:00-23:00"
  maintenance_window = "Sat:00:00-Sat:03:00"
  vpc_security_group_ids = [aws_security_group.db.id]
  auto_minor_version_upgrade = false
  skip_final_snapshot = true
  max_allocated_storage = terraform.workspace == "Prd" ? local.storage_rds[terraform.workspace] * 100 : 0

  tags = {
    Name = "${var.projeto}-rds-mysql-${lower(terraform.workspace)}"
  }
}

resource "aws_db_instance" "replica" {
  count = terraform.workspace == "Prd" ? 1 : 0
  backup_retention_period = terraform.workspace == "Prd" ? 30 : 7
  identifier = "rds-mysql-replica-${lower(terraform.workspace)}"
  instance_class = "db.t3.micro"
  publicly_accessible = false
  storage_encrypted = true
  storage_type = "gp3"
  backup_window = "22:00-23:00"
  maintenance_window = "Sat:00:00-Sat:03:00"
  vpc_security_group_ids = [aws_security_group.db.id]
  replicate_source_db = aws_db_instance.main.id
  auto_minor_version_upgrade = false
  skip_final_snapshot = true
  max_allocated_storage = local.storage_rds[terraform.workspace] * 100

  tags = {
    Name = "${var.projeto}-rds-mysql-replica-${lower(terraform.workspace)}"
  }
}