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
      aws_subnet.inspection_vpc_tgw_subnet_a.id,
      aws_subnet.inspection_vpc_tgw_subnet_b.id,
      aws_subnet.inspection_vpc_tgw_subnet_c.id,
    ]

    content {
      subnet_id = subnet_mapping.value
    }
  }

  tags = {
    Name = "centralized-network-firewall"

  }

}

resource "aws_networkfirewall_rule_group" "drop_spoke_a_spoke_b_traffic_fw_rule_group" {
  name     = "drop-spoke-a-spoke-b-traffic-fw-rule-group"
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
              protocols = [
                1, 6

              ]
              source {
                address_definition = module.spoke_vpc_a.vpc_cidr_block
              }
              destination {
                address_definition = module.spoke_vpc_b.vpc_cidr_block
              }
            }
          }
        }
      }
    }
  }


}

# Logging configuration
resource "aws_cloudwatch_log_group" "anfw_alert_log_group" {
  name = "/aws/network-firewall/alert"
}

resource "random_string" "bucket_random_id" {
  length  = 5
  special = false
  upper   = false
}

resource "aws_s3_bucket" "anfw_flow_bucket" {
  bucket        = "network-firewall-flow-bucket-${random_string.bucket_random_id.id}"
  acl           = "private"
  force_destroy = true
  server_side_encryption_configuration {
    rule {
      apply_server_side_encryption_by_default {
        kms_master_key_id = "aws/s3"
        sse_algorithm     = "aws:kms"
      }
    }
  }
  versioning {
    enabled = true
  }
}

resource "aws_s3_bucket_public_access_block" "anfw_flow_bucket_public_access_block" {
  bucket = aws_s3_bucket.anfw_flow_bucket.id

  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
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
        bucketName = aws_s3_bucket.anfw_flow_bucket.bucket
      }
      log_destination_type = "S3"
      log_type             = "FLOW"
    }
  }
}
