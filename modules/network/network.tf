resource "aws_vpc" "main" {
  cidr_block = var.cidr_block

  enable_dns_hostnames = true

  tags = {
    Name = "${var.project_name}-vpc"
  }
}

resource "aws_subnet" "pub_subnet_a" {
  vpc_id            = aws_vpc.main.id
  cidr_block        = "10.0.1.0/24"
  availability_zone = "${var.aws_region}a"

  tags = {
    Name = "pub_subnet_a"
  }
}

resource "aws_subnet" "pub_subnet_b" {
  vpc_id            = aws_vpc.main.id
  cidr_block        = "10.0.2.0/24"
  availability_zone = "${var.aws_region}b"

  tags = {
    Name = "pub_subnet_b"
  }
}

resource "aws_subnet" "pub_subnet_c" {
  vpc_id            = aws_vpc.main.id
  cidr_block        = "10.0.3.0/24"
  availability_zone = "${var.aws_region}c"

  tags = {
    Name = "pub_subnet_c"
  }
}

resource "aws_subnet" "priv_subnet_a" {
  vpc_id            = aws_vpc.main.id
  cidr_block        = "10.0.4.0/24"
  availability_zone = "${var.aws_region}a"

  tags = {
    Name = "priv_subnet_a"
  }
}

resource "aws_subnet" "priv_subnet_b" {
  vpc_id            = aws_vpc.main.id
  cidr_block        = "10.0.5.0/24"
  availability_zone = "${var.aws_region}b"

  tags = {
    Name = "priv_subnet_b"
  }
}

resource "aws_subnet" "priv_subnet_c" {
  vpc_id            = aws_vpc.main.id
  cidr_block        = "10.0.6.0/24"
  availability_zone = "${var.aws_region}c"

  tags = {
    Name = "priv_subnet_c"
  }
}

resource "aws_internet_gateway" "internet_gateway" {
  vpc_id = aws_vpc.main.id

  tags = {
    Name = "${var.project_name}-internet-gateway"
  }
}

resource "aws_route_table" "public_route_table" {
  vpc_id = aws_vpc.main.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.internet_gateway.id
  }

  tags = {
    Name = "${var.project_name}-public-route-table"
  }
}

resource "aws_route_table_association" "pub-a" {
  subnet_id      = aws_subnet.pub_subnet_a.id
  route_table_id = aws_route_table.public_route_table.id
}

resource "aws_route_table_association" "pub-b" {
  subnet_id      = aws_subnet.pub_subnet_b.id
  route_table_id = aws_route_table.public_route_table.id
}

resource "aws_route_table_association" "pub-c" {
  subnet_id      = aws_subnet.pub_subnet_c.id
  route_table_id = aws_route_table.public_route_table.id
}

resource "aws_security_group" "main_security_group" {
  name        = var.project_name
  description = "Allow TLS inbound traffic"
  vpc_id      = aws_vpc.main.id

  ingress {
    description = "TLS from VPC"
    from_port   = 0
    to_port     = 65535
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }

  tags = {
    Name = "${var.project_name}"
  }
}

resource "aws_route_table" "private_route_table" {

  depends_on = [ aws_instance.nat_instance ]

  vpc_id = aws_vpc.main.id

  route {
    cidr_block     = "0.0.0.0/0"
    network_interface_id = aws_instance.nat_instance.primary_network_interface_id
  }

  tags = {
    Name = "${var.project_name}-private-route-table"
  }
}

# Associate Private Route Table with Private Subnets
resource "aws_route_table_association" "priv-a" {
  subnet_id      = aws_subnet.priv_subnet_a.id
  route_table_id = aws_route_table.private_route_table.id
}

resource "aws_route_table_association" "priv-b" {
  subnet_id      = aws_subnet.priv_subnet_b.id
  route_table_id = aws_route_table.private_route_table.id
}

resource "aws_route_table_association" "priv-c" {
  subnet_id      = aws_subnet.priv_subnet_c.id
  route_table_id = aws_route_table.private_route_table.id
}