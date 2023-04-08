resource "aws_instance" "instance_frontend" {
  count = var.instance_front
  ami = data.aws_ami.ubuntu.image_id
  instance_type = "t3.small"
  key_name = var.instance_key
  user_data = "${file("${path.module}/install_httpd.sh")}"
  subnet_id = aws_subnet.public[count.index % var.public_subnet_count].id
  vpc_security_group_ids = [aws_security_group.vm.id]

  root_block_device {
    volume_type = "gp3"
    volume_size = 20 
  }
  
  tags = {
    Name = "${var.project_name}-{terraform.workspace}-${count.index}"
  }
}

resource "aws_instance" "instace_backend" {
  count = var.instance_back
  ami = data.aws_ami.amazon.image_id
  instance_type = "t3.small"
  key_name = var.instance_key
  user_data = "${file("${path.module}/install_nginx_mysql.sh")}"
  subnet_id = aws_subnet.private[count.index % var.private_subnet_count].id
  vpc_security_group_ids = [aws_security_group.vm.id]

  root_block_device {
    volume_type = "gp3"
    volume_size = local.storage_instace[terraform.workspace] 
  }
  
  tags = {
    Name = "${var.project_name}-{terraform.workspace}-${count.index}"
  }
}