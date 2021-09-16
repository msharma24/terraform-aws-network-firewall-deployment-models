# Centralized AWS Network Firewall Deployment Model

## Description
Centralized AWS Network Firewall Deployment Demo Infrastrcutre Using Terraform Community Open Source Models

[AWS Centralized Network Firewall Architecture Documentation]
(https://aws.amazon.com/blogs/networking-and-content-delivery/deployment-models-for-aws-network-firewall/)

## Setup
This configuration has been tested in "ap-southeast-2" and "us-east-1" region

```
terraform init
terraform plan
terraform apply -auto-approve
```

### Tests
Log in to the AWS Console after deploying the Terraform Configruation and Login to the EC2 via AWS System Manager >> Session Manager
and then you can test the firewall rules in action :-
- try to SSH to the EC2 Instance in `spoke-vpc-b` from the EC2 Instance in `spoke-vpc-a` (or vice-versa): this shouldn't work
- try to curl the private IP of the EC2 Instance in `spoke-vpc-b` from the EC2 Instance in `spoke-vpc-a` - this should work and display nginx homepage
- try to curl https://facebook.com or https://yahoo.com from either `spoke-vpc-a` or `spoke-vpc-b`-  this shouldn't work
- try a ping to a public IP address: this shouldn't work `ping 8.8.8.8`
- try to `dig` using a public DNS resolver: this shouldn't work `dig google.com`
- try to curl any other public URL: this should work

#### Notes:
[Appliance Mode Enabled on the Firewall Inspection VPC](https://aws.amazon.com/blogs/networking-and-content-delivery/centralized-inspection-architecture-with-aws-gateway-load-balancer-and-aws-transit-gateway/)


<!-- BEGINNING OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
## Requirements

No requirements.

## Providers

| Name | Version |
|------|---------|
| <a name="provider_aws"></a> [aws](#provider\_aws) | 3.56.0 |
| <a name="provider_random"></a> [random](#provider\_random) | 3.1.0 |

## Modules

| Name | Source | Version |
|------|--------|---------|
| <a name="module_egress_vpc"></a> [egress\_vpc](#module\_egress\_vpc) | terraform-aws-modules/vpc/aws | 3.0.0 |
| <a name="module_spoke_instance_iam_assumable_role"></a> [spoke\_instance\_iam\_assumable\_role](#module\_spoke\_instance\_iam\_assumable\_role) | terraform-aws-modules/iam/aws//modules/iam-assumable-role | ~> 4.5 |
| <a name="module_spoke_vpc_a"></a> [spoke\_vpc\_a](#module\_spoke\_vpc\_a) | terraform-aws-modules/vpc/aws | 3.0.0 |
| <a name="module_spoke_vpc_a_ec2_instance"></a> [spoke\_vpc\_a\_ec2\_instance](#module\_spoke\_vpc\_a\_ec2\_instance) | terraform-aws-modules/ec2-instance/aws | ~> 2.0 |
| <a name="module_spoke_vpc_a_https_sg"></a> [spoke\_vpc\_a\_https\_sg](#module\_spoke\_vpc\_a\_https\_sg) | terraform-aws-modules/security-group/aws//modules/https-443 | n/a |
| <a name="module_spoke_vpc_a_ssh_sg"></a> [spoke\_vpc\_a\_ssh\_sg](#module\_spoke\_vpc\_a\_ssh\_sg) | terraform-aws-modules/security-group/aws//modules/ssh | n/a |
| <a name="module_spoke_vpc_a_ssm_endpoint"></a> [spoke\_vpc\_a\_ssm\_endpoint](#module\_spoke\_vpc\_a\_ssm\_endpoint) | terraform-aws-modules/vpc/aws//modules/vpc-endpoints | n/a |
| <a name="module_spoke_vpc_b"></a> [spoke\_vpc\_b](#module\_spoke\_vpc\_b) | terraform-aws-modules/vpc/aws | 3.0.0 |
| <a name="module_spoke_vpc_b_ec2_instance"></a> [spoke\_vpc\_b\_ec2\_instance](#module\_spoke\_vpc\_b\_ec2\_instance) | terraform-aws-modules/ec2-instance/aws | ~> 2.0 |
| <a name="module_spoke_vpc_b_http_sg"></a> [spoke\_vpc\_b\_http\_sg](#module\_spoke\_vpc\_b\_http\_sg) | terraform-aws-modules/security-group/aws//modules/http-80 | n/a |
| <a name="module_spoke_vpc_b_https_sg"></a> [spoke\_vpc\_b\_https\_sg](#module\_spoke\_vpc\_b\_https\_sg) | terraform-aws-modules/security-group/aws//modules/https-443 | n/a |
| <a name="module_spoke_vpc_b_ssh_sg"></a> [spoke\_vpc\_b\_ssh\_sg](#module\_spoke\_vpc\_b\_ssh\_sg) | terraform-aws-modules/security-group/aws//modules/ssh | n/a |
| <a name="module_spoke_vpc_b_ssm_endpoint"></a> [spoke\_vpc\_b\_ssm\_endpoint](#module\_spoke\_vpc\_b\_ssm\_endpoint) | terraform-aws-modules/vpc/aws//modules/vpc-endpoints | n/a |
| <a name="module_tgw"></a> [tgw](#module\_tgw) | terraform-aws-modules/transit-gateway/aws | ~> 2.0 |

## Resources

| Name | Type |
|------|------|
| [aws_cloudwatch_log_group.anfw_alert_log_group](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/cloudwatch_log_group) | resource |
| [aws_ec2_transit_gateway_route.egress_vpc_attachment](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/ec2_transit_gateway_route) | resource |
| [aws_ec2_transit_gateway_route.inspection_vpc_route](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/ec2_transit_gateway_route) | resource |
| [aws_ec2_transit_gateway_route.inspection_vpc_tgw_route](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/ec2_transit_gateway_route) | resource |
| [aws_ec2_transit_gateway_route.spoke_vpc_a_tgw_route](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/ec2_transit_gateway_route) | resource |
| [aws_ec2_transit_gateway_route.spoke_vpc_b_tgw_route](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/ec2_transit_gateway_route) | resource |
| [aws_ec2_transit_gateway_route_table.egress_rt_table](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/ec2_transit_gateway_route_table) | resource |
| [aws_ec2_transit_gateway_route_table.firewall_rt_table](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/ec2_transit_gateway_route_table) | resource |
| [aws_ec2_transit_gateway_route_table.spoke_rt_table](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/ec2_transit_gateway_route_table) | resource |
| [aws_networkfirewall_firewall.nfw](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/networkfirewall_firewall) | resource |
| [aws_networkfirewall_firewall_policy.nfw_default_policy](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/networkfirewall_firewall_policy) | resource |
| [aws_networkfirewall_logging_configuration.anfw_alert_logging_configuration](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/networkfirewall_logging_configuration) | resource |
| [aws_networkfirewall_rule_group.block_domains_fw_rule_group](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/networkfirewall_rule_group) | resource |
| [aws_networkfirewall_rule_group.block_public_dns_resolvers](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/networkfirewall_rule_group) | resource |
| [aws_networkfirewall_rule_group.drop_icmp_traffic_fw_rule_group](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/networkfirewall_rule_group) | resource |
| [aws_networkfirewall_rule_group.drop_non_http_between_vpcs](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/networkfirewall_rule_group) | resource |
| [aws_route.egress_vpc_route_to_tgw](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/route) | resource |
| [aws_route.spoke_vpc_a_tgw_route](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/route) | resource |
| [aws_route.spoke_vpc_b_tgw_route](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/route) | resource |
| [aws_route_table.inspection_vpc_firewall_rt_1](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/route_table) | resource |
| [aws_route_table.inspection_vpc_firewall_rt_2](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/route_table) | resource |
| [aws_route_table.inspection_vpc_firewall_rt_3](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/route_table) | resource |
| [aws_route_table.inspection_vpc_tgw_rt_1](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/route_table) | resource |
| [aws_route_table.inspection_vpc_tgw_rt_2](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/route_table) | resource |
| [aws_route_table.inspection_vpc_tgw_rt_3](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/route_table) | resource |
| [aws_route_table_association.firewall_subnet_association_a](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/route_table_association) | resource |
| [aws_route_table_association.firewall_subnet_association_b](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/route_table_association) | resource |
| [aws_route_table_association.firewall_subnet_association_c](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/route_table_association) | resource |
| [aws_route_table_association.tgw_subnet_association_a](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/route_table_association) | resource |
| [aws_route_table_association.tgw_subnet_association_b](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/route_table_association) | resource |
| [aws_route_table_association.tgw_subnet_association_c](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/route_table_association) | resource |
| [aws_s3_bucket.anfw_flow_bucket](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/s3_bucket) | resource |
| [aws_s3_bucket_public_access_block.anfw_flow_bucket_public_access_block](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/s3_bucket_public_access_block) | resource |
| [aws_subnet.inspection_vpc_firewall_subnet_a](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/subnet) | resource |
| [aws_subnet.inspection_vpc_firewall_subnet_b](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/subnet) | resource |
| [aws_subnet.inspection_vpc_firewall_subnet_c](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/subnet) | resource |
| [aws_subnet.inspection_vpc_tgw_subnet_a](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/subnet) | resource |
| [aws_subnet.inspection_vpc_tgw_subnet_b](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/subnet) | resource |
| [aws_subnet.inspection_vpc_tgw_subnet_c](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/subnet) | resource |
| [aws_vpc.inspection_vpc](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/vpc) | resource |
| [random_id.random_id](https://registry.terraform.io/providers/hashicorp/random/latest/docs/resources/id) | resource |
| [random_string.bucket_random_id](https://registry.terraform.io/providers/hashicorp/random/latest/docs/resources/string) | resource |
| [aws_ami.amazon-linux-2](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/ami) | data source |
| [aws_availability_zones.available](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/availability_zones) | data source |
| [aws_caller_identity.current](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/caller_identity) | data source |
| [aws_ec2_transit_gateway_vpc_attachment.egress_vpc_attachment](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/ec2_transit_gateway_vpc_attachment) | data source |
| [aws_ec2_transit_gateway_vpc_attachment.spoke_vpc_a_attachment](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/ec2_transit_gateway_vpc_attachment) | data source |
| [aws_ec2_transit_gateway_vpc_attachment.spoke_vpc_b_attachment](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/ec2_transit_gateway_vpc_attachment) | data source |
| [aws_security_group.spoke_vpc_a_default_sg](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/security_group) | data source |
| [aws_security_group.spoke_vpc_b_default_sg](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/security_group) | data source |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_amazon_side_asn"></a> [amazon\_side\_asn](#input\_amazon\_side\_asn) | The Autonomous System Number (ASN) for the Amazon side of the gateway. By default the TGW is created with the current default Amazon ASN. | `string` | `"64512"` | no |
| <a name="input_environment"></a> [environment](#input\_environment) | n/a | `string` | `"dev"` | no |
| <a name="input_region"></a> [region](#input\_region) | AWS Deployment region | `any` | n/a | yes |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_ec2_transit_gateway_vpc_attachment_ids"></a> [ec2\_transit\_gateway\_vpc\_attachment\_ids](#output\_ec2\_transit\_gateway\_vpc\_attachment\_ids) | List of EC2 Transit Gateway VPC Attachment identifiers |
| <a name="output_iam_instance_profile_arn"></a> [iam\_instance\_profile\_arn](#output\_iam\_instance\_profile\_arn) | n/a |
| <a name="output_spoke_vpc_a_ec2_instance_id"></a> [spoke\_vpc\_a\_ec2\_instance\_id](#output\_spoke\_vpc\_a\_ec2\_instance\_id) | n/a |
| <a name="output_spoke_vpc_b_ec2_instance_id"></a> [spoke\_vpc\_b\_ec2\_instance\_id](#output\_spoke\_vpc\_b\_ec2\_instance\_id) | n/a |
<!-- END OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
