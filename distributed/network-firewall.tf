resource "aws_networkfirewall_rule_group" "domain_allow_fw_rule_group" {
  name = "domain-allow-fw-rule-group"
  #  -${random_id.random_id.hex}"
  capacity = 100
  type     = "STATEFUL"

  rule_group {
    rule_variables {
      ip_sets {
        key = "HOME_NET"
        ip_set {
          definition = ["10.0.0.0/8"]
        }
      }
    }

    rules_source {
      rules_source_list {
        generated_rules_type = "ALLOWLIST"
        target_types         = ["HTTP_HOST", "TLS_SNI"]
        targets              = [".amazon.com", ".amazonaws.com"]
      }
    }

  }


}

resource "aws_networkfirewall_rule_group" "icmp_alert_fw_rule_group" {
  #name     = "icmp_alert_fw_rule_group-${random_id.random_id.hex}"
  name     = "icmp-alert-fw-rule-group" # "-${random_id.random_id.hex}"
  capacity = 100
  type     = "STATEFUL"

  rule_group {
    rules_source {
      stateful_rule {
        action = "ALERT"
        header {
          destination      = "ANY"
          destination_port = "ANY"
          protocol         = "ICMP"
          direction        = "ANY"
          source           = "ANY"
          source_port      = "ANY"

        }
        rule_option {
          keyword = "sid:1"
        }
      }
    }
  }
}


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
