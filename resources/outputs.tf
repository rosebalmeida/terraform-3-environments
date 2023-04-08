output "instance_front_ips" {
  value = aws_instance.instance_frontend.*.public_ip
}

output "instance_back_ips" {
  value = aws_instance.instace_backend.*.private_ip
}

output "database_url" {
  value = aws_db_instance.main.address
}

output "vpc_id" {
  value = aws_vpc.vpc.id
}