terraform {

  required_providers {

    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }

  }

  backend "s3" {
    bucket       = "your-terraform-state-bucket"
    key          = "myapp/stage/terraform.tfstate"
    region       = "us-east-1"
    use_lockfile = true
  }
}

provider "aws" {
  region = var.region
  default_tags {
    tags = {
      Terraform   = "true"
      Environment = "Stage"
      Application = "myapp"
    }
  }
}

module "vpc" {
  source  = "terraform-aws-modules/vpc/aws"
  version = "~> 5.0"

  name = "${local.prefix}-vpc"
  cidr = "10.0.0.0/23"

  azs = ["${var.region}a", "${var.region}b"]

  public_subnets = [
    "10.0.0.0/25",  # AZ-a (128 IPs)
    "10.0.0.128/25" # AZ-b (128 IPs)
  ]

  private_subnets = [
    "10.0.1.0/25",  # AZ-a (128 IPs)
    "10.0.1.128/25" # AZ-b (128 IPs)
  ]

  enable_nat_gateway = true
  enable_vpn_gateway = false

  tags = local.computed_tags
}
