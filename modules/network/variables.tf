variable "project_name" {
	type = string

	description = "Project name"
}

variable "aws_region" {
	type = string

	description = "Region of AWS where the resources will be created"
}

variable "cidr_block" {
	type = string

	description = "CIDR block for the VPC"

}

variable "nat_instance_type" {
	type = string

	description = "Instance type for the NAT instance"
}