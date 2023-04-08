resource "aws_internet_gateway" "main" {
  vpc_id = aws_vpc.vpc.id
}

resource "aws_route_table" "public" {
  vpc_id = aws_vpc.vpc.id
}

resource "aws_route_table" "private" {
  vpc_id = aws_vpc.vpc.id
}

resource "aws_subnet" "public" {
  count = var.public_subnet_count
  cidr_block = cidrsubnet(aws_vpc.vpc.cidr_block, local.subnets_size, count.index + 1)
  availability_zone = data.aws_availability_zones.availability_zone.names[count.index]
  vpc_id = aws_vpc.vpc.id
  map_public_ip_on_launch = true

  tags = {
    Name = "${var.project_name}-${terraform.workspace}-public-subnet-${count.index + 1}"
  }
}

resource "aws_subnet" "private" {
  count = var.private_subnet_count
  cidr_block = cidrsubnet(aws_vpc.vpc.cidr_block, local.subnets_size, count.index + var.public_subnet_count + 1)
  availability_zone = data.aws_availability_zones.availability_zone.names[count.index]
  vpc_id = aws_vpc.vpc.id
  map_public_ip_on_launch = false

  tags = {
    Name = "${var.project_name}-${terraform.workspace}-private-subnet-${count.index + 1}"
  }
}

resource "aws_route_table_association" "public" {
  count = var.public_subnet_count
  subnet_id = aws_subnet.public[count.index].id
  route_table_id = aws_route_table.public.id
}

resource "aws_route_table_association" "private" {
  count = var.private_subnet_count
  subnet_id = aws_subnet.private[count.index].id
  route_table_id = aws_route_table.private.id
}

resource "aws_route" "public" {
  route_table_id = aws_route_table.public.id
  destination_cidr_block = "0.0.0.0/0"
  gateway_id = aws_internet_gateway.main.id
}