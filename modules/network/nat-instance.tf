resource "tls_private_key" "tls_priv_key_nat_instance" {
  algorithm = "RSA"
  rsa_bits  = 2048
}

resource "aws_key_pair" "nat_instance_key" {
  key_name   = "nat-instance-key"
  public_key = tls_private_key.tls_priv_key_nat_instance.public_key_openssh
}

resource "aws_eip" "nat_instance_eip" {
  domain = "vpc"
  tags = {
    Name = "nat-instance-eip"
  }
}

resource "aws_instance" "nat_instance" {
  ami                    = "ami-05576a079321f21f8"
  instance_type          = var.nat_instance_type
  subnet_id              = aws_subnet.pub_subnet_a.id
  key_name               = aws_key_pair.nat_instance_key.key_name
  vpc_security_group_ids = [aws_security_group.main_security_group.id]
  source_dest_check      = false

  tags = {
    Name = "NatInstance"
  }
}

resource "aws_eip_association" "eip_assoc" {
  instance_id   = aws_instance.nat_instance.id
  allocation_id = aws_eip.nat_instance_eip.id
}
