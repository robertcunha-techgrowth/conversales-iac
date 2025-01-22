variable "aws_region" {
  description = "value of the region"
  type        = string
}

variable "project_name" {
  description = "value of the project name"
  type        = string
}

variable "cidr_block" {
  description = "value of the CIDR block"
  type        = string
}

variable "base_domain" {
  description = "value of the base domain"
  type        = string
}

variable "api_domain" {
  description = "value of the API domain"
  type        = string
}

variable "environment" {
  description = "value of the environment"
  type        = string
}

variable "landing_page_domain_ptbr" {
  type = string
  description = "Landing page domain PTBR language"
}

variable "landing_page_domain_enus" {
  type = string
  description = "Landing page domain ENUS language"
}

