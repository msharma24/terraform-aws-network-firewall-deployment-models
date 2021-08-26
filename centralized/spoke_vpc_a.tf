################################################################################
# VPC Module Spoke VPC A
################################################################################

module "spoke_vpc_a" {

  source  = "terraform-aws-modules/vpc/aws"
  version = "3.0.0"


  name = "spoke_vpc_a"
  cidr = "10.0.0.0/16"

  azs             = ["${local.region}a", "${local.region}b", "${local.region}c"]
  private_subnets = ["10.0.1.0/24", "10.0.2.0/24", "10.0.3.0/24"]
  public_subnets  = ["10.0.101.0/24", "10.0.102.0/24", "10.0.103.0/24"]

  enable_ipv6 = false
  create_igw  = false

  enable_nat_gateway = false
  single_nat_gateway = false


  tags = {
    Owner       = "user"
    Environment = "dev"
  }

  vpc_tags = {
    Name = "spoke_vpc_a"
  }
}


data "aws_route_tables" "spoke_vpc_a_tgw_route" {
  vpc_id = module.spoke_vpc_a.vpc_id

  filter {
    name   = "tag:Name"
    values = ["spoke_vpc_a-private-*"]
  }
}

resource "aws_route" "spoke_vpc_a_tgw_route" {
  count                  = length(data.aws_route_tables.spoke_vpc_a_tgw_route.ids)
  route_table_id         = tolist(data.aws_route_tables.spoke_vpc_a_tgw_route.ids)[count.index]
  destination_cidr_block = "0.0.0.0/0"
  transit_gateway_id     = module.tgw.ec2_transit_gateway_id

  depends_on = [
    module.tgw
  ]
}
