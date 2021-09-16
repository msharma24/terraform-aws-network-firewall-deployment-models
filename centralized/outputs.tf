output "spoke_vpc_a_ec2_instance_id" {
  value = module.spoke_vpc_a_ec2_instance.id
}

output "spoke_vpc_b_ec2_instance_id" {
  value = module.spoke_vpc_b_ec2_instance.id
}


output "ec2_transit_gateway_vpc_attachment_ids" {
  description = "List of EC2 Transit Gateway VPC Attachment identifiers"
  value       = module.tgw.ec2_transit_gateway_vpc_attachment_ids
}


output "iam_instance_profile_arn" {
  value = module.spoke_instance_iam_assumable_role.iam_instance_profile_arn
}
