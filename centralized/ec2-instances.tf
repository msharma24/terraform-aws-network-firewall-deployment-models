module "spoke_vpc_a_ec2_instance" {
  source  = "terraform-aws-modules/ec2-instance/aws"
  version = "~> 2.0"

  name           = "${var.environment}/spoke_vpc_a_instance"
  instance_count = 1

  ami                    = data.aws_ami.amazon_linux_2.id
  instance_type          = "t2.micro"
  monitoring             = true
  vpc_security_group_ids = [module.spoke_vpc_a_ssh_sg.security_group_id]
  subnet_id              = module.spoke_vpc_a.public_subnets[0]
  iam_instance_profile   = module.spoke_instance_iam_assumable_role.iam_instance_profile_id
  user_data              = <<EOF
  #!/bin/bash
  yum install  -y
  sleep 5;
  yum install nc -y
  EOF

  tags = {
    Terraform   = "true"
    Environment = "dev"
  }
}


module "spoke_vpc_b_ec2_instance" {
  source  = "terraform-aws-modules/ec2-instance/aws"
  version = "~> 2.0"

  name           = "${var.environment}/spoke_vpc_b_instance"
  instance_count = 1

  ami           = data.aws_ami.amazon_linux_2.id
  instance_type = "t2.micro"
  monitoring    = true

  vpc_security_group_ids = [
    module.spoke_vpc_b_ssh_sg.security_group_id,
    module.spoke_vpc_b_http_sg.security_group_id
  ]

  subnet_id            = module.spoke_vpc_b.public_subnets[0]
  iam_instance_profile = module.spoke_instance_iam_assumable_role.iam_instance_profile_id
  user_data            = <<-EOT
  #!/bin/bash
  echo "[INFO] installing nginx"
  yum update -y
  sleep 5;
  yum install nc -y
  amazon-linux-extras install nginx1.12 -y
  systemctl start nginx
  systemctl enable nginx
  EOT

  tags = {
    Terraform   = "true"
    Environment = "dev"
  }
}


