# resource "aws_networkfirewall_firewall_policy" "test" {
#   name = "example"
#
#   firewall_policy {
#     stateless_default_actions          = ["aws:pass", "ExampleCustomAction"]
#     stateless_fragment_default_actions = ["aws:drop"]
#
#     stateless_custom_action {
#       action_definition {
#         publish_metric_action {
#           dimension {
#             value = "1"
#           }
#         }
#       }
#       action_name = "ExampleCustomAction"
#     }
#   }
# }
#
# resource "aws_networkfirewall_firewall" "anfw" {
#   name        = "NetworkFirewall"
#   description = "AWS NetworkFirewall Service"
#
#   vpc_id              = module.vpc.vpc_id
#   firewall_policy_arn = aws_networkfirewall_firewall_policy.test.arn
#
#   dynamic "subnet_mapping" {
#     for_each = module.vpc.private_subnets
#
#     content {
#       subnet_id = subnet_mapping.value
#     }
#   }
#
#   tags = {
#     Name = "NetworkFirewall"
#   }
#
#
# }
