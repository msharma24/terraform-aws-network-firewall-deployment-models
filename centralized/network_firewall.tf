#---------------------------------------------------------------------------
# Centralized AWS Network Firewall
#---------------------------------------------------------------------------
resource "aws_networkfirewall_firewall_policy" "nfw_default_policy" {
  name = "aws-network-firewall-default-policy"

  firewall_policy {
    stateless_default_actions          = ["aws:pass"]
    stateless_fragment_default_actions = ["aws:pass"]
  }

  tags = {
    Name = "aws-network-firewall-default-policy"
  }
}

resource "aws_networkfirewall_firewall" "nfw" {
  name = "centralized-network-firewall"

  firewall_policy_arn = aws_networkfirewall_firewall_policy.nfw_default_policy.arn
  vpc_id              = aws_vpc.inspection_vpc.id

  dynamic "subnet_mapping" {
    for_each = [
      aws_subnet.inspection_vpc_firewall_subnet_a.id,
      aws_subnet.inspection_vpc_firewall_subnet_b.id,
      aws_subnet.inspection_vpc_firewall_subnet_b.id
    ]

    content {
      subnet_id = subnet_mapping.value
    }
  }

  tags = {
    Name = "centralized-network-firewall"

  }

}

resource "aws_cloudwatch_log_group" "example" {
  name = "ngw-log-group"

}






# Logging
resource "aws_networkfirewall_logging_configuration" "example" {
  firewall_arn = aws_networkfirewall_firewall.nfw.arn
  logging_configuration {
    log_destination_config {
      log_destination = {
        logGroup = aws_cloudwatch_log_group.example.name
      }
      log_destination_type = "CloudWatchLogs"
      log_type             = "ALERT"
    }
  }
}
