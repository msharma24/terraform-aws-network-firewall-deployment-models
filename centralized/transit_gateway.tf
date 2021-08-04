resource "aws_ec2_transit_gateway" "tgw" {
  description     = "development-transit-gateway"
  amazon_side_asn = var.amazon_side_asn

  auto_accept_shared_attachments = "enable"

  default_route_table_propagation = "enable"
  default_route_table_association = "disable"

  vpn_ecmp_support = "enable"
  dns_support      = "enable"

  tags = {
    Name      = "development-transit-gateway"
    ManagedBy = "Terraform"

  }


}


resource "aws_ec2_transit_gateway_vpc_attachment" "spoke_vpc_a_tgw_attachment" {
  vpc_id                                          = module.spoke_vpc_a.vpc_id
  transit_gateway_id                              = aws_ec2_transit_gateway.tgw.id
  subnet_ids                                      = module.spoke_vpc_a.private_subnets
  transit_gateway_default_route_table_association = false
  transit_gateway_default_route_table_propagation = true

  tags = {
    Name      = "spoke_vpc_a_tgw_attachment"
    ManagedBy = "Terraform"

  }



}

resource "aws_ec2_transit_gateway_vpc_attachment" "spoke_vpc_b_tgw_attachment" {
  vpc_id                                          = module.spoke_vpc_b.vpc_id
  transit_gateway_id                              = aws_ec2_transit_gateway.tgw.id
  subnet_ids                                      = module.spoke_vpc_b.private_subnets
  transit_gateway_default_route_table_association = false
  transit_gateway_default_route_table_propagation = true

  tags = {
    Name      = "spoke_vpc_b_tgw_attachment"
    ManagedBy = "Terraform"

  }



}


resource "aws_ec2_transit_gateway_vpc_attachment" "inspection_vpc_tgw_attachment" {
  vpc_id             = aws_vpc.inspection_vpc.id
  transit_gateway_id = aws_ec2_transit_gateway.tgw.id
  subnet_ids = [
    aws_subnet.inspection_vpc_tgw_subnet_a.id,
    aws_subnet.inspection_vpc_tgw_subnet_b.id,
    aws_subnet.inspection_vpc_tgw_subnet_c.id
  ]
  transit_gateway_default_route_table_association = false
  transit_gateway_default_route_table_propagation = true

  /*
   * Appliance Mode Enabled on the Firewall Inspection VPC
   * See Notes section in README.md
   */

  appliance_mode_support = "enable"

  tags = {
    Name      = "inspection_vpc_tgw_attachment"
    ManagedBy = "Terraform"

  }



}

