resource "aws_security_group" "subnet_security_group" {
  name        = "test-sg-1-${random_id.random_id.hex}"
  description = "Allow instances to get to SSM Systems Manager"
  vpc_id      = aws_vpc.vpc.id

  ingress = [
    {
      description      = "Test Instance SG"
      from_port        = "-1"
      to_port          = "-1"
      protocol         = "icmp"
      ipv6_cidr_blocks = ["::/0"]
      cidr_blocks      = ["10.0.0.0/8"]
      self             = false
      security_groups  = []
      prefix_list_ids  = []
    }
  ]



  tags = {
    Name = "test-sg-1-${random_id.random_id.hex}"
  }

}

data "template_file" "test_instance_userdata" {
  template = file("${path.cwd}/userdata-script/test_instance_script.sh")
  vars = {
    MaliciousIP = aws_eip.malicious_instance_eip.id
  }
}

resource "aws_instance" "test_instance_1" {
  ami                  = data.aws_ami.amazon-linux-2.id
  instance_type        = "t2.micro"
  subnet_id            = aws_subnet.private_subnet_1.id
  security_groups      = [aws_security_group.subnet_security_group.id]
  iam_instance_profile = aws_iam_instance_profile.subnet_instance_iam_profile.id
  user_data            = data.template_file.test_instance_userdata.rendered

  tags = {
    Name = "test-instance-1"
  }
}

resource "aws_instance" "test_instance_2" {
  ami                  = data.aws_ami.amazon-linux-2.id
  instance_type        = "t2.micro"
  subnet_id            = aws_subnet.private_subnet_1.id
  security_groups      = [aws_security_group.subnet_security_group.id]
  iam_instance_profile = aws_iam_instance_profile.subnet_instance_iam_profile.id

  tags = {
    Name = "test-instance-2"
  }
}
