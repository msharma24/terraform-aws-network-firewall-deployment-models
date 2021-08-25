################################################################################
# Egress VPC
################################################################################
module "egress_vpc" {
  source  = "terraform-aws-modules/vpc/aws"
  version = "3.0.0"
  name    = "egress-vpc"
  cidr    = "10.10.0.0/16"

  azs             = ["${local.region}a", "${local.region}b", "${local.region}c"]
  private_subnets = ["10.10.0.0/28", "10.10.0.16/28"]
  public_subnets  = ["10.10.2.0/24", "10.10.1.0/24"]

  enable_ipv6 = false

  enable_nat_gateway = true
  single_nat_gateway = false


  tags = {
    Owner       = "user"
    Environment = "dev"
  }

  vpc_tags = {
    Name = "egress-vpc"
  }
}

resource "aws_route" "egress_vpc_route_to_tgw" {
  route_table_id         = module.egress_vpc.public_route_table_ids[0]
  destination_cidr_block = "10.0.0.0/8"
  transit_gateway_id     = module.tgw.ec2_transit_gateway_id

  depends_on = [
    module.tgw
  ]

}
