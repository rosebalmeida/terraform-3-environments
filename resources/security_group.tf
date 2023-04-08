resource "aws_security_group" "vm" {
  name = "${var.project_name}-${terraform.workspace}-vm-sg"
  description = "${var.project_name}-${terraform.workspace} Security Group VM"
  vpc_id = aws_vpc.vpc.id

  dynamic "ingress" {
    for_each = local.ingress_web_rules
      
	  content {
        from_port = ingress.value.port
        to_port = ingress.value.port
        protocol = "tcp"
        cidr_blocks = ["0.0.0.0/0"]
      }
  } 

  egress {
    from_port = 0
    to_port = 0
    protocol = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "${var.project_name}-${terraform.workspace}-sg-vm"
  }
}

resource "aws_security_group" "db" {
  name = "${var.project_name}-${terraform.workspace}-sg-db"
  description = "${var.project_name}-${terraform.workspace} Security Group Database"
  vpc_id = aws_vpc.vpc.id

  dynamic "ingress" {
    for_each = local.ingress_db_rules

      content {
        from_port = ingress.value.port
        to_port = ingress.value.port
        protocol = "tcp"
        cidr_blocks = ["0.0.0.0/0"]
      }
  } 

  egress {
    from_port = 0
    to_port = 0
    protocol = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "${var.project_name}-${terraform.workspace}-sg-db"
  }
}