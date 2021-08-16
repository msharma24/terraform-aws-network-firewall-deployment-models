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

  tags = {
    Terraform   = "true"
    Environment = "dev"
  }
}

module "spoke_vpc_a_ec2_instance_2" {
  source  = "terraform-aws-modules/ec2-instance/aws"
  version = "~> 2.0"

  name           = "${var.environment}/spoke_vpc_a_instance_2"
  instance_count = 1

  ami                    = data.aws_ami.amazon-linux-2.id
  instance_type          = "t2.micro"
  monitoring             = true
  vpc_security_group_ids = [module.spoke_vpc_a_ssh_sg.security_group_id]
  subnet_id              = module.spoke_vpc_a.private_subnets[1]

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

  tags = {
    Terraform   = "true"
    Environment = "dev"
  }
}



module "spoke_vpc_a_ec2_public_instance" {
  source  = "terraform-aws-modules/ec2-instance/aws"
  version = "~> 2.0"

  name           = "${var.environment}/spoke_vpc_a_public_instance"
  instance_count = 1

  ami                    = data.aws_ami.amazon-linux-2.id
  instance_type          = "t2.micro"
  monitoring             = true
  vpc_security_group_ids = [module.spoke_vpc_a_ssh_sg.security_group_id]
  subnet_id              = module.spoke_vpc_a.public_subnets[0]

  tags = {
    Terraform   = "true"
    Environment = "dev"
  }
}

module "spoke_vpc_b_ec2_public_instance" {
  source  = "terraform-aws-modules/ec2-instance/aws"
  version = "~> 2.0"

  name           = "${var.environment}/spoke_vpc_b_public_instance"
  instance_count = 1

  ami                    = data.aws_ami.amazon-linux-2.id
  instance_type          = "t2.micro"
  monitoring             = true
  vpc_security_group_ids = [module.spoke_vpc_b_ssh_sg.security_group_id]
  subnet_id              = module.spoke_vpc_b.public_subnets[0]

  tags = {
    Terraform   = "true"
    Environment = "dev"
  }
}



