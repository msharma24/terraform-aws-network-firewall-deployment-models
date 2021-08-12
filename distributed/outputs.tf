output "vpc_id" {
  description = "Firewall Demo VPC ID"
  value       = aws_vpc.vpc.id
}

output "firewall_route_table_1" {
  description = "Firewall Route Table 1"
  value       = aws_route_table.firewall_route_table_1.id
}


output "firewall_route_table_2" {
  description = "Firewall Route Table 2"
  value       = aws_route_table.firewall_route_table_2.id

}



output "public_route_table_1" {
  description = "public Route Table 1"
  value       = aws_route_table.public_route_table_1.id
}


output "public_route_table_2" {
  description = "public Route Table 2"
  value       = aws_route_table.public_route_table_2.id

}


output "private_route_table_1" {
  description = "private Route Table 1"
  value       = aws_route_table.private_route_table_1.id
}


output "private_route_table_2" {
  description = "private Route Table 2"
  value       = aws_route_table.private_route_table_2.id

}

output "nat_gateway_1_id" {
  description = "NAT Gateway 1 ID"
  value       = aws_nat_gateway.nat_gateway_1.id
}


output "nat_gateway_2_id" {
  description = "NAT Gateway 2 ID"
  value       = aws_nat_gateway.nat_gateway_2.id
}

output "az_1" {
  value = data.aws_availability_zones.available.names[0]
}


output "az_2" {
  value = data.aws_availability_zones.available.names[1]
}
