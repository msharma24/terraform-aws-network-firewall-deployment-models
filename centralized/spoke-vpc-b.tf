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
  create_igw  = false

  enable_nat_gateway = false
  single_nat_gateway = false

  enable_dns_hostnames = true
  enable_dns_support   = true

  tags = {
    Owner       = "user"
    Environment = "dev"
  }

  vpc_tags = {
    Name = "spoke_vpc_b"
  }
}

resource "aws_route" "spoke_vpc_b_tgw_route" {
  count                  = length(module.spoke_vpc_b.public_route_table_ids)
  route_table_id         = module.spoke_vpc_b.public_route_table_ids[count.index]
  destination_cidr_block = "0.0.0.0/0"
  transit_gateway_id     = module.tgw.ec2_transit_gateway_id

  depends_on = [
    module.tgw,
    module.spoke_vpc_b,
  ]
}

################################################################################
# VPC Module Spoke VPC B - SSM Endpoint
################################################################################
data "aws_security_group" "spoke_vpc_b_default_sg" {
  name   = "default"
  vpc_id = module.spoke_vpc_b.vpc_id
}

module "spoke_vpc_b_ssm_endpoint" {

  source             = "terraform-aws-modules/vpc/aws//modules/vpc-endpoints"
  vpc_id             = module.spoke_vpc_b.vpc_id
  security_group_ids = [module.spoke_vpc_b_https_sg.security_group_id]

  endpoints = {
    ssm = {
      service             = "ssm"
      private_dns_enabled = true
      subnet_ids          = module.spoke_vpc_b.public_subnets
    },
    ssmmessages = {
      service             = "ssmmessages"
      private_dns_enabled = true,
      subnet_ids          = module.spoke_vpc_b.public_subnets
    },
    ec2messages = {
      service             = "ec2messages",
      private_dns_enabled = true,
      subnet_ids          = module.spoke_vpc_b.public_subnets
    }

  }
}
