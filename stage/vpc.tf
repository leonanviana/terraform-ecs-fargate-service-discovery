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

  # NAT Gateway allows private subnet tasks to pull images from ECR/Docker Hub
  enable_nat_gateway = true
  enable_vpn_gateway = false

  tags = local.computed_tags
}
