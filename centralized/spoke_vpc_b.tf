################################################################################
# VPC Module Spoke VPC b
################################################################################

module "spoke_vpc_b" {
  source  = "terraform-aws-modules/vpc/aws"
  version = "3.0.0"
  name    = "spoke_vpc_b"
  cidr    = "10.102.0.0/16"

  azs             = ["${local.region}a", "${local.region}b", "${local.region}c"]
  private_subnets = ["10.102.1.0/24", "10.102.2.0/24", "10.102.3.0/24"]
  public_subnets  = ["10.102.4.0/24", "10.102.5.0/24", "10.102.6.0/24"]

  enable_ipv6 = false

  enable_nat_gateway = false
  single_nat_gateway = false

  public_subnet_tags = {
    Name = "overridden-name-public"
  }

  tags = {
    Owner       = "user"
    Environment = "dev"
  }

  vpc_tags = {
    Name = "spoke_vpc_b"
  }
}

