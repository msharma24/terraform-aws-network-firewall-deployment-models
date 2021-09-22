#---------------------------------------------------------------------------
# Centralized AWS Network Firewall
#---------------------------------------------------------------------------
resource "aws_networkfirewall_firewall_policy" "nfw_default_policy" {
  name = "aws-network-firewall-default-policy"

  firewall_policy {
    stateless_default_actions          = ["aws:forward_to_sfe"]
    stateless_fragment_default_actions = ["aws:forward_to_sfe"]

    stateless_rule_group_reference {
      priority     = 1
      resource_arn = aws_networkfirewall_rule_group.drop_icmp_traffic_fw_rule_group.arn
    }

    stateful_rule_group_reference {
      resource_arn = aws_networkfirewall_rule_group.block_domains_fw_rule_group.arn
    }

    stateful_rule_group_reference {
      resource_arn = aws_networkfirewall_rule_group.et_open_rulselt_fw_rule_group.arn
    }

  }

  tags = {
    Name = "aws-network-firewall-default-policy"
  }
}


#--------------------------------------------------------------------------
# Network Firewall Resource
#--------------------------------------------------------------------------
resource "aws_networkfirewall_firewall" "nfw" {
  name = "centralized-network-firewall"

  firewall_policy_arn = aws_networkfirewall_firewall_policy.nfw_default_policy.arn
  vpc_id              = module.inspection_vpc.vpc_id

  dynamic "subnet_mapping" {

    for_each = module.inspection_vpc.public_subnets

    content {
      subnet_id = subnet_mapping.value
    }
  }

  tags = {
    Name = "centralized-network-firewall"

  }

}

#--------------------------------------------------------------------------
#  Drop ALL ICMP Traffic Rule Group
#--------------------------------------------------------------------------
resource "aws_networkfirewall_rule_group" "drop_icmp_traffic_fw_rule_group" {
  name     = "drop-icmp-traffic-fw-rule-group"
  capacity = 100
  type     = "STATELESS"

  rule_group {
    rules_source {
      stateless_rules_and_custom_actions {
        stateless_rule {
          priority = 1
          rule_definition {
            actions = ["aws:drop"]
            match_attributes {
              protocols = [1]
              source {
                address_definition = "0.0.0.0/0"
              }
              destination {
                address_definition = "0.0.0.0/0"
              }
            }
          }
        }
      }
    }
  }

}

#--------------------------------------------------------------------------
#  Domain Deny list Rule Group
#--------------------------------------------------------------------------
resource "aws_networkfirewall_rule_group" "block_domains_fw_rule_group" {
  name     = "block-domains-fw-rule-group"
  capacity = 100
  type     = "STATEFUL"
  rule_group {
    rule_variables {
      ip_sets {
        key = "HOME_NET"
        ip_set {
          definition = [
            module.spoke_vpc_a.vpc_cidr_block,
            module.spoke_vpc_b.vpc_cidr_block,
          ]
        }
      }
    }
    rules_source {
      rules_source_list {
        generated_rules_type = "DENYLIST"
        target_types         = ["HTTP_HOST", "TLS_SNI"]
        targets = [
          ".facebook.com",
          ".twitter.com",
          ".yahoo.com"
        ]
      }
    }
  }

}

#--------------------------------------------------------------------------
#  Emerging Threat Rule Group
#--------------------------------------------------------------------------
resource "aws_networkfirewall_rule_group" "et_open_rulselt_fw_rule_group" {
  name        = "et-open-rulselt-fw-rule-group"
  description = "Stateful Inspection from rules specifications defined in Suricata flat format"
  capacity    = 250
  type        = "STATEFUL"
  rules       = file("./rules/emerging-user-agents.rules")

  tags = {
    Name = "et-open-rulselt-fw-rule-group"
  }

}

#--------------------------------------------------------------------------
#  Blog Public DNS Resolvers  Rule Group
#--------------------------------------------------------------------------
resource "aws_networkfirewall_rule_group" "block_public_dns_resolvers" {
  capacity = 1
  name     = "block-public-dns"
  type     = "STATEFUL"
  rule_group {
    rules_source {
      stateful_rule {
        action = "DROP"
        header {
          destination      = "ANY"
          destination_port = "ANY"
          direction        = "ANY"
          protocol         = "DNS"
          source           = "ANY"
          source_port      = "ANY"
        }
        rule_option {
          keyword = "sid:50"
        }
      }
    }
  }
}


#--------------------------------------------------------------------------
#  Network Firewall Logging configuration
#--------------------------------------------------------------------------
resource "aws_cloudwatch_log_group" "anfw_alert_log_group" {
  name              = "/aws/network-firewall/alert"
  retention_in_days = 60
}

resource "aws_cloudwatch_log_group" "anfw_flow_log_group" {
  name              = "/aws/network-firewall/flow"
  retention_in_days = 60
}

resource "aws_networkfirewall_logging_configuration" "anfw_alert_logging_configuration" {
  firewall_arn = aws_networkfirewall_firewall.nfw.arn
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
        logGroup = aws_cloudwatch_log_group.anfw_flow_log_group.name
      }
      log_destination_type = "CloudWatchLogs"
      log_type             = "FLOW"
    }
  }
}
