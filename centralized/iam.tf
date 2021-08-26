resource "random_id" "random_id" {
  byte_length = 5

}

#--------------------------------------------------------------------------
# Subnet IAM Role
#--------------------------------------------------------------------------
resource "aws_iam_role" "spoke_instance_role" {
  name = "spoke_instance_role-${random_id.random_id.hex}"

  # Terraform's "jsonencode" function converts a
  # Terraform expression result to valid JSON syntax.
  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "sts:AssumeRole"
        Effect = "Allow"
        Sid    = ""
        Principal = {
          Service = "ec2.amazonaws.com"
        }
      },
    ]
  })

  tags = {
    tag-key = "tag-value"
  }
}

resource "aws_iam_role_policy_attachment" "policy_attach" {
  policy_arn = "arn:aws:iam::aws:policy/service-role/AmazonEC2RoleforSSM"
  role       = aws_iam_role.spoke_instance_role.name
}

resource "aws_iam_instance_profile" "subnet_instance_iam_profile" {
  name = "SubnetInstanceProfile-${random_id.random_id.hex}"
  role = aws_iam_role.spoke_instance_role.name

}
