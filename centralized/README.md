# Centralized AWS Network Firewall Deployment Model


## Description
Centralized AWS Network Firewall Deployment Infrastructure Using available [Terraform Community  Modules](https://github.com/terraform-aws-modules)


![centralized-anfw](https://github.com/msharma24/terraform-aws-network-firewall-deployment-models/blob/main/centralized/images/centralized-anfw.png)



## Setup
This configuration has been tested in "ap-southeast-2" and "us-east-1" region

```
terraform init
terraform plan
terraform apply  [-auto-approve]
```

### Testing Firewall Rules

Log in to the AWS Console after deploying the Terraform Configuration and go ta **AWS Systems Manager >> Session Manager** and start a Session with one of the EC2 Instances named `dev/spoke_vpc_a_instance`  :-

1 - try to SSH to the Private IP of the EC2 Instance in `spoke-vpc-b` from the EC2 Instance in `spoke-vpc-a` (or vice-versa) ==>  this shouldn't work . However `telnet EC2_Private_Ip:22` will work

2 - try to curl the private IP of the EC2 Instance in `spoke-vpc-b` from the EC2 Instance in `spoke-vpc-a`: ==> this should work and display nginx homepage ``` curl http://<Spoke_VPC_B>:80/```

3 - try to `curl https://facebook.com` or` https://yahoo.com `from either `spoke-vpc-a` or `spoke-vpc-b` ==> this shouldn't work

```
{
    "firewall_name": "centralized-network-firewall",
    "availability_zone": "us-east-1c",
    "event_timestamp": "1632271315",
    "event": {
        "timestamp": "2021-09-22T00:41:55.348195+0000",
        "flow_id": 1549540378476749,
        "event_type": "alert",
        "src_ip": "10.0.101.147",
        "src_port": 58752,
        "dest_ip": "74.6.143.26",
        "dest_port": 80,
        "proto": "TCP",
        "tx_id": 0,
        "alert": {
            "action": "blocked",
            "signature_id": 3,
            "rev": 1,
            "signature": "matching HTTP denylisted FQDNs",
            "category": "",
            "severity": 1
        },
        "http": {
            "hostname": "www.yahoo.com",
            "url": "/",
            "http_user_agent": "curl/7.76.1",
            "http_method": "GET",
            "protocol": "HTTP/1.1",
            "length": 0
        },
        "app_proto": "http"
    }
}
```

4 -  try a ping to a public IP address: this shouldn't work `ping 8.8.8.8` and generate an alert in Network Firewall CloudWatch Log Group.

## Testing Emerging Threat Suricata Open Ruleset
The user data script of the EC2 instances in installing `nc` so that we can sample test the Emerging Threat Open Ruleset using a simple command line utility created by [testmynids.org](https://github.com/3CORESec/testmynids.org) - *A website and framework for testing NIDS detection.*


Login to one of the EC2 instances via SSM Session Manager and run the following `curl` command to execute sample 

`curl -sSL https://raw.githubusercontent.com/3CORESec/testmynids.org/master/tmNIDS -o /tmp/tmNIDS && chmod +x /tmp/tmNIDS && /tmp/tmNIDS -99
`

This command will run the following [tests](https://github.com/3CORESec/testmynids.org#included-tests)

Once the command execution completes, go back to the AWS Console and access Cloud-watch Log group 


#### Notes:
[Appliance Mode Enabled on the Firewall Inspection VPC](https://aws.amazon.com/blogs/networking-and-content-delivery/centralized-inspection-architecture-with-aws-gateway-load-balancer-and-aws-transit-gateway/)


### Delete the resources when you don't need them.
`terraform destroy [-auto-approve]`

<!-- BEGINNING OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >= 1.0.0 |
| <a name="requirement_aws"></a> [aws](#requirement\_aws) | =4.30.0 |
| <a name="requirement_random"></a> [random](#requirement\_random) | >=2.3.0 |
| <a name="requirement_template"></a> [template](#requirement\_template) | >=2.2.0 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_aws"></a> [aws](#provider\_aws) | 4.30.0 |
| <a name="provider_random"></a> [random](#provider\_random) | 3.4.3 |

## Modules

| Name | Source | Version |
|------|--------|---------|
| <a name="module_egress_vpc"></a> [egress\_vpc](#module\_egress\_vpc) | terraform-aws-modules/vpc/aws | 3.0.0 |
| <a name="module_inspection_vpc"></a> [inspection\_vpc](#module\_inspection\_vpc) | terraform-aws-modules/vpc/aws | 3.0.0 |
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
| <a name="module_tgw"></a> [tgw](#module\_tgw) | terraform-aws-modules/transit-gateway/aws | 2.8.0 |

## Resources

| Name | Type |
|------|------|
| [aws_cloudwatch_log_group.anfw_alert_log_group](https://registry.terraform.io/providers/hashicorp/aws/4.30.0/docs/resources/cloudwatch_log_group) | resource |
| [aws_cloudwatch_log_group.anfw_flow_log_group](https://registry.terraform.io/providers/hashicorp/aws/4.30.0/docs/resources/cloudwatch_log_group) | resource |
| [aws_ec2_transit_gateway_route.egress_vpc_attachment](https://registry.terraform.io/providers/hashicorp/aws/4.30.0/docs/resources/ec2_transit_gateway_route) | resource |
| [aws_ec2_transit_gateway_route.inspection_vpc_route](https://registry.terraform.io/providers/hashicorp/aws/4.30.0/docs/resources/ec2_transit_gateway_route) | resource |
| [aws_ec2_transit_gateway_route.inspection_vpc_tgw_route](https://registry.terraform.io/providers/hashicorp/aws/4.30.0/docs/resources/ec2_transit_gateway_route) | resource |
| [aws_ec2_transit_gateway_route.spoke_vpc_a_tgw_route](https://registry.terraform.io/providers/hashicorp/aws/4.30.0/docs/resources/ec2_transit_gateway_route) | resource |
| [aws_ec2_transit_gateway_route.spoke_vpc_b_tgw_route](https://registry.terraform.io/providers/hashicorp/aws/4.30.0/docs/resources/ec2_transit_gateway_route) | resource |
| [aws_ec2_transit_gateway_route_table.egress_rt_table](https://registry.terraform.io/providers/hashicorp/aws/4.30.0/docs/resources/ec2_transit_gateway_route_table) | resource |
| [aws_ec2_transit_gateway_route_table.firewall_rt_table](https://registry.terraform.io/providers/hashicorp/aws/4.30.0/docs/resources/ec2_transit_gateway_route_table) | resource |
| [aws_ec2_transit_gateway_route_table.spoke_rt_table](https://registry.terraform.io/providers/hashicorp/aws/4.30.0/docs/resources/ec2_transit_gateway_route_table) | resource |
| [aws_networkfirewall_firewall.nfw](https://registry.terraform.io/providers/hashicorp/aws/4.30.0/docs/resources/networkfirewall_firewall) | resource |
| [aws_networkfirewall_firewall_policy.nfw_default_policy](https://registry.terraform.io/providers/hashicorp/aws/4.30.0/docs/resources/networkfirewall_firewall_policy) | resource |
| [aws_networkfirewall_logging_configuration.anfw_alert_logging_configuration](https://registry.terraform.io/providers/hashicorp/aws/4.30.0/docs/resources/networkfirewall_logging_configuration) | resource |
| [aws_networkfirewall_rule_group.block_domains_fw_rule_group](https://registry.terraform.io/providers/hashicorp/aws/4.30.0/docs/resources/networkfirewall_rule_group) | resource |
| [aws_networkfirewall_rule_group.block_public_dns_resolvers](https://registry.terraform.io/providers/hashicorp/aws/4.30.0/docs/resources/networkfirewall_rule_group) | resource |
| [aws_networkfirewall_rule_group.drop_icmp_traffic_fw_rule_group](https://registry.terraform.io/providers/hashicorp/aws/4.30.0/docs/resources/networkfirewall_rule_group) | resource |
| [aws_networkfirewall_rule_group.et_open_rulselt_fw_rule_group](https://registry.terraform.io/providers/hashicorp/aws/4.30.0/docs/resources/networkfirewall_rule_group) | resource |
| [aws_route.egress_vpc_route_to_tgw](https://registry.terraform.io/providers/hashicorp/aws/4.30.0/docs/resources/route) | resource |
| [aws_route.inspection_vpc_firewall_route](https://registry.terraform.io/providers/hashicorp/aws/4.30.0/docs/resources/route) | resource |
| [aws_route.inspection_vpc_tgw_rt_route](https://registry.terraform.io/providers/hashicorp/aws/4.30.0/docs/resources/route) | resource |
| [aws_route.spoke_vpc_a_tgw_route](https://registry.terraform.io/providers/hashicorp/aws/4.30.0/docs/resources/route) | resource |
| [aws_route.spoke_vpc_b_tgw_route](https://registry.terraform.io/providers/hashicorp/aws/4.30.0/docs/resources/route) | resource |
| [random_id.random_id](https://registry.terraform.io/providers/hashicorp/random/latest/docs/resources/id) | resource |
| [aws_ami.amazon_linux_2](https://registry.terraform.io/providers/hashicorp/aws/4.30.0/docs/data-sources/ami) | data source |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_environment"></a> [environment](#input\_environment) | Deployment environment name | `string` | `"dev"` | no |
| <a name="input_region"></a> [region](#input\_region) | AWS Deployment region | `string` | `"us-east-1"` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_ec2_transit_gateway_vpc_attachment_ids"></a> [ec2\_transit\_gateway\_vpc\_attachment\_ids](#output\_ec2\_transit\_gateway\_vpc\_attachment\_ids) | List of EC2 Transit Gateway VPC Attachment identifiers |
| <a name="output_spoke_vpc_a_ec2_instance_id"></a> [spoke\_vpc\_a\_ec2\_instance\_id](#output\_spoke\_vpc\_a\_ec2\_instance\_id) | spoke vpc a instance ID |
| <a name="output_spoke_vpc_b_ec2_instance_id"></a> [spoke\_vpc\_b\_ec2\_instance\_id](#output\_spoke\_vpc\_b\_ec2\_instance\_id) | spoke vpc b instance ID |
<!-- END OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
