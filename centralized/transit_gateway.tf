resource "aws_ec2_transit_gateway" "tgw" {
  description     = "development-transit-gateway"
  amazon_side_asn = var.amazon_side_asn

  auto_accept_shared_attachments  = "enable"
  default_route_table_propagation = "enable"
  default_route_table_association = "disable"

  tags = {
    Name      = "development-transit-gateway"
    ManagedBy = "Terraform"

  }


}

