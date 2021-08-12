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
  name        = "NetworkFirewall"
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

#---------------------------------------------------------
# Logging Configuration
#---------------------------------------------------------
resource "aws_cloudwatch_log_group" "anfw_alert_log_group" {
  name = "/nfw-demo-dev/anfw/alert"

}

resource "aws_cloudwatch_log_group" "anfw_flow_log_group" {
  name = "/nfw-demo-dev/anfw/flow"

}

resource "aws_networkfirewall_logging_configuration" "anfw_alert_log_config" {
  firewall_arn = aws_networkfirewall_firewall.anfw.arn
  logging_configuration {
    log_destination_config {
      log_destination = {
        logGroup = aws_cloudwatch_log_group.anfw_alert_log_group.name
      }
      log_destination_type = "CloudWatchLogs"
      log_type             = "ALERT"
    }
    log_destination_config {
      log_destination = {
        logGroup = aws_cloudwatch_log_group.anfw_alert_log_group.name
      }
      log_destination_type = "CloudWatchLogs"
      log_type             = "FLOW"
    }
  }

}
