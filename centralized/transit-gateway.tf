module "tgw" {
  source  = "terraform-aws-modules/transit-gateway/aws"
  version = "~> 2.0"

  name        = "centralized-firewall-transit-gateway"
  description = "My TGW shared with several other AWS accounts"

  enable_auto_accept_shared_attachments  = true
  enable_default_route_table_association = false
  enable_default_route_table_propagation = true

  vpc_attachments = {
    spoke_vpc_a = {
      vpc_id                                          = module.spoke_vpc_a.vpc_id
      subnet_ids                                      = module.spoke_vpc_a.private_subnets
      transit_gateway_default_route_table_association = false
      transit_gateway_default_route_table_propagation = true
      dns_support                                     = true
      ipv6_support                                    = false
      transit_gateway_route_table_id                  = aws_ec2_transit_gateway_route_table.spoke_rt_table.id
    },
    spoke_vpc_b = {
      vpc_id                                          = module.spoke_vpc_b.vpc_id
      subnet_ids                                      = module.spoke_vpc_b.private_subnets
      transit_gateway_default_route_table_association = false
      transit_gateway_default_route_table_propagation = true
      ipv6_support                                    = false
      transit_gateway_route_table_id                  = aws_ec2_transit_gateway_route_table.spoke_rt_table.id
    },
    inspection_vpc = {
      vpc_id                 = aws_vpc.inspection_vpc.id
      appliance_mode_support = true
      subnet_ids = [
        aws_subnet.inspection_vpc_firewall_subnet_a.id,
        aws_subnet.inspection_vpc_firewall_subnet_b.id,
        aws_subnet.inspection_vpc_firewall_subnet_c.id,
      ]
      transit_gateway_default_route_table_association = false
      transit_gateway_default_route_table_propagation = true
      ipv6_support                                    = false
      transit_gateway_route_table_id                  = aws_ec2_transit_gateway_route_table.firewall_rt_table.id
    },
    egress_vpc = {
      vpc_id                                          = module.egress_vpc.vpc_id
      subnet_ids                                      = module.egress_vpc.private_subnets
      transit_gateway_default_route_table_association = false
      transit_gateway_default_route_table_propagation = true
      ipv6_support                                    = false
      transit_gateway_route_table_id                  = aws_ec2_transit_gateway_route_table.egress_rt_table.id
    }
  }

  ram_allow_external_principals = true

  tags = {
    Purpose = "tgw-complete-example"
  }
}

#------------------------------------------------------------------------
# Egress Transit Gateway  Route Table
#------------------------------------------------------------------------
resource "aws_ec2_transit_gateway_route_table" "egress_rt_table" {
  transit_gateway_id = module.tgw.ec2_transit_gateway_id
  tags = {
    Name = "egress-route-table"
  }

}

resource "aws_ec2_transit_gateway_route" "inspection_vpc_route" {
  transit_gateway_route_table_id = aws_ec2_transit_gateway_route_table.egress_rt_table.id
  destination_cidr_block         = "0.0.0.0/0"
  transit_gateway_attachment_id  = module.tgw.ec2_transit_gateway_vpc_attachment["inspection_vpc"]["id"]
  blackhole                      = false

}
#------------------------------------------------------------------------
# Firewall  Transit Gateway  Route Table
#------------------------------------------------------------------------

resource "aws_ec2_transit_gateway_route_table" "firewall_rt_table" {
  transit_gateway_id = module.tgw.ec2_transit_gateway_id
  tags = {
    Name = "firewall-route-table"
  }

}

data "aws_ec2_transit_gateway_vpc_attachment" "egress_vpc_attachment" {
  filter {
    name   = "vpc-id"
    values = [module.egress_vpc.vpc_id]
  }

  depends_on = [
    module.tgw
  ]
}

data "aws_ec2_transit_gateway_vpc_attachment" "spoke_vpc_a_attachment" {
  filter {
    name   = "vpc-id"
    values = [module.spoke_vpc_a.vpc_id]
  }

  depends_on = [
    module.tgw
  ]
}

data "aws_ec2_transit_gateway_vpc_attachment" "spoke_vpc_b_attachment" {
  filter {
    name   = "vpc-id"
    values = [module.spoke_vpc_b.vpc_id]
  }

  depends_on = [
    module.tgw
  ]
}

resource "aws_ec2_transit_gateway_route" "spoke_vpc_b_tgw_route" {
  transit_gateway_attachment_id  = module.tgw.ec2_transit_gateway_vpc_attachment["spoke_vpc_b"]["id"]
  destination_cidr_block         = module.spoke_vpc_b.vpc_cidr_block
  transit_gateway_route_table_id = aws_ec2_transit_gateway_route_table.firewall_rt_table.id

}

resource "aws_ec2_transit_gateway_route" "egress_vpc_attachment" {
  transit_gateway_attachment_id  = module.tgw.ec2_transit_gateway_vpc_attachment["egress_vpc"]["id"]
  destination_cidr_block         = "0.0.0.0/0"
  transit_gateway_route_table_id = aws_ec2_transit_gateway_route_table.firewall_rt_table.id

}

resource "aws_ec2_transit_gateway_route" "spoke_vpc_a_tgw_route" {
  transit_gateway_attachment_id  = module.tgw.ec2_transit_gateway_vpc_attachment["spoke_vpc_a"]["id"]
  destination_cidr_block         = module.spoke_vpc_a.vpc_cidr_block
  transit_gateway_route_table_id = aws_ec2_transit_gateway_route_table.firewall_rt_table.id

}

#------------------------------------------------------------------------
# Spoke  Transit Gateway  Route Table
#------------------------------------------------------------------------
resource "aws_ec2_transit_gateway_route_table" "spoke_rt_table" {
  transit_gateway_id = module.tgw.ec2_transit_gateway_id
  tags = {
    Name = "spoke-route-table"
  }

}

resource "aws_ec2_transit_gateway_route" "inspection_vpc_tgw_route" {
  transit_gateway_route_table_id = aws_ec2_transit_gateway_route_table.spoke_rt_table.id
  destination_cidr_block         = "0.0.0.0/0"
  transit_gateway_attachment_id  = module.tgw.ec2_transit_gateway_vpc_attachment["inspection_vpc"]["id"]

}

