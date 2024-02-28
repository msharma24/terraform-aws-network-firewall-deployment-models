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
    },
    {
      description      = "Test Instance SG RDP"
      from_port        = 3389
      to_port          = 3389
      protocol         = "tcp"
      ipv6_cidr_blocks = ["::/0"]
      cidr_blocks      = ["0.0.0.0/0"]
      self             = false
      security_groups  = []
      prefix_list_ids  = []
    },

  ]

  egress = [
    {
      description      = "Allow All outbound"
      from_port        = 0
      to_port          = 0
      protocol         = "-1"
      cidr_blocks      = ["0.0.0.0/0"]
      ipv6_cidr_blocks = ["::/0"]
      prefix_list_ids  = []
      security_groups  = []
      self             = false
    }
  ]


  tags = {
    Name = "test-sg-1-${random_id.random_id.hex}"
  }

}


resource "aws_instance" "test_instance_1" {
  ami                    = data.aws_ami.amazon_linux_2.id
  instance_type          = "t2.micro"
  subnet_id              = aws_subnet.private_subnet_1.id
  iam_instance_profile   = aws_iam_instance_profile.subnet_instance_iam_profile.id
  vpc_security_group_ids = [aws_security_group.subnet_security_group.id]

  tags = {
    Name = "test-instance-1"
  }
}

resource "aws_instance" "test_instance_2" {
  ami                         = data.aws_ami.windows_2022.id
  instance_type               = "t2.large"
  subnet_id                   = aws_subnet.public_subnet_1.id
  key_name                    = "test-firewa--pem"
  associate_public_ip_address = true
  iam_instance_profile        = aws_iam_instance_profile.subnet_instance_iam_profile.id
  vpc_security_group_ids      = [aws_security_group.subnet_security_group.id]

  tags = {
    Name = "public-test-instance-2"
  }
}
