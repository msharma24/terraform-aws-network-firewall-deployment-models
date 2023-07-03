#---------------------------------------------------------------------------
# Inspection VPC
#---------------------------------------------------------------------------
module "inspection_vpc" {
  source  = "terraform-aws-modules/vpc/aws"
  version = "5.0.0"
  name    = "inspection_vpc"

  cidr            = "100.64.0.0/16"
  azs             = ["${local.region}a", "${local.region}b", "${local.region}c"]
  private_subnets = ["100.64.32.0/19", "100.64.64.0/19", "100.64.96.0/19"]
  public_subnets  = ["100.64.128.0/19", "100.64.160.0/19", "100.64.192.0/19"]

  enable_nat_gateway      = false
  single_nat_gateway      = false
  map_public_ip_on_launch = false

  create_igw = false

  enable_dns_hostnames = true
  enable_dns_support   = true

  private_subnet_tags = {
    Name = "inspection-vpc-tgw-subnet"
  }

  public_subnet_tags = {
    Name = "inspection-vpc-firewall-subnet"
  }

}

#---------------------------------------------------------------------------
# Inspection VPC Firewall Endpoint and TGW Route
#---------------------------------------------------------------------------
resource "aws_route" "inspection_vpc_tgw_rt_route" {
  count                  = length(module.inspection_vpc.private_route_table_ids)
  route_table_id         = element(module.inspection_vpc.private_route_table_ids, count.index)
  vpc_endpoint_id        = (aws_networkfirewall_firewall.nfw.firewall_status[0].sync_states[*].attachment[0].endpoint_id)[count.index]
  destination_cidr_block = "0.0.0.0/0"

  depends_on = [
    aws_networkfirewall_firewall.nfw
  ]
}

resource "aws_route" "inspection_vpc_firewall_route" {
  count                  = length(module.inspection_vpc.public_route_table_ids)
  route_table_id         = element(module.inspection_vpc.public_route_table_ids, count.index)
  transit_gateway_id     = module.tgw.ec2_transit_gateway_id
  destination_cidr_block = "0.0.0.0/0"

  depends_on = [
    module.tgw
  ]
}
