module "spoke_vpc_a_ec2_instance" {
  source  = "terraform-aws-modules/ec2-instance/aws"
  version = "~> 2.0"

  name           = "${var.environment}/spoke_vpc_a_instance"
  instance_count = 1

  ami                    = data.aws_ami.amazon-linux-2.id
  instance_type          = "t2.micro"
  monitoring             = true
  vpc_security_group_ids = [module.spoke_vpc_a_ssh_sg.security_group_id]
  subnet_id              = module.spoke_vpc_a.private_subnets[0]
  iam_instance_profile   = aws_iam_instance_profile.subnet_instance_iam_profile.id

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

  ami                    = data.aws_ami.amazon-linux-2.id
  instance_type          = "t2.micro"
  monitoring             = true
  vpc_security_group_ids = [module.spoke_vpc_b_ssh_sg.security_group_id]
  subnet_id              = module.spoke_vpc_b.private_subnets[0]
  iam_instance_profile   = aws_iam_instance_profile.subnet_instance_iam_profile.id

  tags = {
    Terraform   = "true"
    Environment = "dev"
  }
}


