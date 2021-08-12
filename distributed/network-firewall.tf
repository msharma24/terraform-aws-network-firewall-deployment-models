resource "aws_networkfirewall_firewall_policy" "test" {
  name = "example"

  firewall_policy {
    stateless_default_actions          = ["aws:pass", "ExampleCustomAction"]
    stateless_fragment_default_actions = ["aws:drop"]

    stateless_custom_action {
      action_definition {
        publish_metric_action {
          dimension {
            value = "1"
          }
        }
      }
      action_name = "ExampleCustomAction"
    }
  }
}

resource "aws_networkfirewall_firewall" "anfw" {
  name        = "aws-network-firewall-nfw-demo-dev"
  description = "AWS NetworkFirewall Service Distributed model demo"

  vpc_id              = aws_vpc.vpc.id
  firewall_policy_arn = aws_networkfirewall_firewall_policy.test.arn

  dynamic "subnet_mapping" {
    for_each = [
      aws_subnet.firewall_subnet_1.id,
      aws_subnet.firewall_subnet_2.id
    ]

    content {
      subnet_id = subnet_mapping.value
    }
  }

  tags = {
    Name = "Distributed-NetworkFirewall"
  }


}
