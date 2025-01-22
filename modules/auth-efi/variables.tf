variable "subnet_a_id" {
	type = string
	description = "subnet A ID"
}

variable "subnet_b_id" {
	type = string
	description = "subnet B ID"
}

variable "subnet_c_id" {
	type = string
	description = "subnet C ID"
}

variable "auth_efi_schedule" {
	type = string
	description = "Schedule for the auth-efi lambda function"
}

variable "security_group_id" {
	type = string
	description = "Security group ID for the auth-efi lambda function"
}

variable "lambda_timeout" {
	type = number
	description = "Timeout in seconds for the auth-efi lambda function"
}

variable "envinronment" {
	type = string
	description = "Environment for the auth-efi lambda function"
}