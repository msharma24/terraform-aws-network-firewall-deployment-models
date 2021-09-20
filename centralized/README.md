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
terraform apply  [-auto-approve]
```

### Testing Firewall Rules
Log in to the AWS Console after deploying the Terraform Configuration and go ta **AWS Systems Manager >> Session Manager** and start a Session with one of the EC2 instacnes  :-

1 - try to SSH to the EC2 Instance in `spoke-vpc-b` from the EC2 Instance in `spoke-vpc-a` (or vice-versa) ==>  this shouldn't work

2 - try to curl the private IP of the EC2 Instance in `spoke-vpc-b` from the EC2 Instance in `spoke-vpc-a`: ==> this should work and display nginx homepage

3 - try to `curl https://facebook.com` or` https://yahoo.com `from either `spoke-vpc-a` or `spoke-vpc-b` ==> this shouldn't work

4 -  try a ping to a public IP address: this shouldn't work `ping 8.8.8.8`

5 - try to `dig` using a public DNS resolver: this shouldn't work `dig google.com`

6 - try to curl any other public URL: this should work 

#### Testing Emerging Threat Suricata Open Ruleset
The user data script of the EC2 instances in installing `nc` so that we can sample test the Emerging Threat Open Ruleset using a simple command line utility created by [testmynids.org](https://github.com/3CORESec/testmynids.org) - A website and framework for testing NIDS detection.


Login to one of the EC2 instances via SSM Session Manager and run the following `curl` command to execute sample 

`curl -sSL https://raw.githubusercontent.com/3CORESec/testmynids.org/master/tmNIDS -o /tmp/tmNIDS && chmod +x /tmp/tmNIDS && /tmp/tmNIDS -99
`

This command will run the following [tests](https://github.com/3CORESec/testmynids.org#included-tests)

Once the command execution completes, go back to the AWS Console and access Cloud-watch Log group 


#### Notes:
[Appliance Mode Enabled on the Firewall Inspection VPC](https://aws.amazon.com/blogs/networking-and-content-delivery/centralized-inspection-architecture-with-aws-gateway-load-balancer-and-aws-transit-gateway/)


<!-- BEGINNING OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >= 1.0.0 |
| <a name="requirement_aws"></a> [aws](#requirement\_aws) | >=3.58.0 |
| <a name="requirement_random"></a> [random](#requirement\_random) | >=2.3.0 |
| <a name="requirement_template"></a> [template](#requirement\_template) | >=2.2.0 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_aws"></a> [aws](#provider\_aws) | 3.58.0 |
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
| [aws_networkfirewall_rule_group.et_open_rulselt_fw_rule_group](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/networkfirewall_rule_group) | resource |
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
| [aws_ami.amazon_linux_2](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/ami) | data source |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_environment"></a> [environment](#input\_environment) | Deployment environment name | `string` | `"dev"` | no |
| <a name="input_region"></a> [region](#input\_region) | AWS Deployment region | `string` | `"ap-southeast-2"` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_ec2_transit_gateway_vpc_attachment_ids"></a> [ec2\_transit\_gateway\_vpc\_attachment\_ids](#output\_ec2\_transit\_gateway\_vpc\_attachment\_ids) | List of EC2 Transit Gateway VPC Attachment identifiers |
| <a name="output_spoke_vpc_a_ec2_instance_id"></a> [spoke\_vpc\_a\_ec2\_instance\_id](#output\_spoke\_vpc\_a\_ec2\_instance\_id) | spoke vpc a instance ID |
| <a name="output_spoke_vpc_b_ec2_instance_id"></a> [spoke\_vpc\_b\_ec2\_instance\_id](#output\_spoke\_vpc\_b\_ec2\_instance\_id) | spoke vpc b instance ID |
<!-- END OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
