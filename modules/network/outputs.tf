output "pub_subnet_a_id" {
	value = aws_subnet.pub_subnet_a.id
}

output "pub_subnet_b_id" {
	value = aws_subnet.pub_subnet_b.id
}

output "pub_subnet_c_id" {
	value = aws_subnet.pub_subnet_c.id
}

output "priv_subnet_a_id" {
	value = aws_subnet.priv_subnet_a.id
}

output "priv_subnet_b_id" {
	value = aws_subnet.priv_subnet_b.id
}

output "priv_subnet_c_id" {
	value = aws_subnet.priv_subnet_c.id
}

output "vpc_id" {
	value = aws_vpc.main.id
}

output "security_group_id" {
	value = aws_security_group.main_security_group.id
}

output "nat_instance_public_ip" {
  description = "The public IP of the Nat Instance"
  value       = aws_instance.nat_instance.public_ip
}

output "nat_instance_id" {
  description = "The ID of the Nat Instance"
  value       = aws_instance.nat_instance.id
}

output "bot_private_key" {
  value     = tls_private_key.tls_priv_key_nat_instance.private_key_pem
  sensitive = true
}

output "bot_public_key" {
  value = tls_private_key.tls_priv_key_nat_instance.public_key_openssh
}