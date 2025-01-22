terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = ">= 4.12.1"
    }
  }

  backend "s3" {
    bucket                      = "techgrowth-conversales-prd-remote-state-us-east-1"
    key                         = "techgrowth-conversales-prd/terraform.state"
    region                      = "us-east-1"
    skip_region_validation      = true
    skip_credentials_validation = true
    skip_metadata_api_check     = true
  }
}

# Configure the AWS Provider
provider "aws" {
  region = var.aws_region

  default_tags {
    tags = {
      managed-by = "terraform"
    }
  }
}

module "network" {
  source       = "../../modules/network"
  aws_region   = var.aws_region
  project_name = var.project_name
  cidr_block   = var.cidr_block

  nat_instance_type = "t2.micro"
}

module "auth_efi" {
  source         = "../../modules/auth-efi"
  lambda_timeout = 30

  security_group_id = module.network.security_group_id

  subnet_a_id = module.network.priv_subnet_a_id
  subnet_b_id = module.network.priv_subnet_b_id
  subnet_c_id = module.network.priv_subnet_c_id

  auth_efi_schedule = "cron(0 * * * ? *)"

  envinronment = "prd"
}


module "timeout_notifier" {
  source = "../../modules/timeout-notifier"

  subnet_a_id = module.network.priv_subnet_a_id
  subnet_b_id = module.network.priv_subnet_b_id
  subnet_c_id = module.network.priv_subnet_c_id

  security_group_id = module.network.security_group_id

  lambda_timeout = 30

  envinronment = "prd"

  schedule_expression = "cron(*/5 * * * ? *)"
}


module "landing_page_ptbr" {
  source = "../../modules/landing-page"

  domain = var.landing_page_domain_ptbr
  base_domain = var.base_domain

  project_name = var.project_name
}