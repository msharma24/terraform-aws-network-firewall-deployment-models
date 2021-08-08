module "key_pair" {
  source = "terraform-aws-modules/key-pair/aws"

  key_name   = "${var.environment}-sharedservices-ssh-keypair"
  public_key = "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABgQD0YgrVVIcvqxp34XSZPTBRYas6MGIlcCyZVzs/BmXpxl/3N+KB33VEfWguTWcXwhQun/J8/hjiEOqrknem91D9qfO/PfrLV/zeE05zKJEgmgJPjJaf2TYRFUZzTZyNmj2p2uPe7/12XhP5JqF7F4lk65eP1hdqLw51JauIxyt3yUS6DaHqSzdbWbrOqkQvpQrY2s/6CnDbLHLzRpnNnbJ5ORkM50obCuoy84C/JvAbrZm3sHTu+TXAvxcTXO5tCPK3i7peUdlnGHKN1Na+jln9xkMscgeSwHM1l/Oh0/YpM/88MMgRQvvYhd/944WRgH/WYknsQQDm83t14jUYhR7JNe0HeuaW9pHFCGLuuOshrKEaV9SPb/2324mnkTzwMGzlVLYTGLqM55NWc57x5BQK1obESM9RlGZA1bPkX5HRg/9Vraes+D8BB7CYiDrdIJlR+Q3t551vgyI9ygiIZmvtHdNQJk6Ww5XY3GbQZmaOjq1oyFZPhq1xB2gvMUVONnM= mukesh.sharma@Mukesh-Sharmas-Macbook-Pro.local"

}



module "spoke_vpc_a_ec2_instance" {
  source  = "terraform-aws-modules/ec2-instance/aws"
  version = "~> 2.0"

  name           = "${var.environment}/spoke_vpc_a_instance"
  instance_count = 1

  ami                    = data.aws_ami.amazon-linux-2.id
  instance_type          = "t2.micro"
  key_name               = module.key_pair.key_pair_key_name
  monitoring             = true
  vpc_security_group_ids = [module.spoke_vpc_a_ssh_sg.security_group_id]
  subnet_id              = module.spoke_vpc_a.private_subnets[0]

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
  key_name               = module.key_pair.key_pair_key_name
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
  key_name               = module.key_pair.key_pair_key_name
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
  key_name               = module.key_pair.key_pair_key_name
  monitoring             = true
  vpc_security_group_ids = [module.spoke_vpc_b_ssh_sg.security_group_id]
  subnet_id              = module.spoke_vpc_b.public_subnets[0]

  tags = {
    Terraform   = "true"
    Environment = "dev"
  }
}



