resource "random_id" "random_id" {
  byte_length = 5

}

#--------------------------------------------------------------------------
# IAM assumable role
#--------------------------------------------------------------------------
module "spoke_instance_iam_assumable_role" {
  source  = "terraform-aws-modules/iam/aws//modules/iam-assumable-role"
  version = "~> 4.5"

  trusted_role_services = [
    "ec2.amazonaws.com"
  ]

  role_requires_mfa       = false
  create_role             = true
  create_instance_profile = true

  role_name = "spoke-instance-role-${random_id.random_id.hex}"

  custom_role_policy_arns = [
    "arn:aws:iam::aws:policy/service-role/AmazonEC2RoleforSSM"
  ]
}
