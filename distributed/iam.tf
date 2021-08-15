resource "random_id" "random_id" {
  byte_length = 5

}

resource "aws_iam_role" "malicious_instance_iam_role" {
  name = "MaliciousInstanceRole-${random_id.random_id.hex}"

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
    Name = "MaliciousInstanceRole"
  }

}

resource "aws_iam_policy" "malicious_instance_iam_policy" {
  name = "MaliciousInstancePolicy-${random_id.random_id.hex}"

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = [
          "ssm:GetParameter",
          "ssm:GetParameters",
          "ssm:DescribeParameters"

        ]
        Effect   = "Allow"
        Resource = "arn:aws:ssm:${var.region}:${data.aws_caller_identity.current.account_id}:*"

      },
    ]
  })

}

resource "aws_iam_role_policy_attachment" "malicious_instance_iam_policy_attachment" {

  role       = aws_iam_role.malicious_instance_iam_role.name
  policy_arn = aws_iam_policy.malicious_instance_iam_policy.arn

}

resource "aws_iam_role_policy_attachment" "managed_policy_attach" {
  policy_arn = "arn:aws:iam::aws:policy/service-role/AmazonEC2RoleforSSM"
  role       = aws_iam_role.malicious_instance_iam_role.name
}

resource "aws_iam_instance_profile" "malicious_instance_iam_profile" {
  name = "MaliciousInstanceProfile-${random_id.random_id.hex}"
  role = aws_iam_role.malicious_instance_iam_role.name

}
#--------------------------------------------------------------------------
# Subnet IAM Role
#--------------------------------------------------------------------------
resource "aws_iam_role" "subnet_role" {
  name = "subnet_role-${random_id.random_id.hex}"

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
  role       = aws_iam_role.subnet_role.name
}

resource "aws_iam_instance_profile" "subnet_instance_iam_profile" {
  name = "SubnetInstanceProfile-${random_id.random_id.hex}"
  role = aws_iam_role.subnet_role.name

}
