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
      vpc_id = aws_vpc.inspection_vpc.id
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

#------------------------------------------------------------------------
# Firewall  Transit Gateway  Route Table
#------------------------------------------------------------------------

resource "aws_ec2_transit_gateway_route_table" "firewall_rt_table" {
  transit_gateway_id = module.tgw.ec2_transit_gateway_id
  tags = {
    Name = "firewall-route-table"
  }

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

data "aws_ec2_transit_gateway_vpc_attachment" "inspection_vpc_attachment" {
  filter {
    name   = "vpc-id"
    values = [aws_vpc.inspection_vpc.id]
  }
}


resource "aws_ec2_transit_gateway_route" "spoke_vpc_a_tgw_route" {
  transit_gateway_route_table_id = aws_ec2_transit_gateway_route_table.spoke_rt_table.id
  destination_cidr_block         = "0.0.0.0/0"
  transit_gateway_attachment_id  = data.aws_ec2_transit_gateway_vpc_attachment.inspection_vpc_attachment.id

}


#------------------------------------------------------------------------
# Transit Gateway
#------------------------------------------------------------------------
#
# resource "aws_ec2_transit_gateway" "tgw" {
#   description     = "development-transit-gateway"
#   amazon_side_asn = var.amazon_side_asn
#
#   auto_accept_shared_attachments = "enable"
#
#   default_route_table_propagation = "enable"
#   default_route_table_association = "disable"
#
#   vpn_ecmp_support = "enable"
#   dns_support      = "enable"
#
#   tags = {
#     Name      = "development-transit-gateway"
#     ManagedBy = "Terraform"
#
#   }
#
#
# }
#
# #------------------------------------------------------------------------
# # Spoke VPA A - TGW Attachment
# #------------------------------------------------------------------------
# resource "aws_ec2_transit_gateway_vpc_attachment" "spoke_vpc_a_tgw_attachment" {
#   vpc_id                                          = module.spoke_vpc_a.vpc_id
#   transit_gateway_id                              = aws_ec2_transit_gateway.tgw.id
#   subnet_ids                                      = module.spoke_vpc_a.private_subnets
#   transit_gateway_default_route_table_association = false
#   transit_gateway_default_route_table_propagation = true
#
#   tags = {
#     Name      = "spoke_vpc_a_tgw_attachment"
#     ManagedBy = "Terraform"
#
#   }
#
#
#
# }
#
# #------------------------------------------------------------------------
# # Spoke VPA B - TGW Attachment
# #------------------------------------------------------------------------
# resource "aws_ec2_transit_gateway_vpc_attachment" "spoke_vpc_b_tgw_attachment" {
#   vpc_id                                          = module.spoke_vpc_b.vpc_id
#   transit_gateway_id                              = aws_ec2_transit_gateway.tgw.id
#   subnet_ids                                      = module.spoke_vpc_b.private_subnets
#   transit_gateway_default_route_table_association = false
#   transit_gateway_default_route_table_propagation = true
#
#   tags = {
#     Name      = "spoke_vpc_b_tgw_attachment"
#     ManagedBy = "Terraform"
#
#   }
#
#
#
# }
#
# #------------------------------------------------------------------------
# # Firewall Inspection VPC  - TGW Attachment
# #------------------------------------------------------------------------
#
# resource "aws_ec2_transit_gateway_vpc_attachment" "inspection_vpc_tgw_attachment" {
#   vpc_id             = aws_vpc.inspection_vpc.id
#   transit_gateway_id = aws_ec2_transit_gateway.tgw.id
#   subnet_ids = [
#     aws_subnet.inspection_vpc_firewall_subnet_c.id,
#     aws_subnet.inspection_vpc_firewall_subnet_b.id,
#     aws_subnet.inspection_vpc_firewall_subnet_a.id
#
#
#   ]
#   transit_gateway_default_route_table_association = false
#   transit_gateway_default_route_table_propagation = true
#
#   /*
#    * Appliance Mode Enabled on the Firewall Inspection VPC
#    * See Notes section in README.md
#    */
#
#   appliance_mode_support = "enable"
#
#   tags = {
#     Name      = "inspection_vpc_tgw_attachment"
#     ManagedBy = "Terraform"
#
#   }
#
#
#
# }
#
# #------------------------------------------------------------------------
# # Firewall TGW Route Table
# # #------------------------------------------------------------------------
# resource "aws_ec2_transit_gateway_route_table" "firewall_tgw_route_table" {
#   transit_gateway_id = aws_ec2_transit_gateway.tgw.id
#
#   tags = {
#     Name      = "firewall_tgw_route_table"
#     ManagedBy = "Terraform"
#
#   }
#
# }
#
# resource "aws_ec2_transit_gateway_route" "firewall_tgw_route" {
#   transit_gateway_route_table_id = aws_ec2_transit_gateway_route_table.firewall_tgw_route_table.id
#   transit_gateway_attachment_id  = aws_ec2_transit_gateway_vpc_attachment.inspection_vpc_tgw_attachment.id
#   destination_cidr_block         = "0.0.0.0/0"
#
# }
#
# resource "aws_ec2_transit_gateway_route" "spoke_vpc_a_firewall_tgw_route" {
#   transit_gateway_route_table_id = aws_ec2_transit_gateway_route_table.firewall_tgw_route_table.id
#   transit_gateway_attachment_id  = aws_ec2_transit_gateway_vpc_attachment.spoke_vpc_a_tgw_attachment.id
#   destination_cidr_block         = module.spoke_vpc_a.vpc_cidr_block
#   blackhole                      = false
#
# }
#
# resource "aws_ec2_transit_gateway_route" "spoke_vpc_b_firewall_tgw_route" {
#   transit_gateway_route_table_id = aws_ec2_transit_gateway_route_table.firewall_tgw_route_table.id
#   transit_gateway_attachment_id  = aws_ec2_transit_gateway_vpc_attachment.spoke_vpc_b_tgw_attachment.id
#   destination_cidr_block         = module.spoke_vpc_b.vpc_cidr_block
#   blackhole                      = false
#
# }
# resource "aws_ec2_transit_gateway_route_table_association" "inspection_vpc_assoc" {
#   transit_gateway_attachment_id  = aws_ec2_transit_gateway_vpc_attachment.inspection_vpc_tgw_attachment.id
#   transit_gateway_route_table_id = aws_ec2_transit_gateway_route_table.firewall_tgw_route_table.id
#
# }
#
#
#
#
# #------------------------------------------------------------------------
# # Spoke TGW Route Table
# #------------------------------------------------------------------------
#
# resource "aws_ec2_transit_gateway_route_table" "spoke_tgw_route_table" {
#
#   transit_gateway_id = aws_ec2_transit_gateway.tgw.id
#
#   tags = {
#     Name      = "spoke_tgw_route_table"
#     ManagedBy = "Terraform"
#
#   }
# }
#
#
# resource "aws_ec2_transit_gateway_route" "spoke_tgw_route" {
#   transit_gateway_route_table_id = aws_ec2_transit_gateway_route_table.spoke_tgw_route_table.id
#   transit_gateway_attachment_id  = aws_ec2_transit_gateway_vpc_attachment.inspection_vpc_tgw_attachment.id
#   destination_cidr_block         = "0.0.0.0/0"
#
# }
#
# resource "aws_ec2_transit_gateway_route_table_association" "spoke_vpc_a_assoc" {
#   transit_gateway_attachment_id  = aws_ec2_transit_gateway_vpc_attachment.spoke_vpc_a_tgw_attachment.id
#   transit_gateway_route_table_id = aws_ec2_transit_gateway_route_table.spoke_tgw_route_table.id
#
# }
#
#
# resource "aws_ec2_transit_gateway_route_table_association" "spoke_vpc_b_assoc" {
#   transit_gateway_attachment_id  = aws_ec2_transit_gateway_vpc_attachment.spoke_vpc_b_tgw_attachment.id
#   transit_gateway_route_table_id = aws_ec2_transit_gateway_route_table.spoke_tgw_route_table.id
#
# }
#
#
#
# ################################################################################
# # Transit Gateway Route in the attached vpc subnets
# ################################################################################
#
#
# resource "aws_route" "spoke_vpc_a_tgw_route" {
#   count                  = length(module.spoke_vpc_a.private_route_table_ids)
#   route_table_id         = module.spoke_vpc_a.private_route_table_ids[count.index]
#   destination_cidr_block = "0.0.0.0/0"
#   transit_gateway_id     = aws_ec2_transit_gateway.tgw.id
#
#   depends_on = [
#     aws_ec2_transit_gateway.tgw
#   ]
#
# }
#
#
# resource "aws_route" "spoke_vpc_b_tgw_route" {
#   count                  = length(module.spoke_vpc_b.private_route_table_ids)
#   route_table_id         = module.spoke_vpc_b.private_route_table_ids[count.index]
#   destination_cidr_block = "0.0.0.0/0"
#   transit_gateway_id     = aws_ec2_transit_gateway.tgw.id
#   depends_on = [
#     aws_ec2_transit_gateway.tgw
#   ]
#
# }
#
#
