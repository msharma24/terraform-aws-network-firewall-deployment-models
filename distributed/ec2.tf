resource "aws_security_group" "malicious_instance_sg" {
  name        = "MaliciousSecurityGroup"
  description = "MaliciousSecurityGroup"

  vpc_id = aws_vpc.malicious_vpc.id

  ingress = [
    {
      description      = "MaliciousSecurityGroupRule"
      from_port        = 443
      to_port          = 443
      protocol         = "tcp"
      cidr_blocks      = ["0.0.0.0/0"]
      ipv6_cidr_blocks = ["::/0"]
      security_groups  = []
      self             = false
      prefix_list_ids  = []
    }
  ]

  egress = [
    {
      description      = "MaliciousSecurityGroupRule"
      from_port        = 0
      to_port          = 0
      protocol         = "-1"
      cidr_blocks      = ["0.0.0.0/0"]
      ipv6_cidr_blocks = ["::/0"]
      security_groups  = []
      self             = false
      prefix_list_ids  = []
    }
  ]



  tags = {
    Name = "MaliciousSecurityGroup"
  }



}

resource "aws_eip" "malicious_instance_eip" {

  instance = aws_instance.malicious_instance.id

  depends_on = [
    aws_instance.malicious_instance
  ]

  tags = {
    Name = "MaliciousInstanceEIP"
  }

}

data "template_file" "malicious_userdata" {
  template = file("${path.cwd}/userdata-script/script.sh")
}

resource "aws_instance" "malicious_instance" {
  ami                  = data.aws_ami.amazon-linux-2.id
  subnet_id            = aws_subnet.malicious_subnet.id
  instance_type        = "m5.large"
  iam_instance_profile = aws_iam_instance_profile.malicious_instance_iam_profile.id
  user_data            = data.template_file.malicious_userdata.rendered

  tags = {

    Name = "MaliciousInstance-${random_id.random_id.hex}"
  }

}
