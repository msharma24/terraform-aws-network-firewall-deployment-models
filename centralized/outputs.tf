output "spoke_vpc_a_ec2_instance_id" {
  description = "spoke vpc a instance ID"
  value       = module.spoke_vpc_a_ec2_instance.id
}

output "spoke_vpc_b_ec2_instance_id" {
  description = "spoke vpc b instance ID"
  value       = module.spoke_vpc_b_ec2_instance.id
}


output "ec2_transit_gateway_vpc_attachment_ids" {
  description = "List of EC2 Transit Gateway VPC Attachment identifiers"
  value       = module.tgw.ec2_transit_gateway_vpc_attachment_ids
}
