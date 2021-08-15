#-----------------------------------------------------------------------------
# Firewall VPC
#-----------------------------------------------------------------------------
resource "aws_vpc" "vpc" {
  cidr_block           = "10.1.0.0/16"
  enable_dns_support   = true
  enable_dns_hostnames = true

  tags = {
    Name = "spoke-vpc-a-nfw-demo-dev"
  }
}

#-----------------------------------------------------------------------------
# Internet Gateway
#-----------------------------------------------------------------------------
resource "aws_internet_gateway" "igw" {
  vpc_id = aws_vpc.vpc.id

  tags = {
    Name = "spoke-vpc-a-igwnfw-demo-dev"
  }

}

#-----------------------------------------------------------------------------
# Firewall Subnets
#-----------------------------------------------------------------------------
resource "aws_subnet" "firewall_subnet_1" {
  cidr_block        = "10.1.16.0/28"
  vpc_id            = aws_vpc.vpc.id
  availability_zone = data.aws_availability_zones.available.names[0]


  tags = {
    Name = "firewall-subnet-1-nfw-demo-dev"
  }

}

resource "aws_subnet" "firewall_subnet_2" {
  cidr_block        = "10.1.16.16/28"
  vpc_id            = aws_vpc.vpc.id
  availability_zone = data.aws_availability_zones.available.names[1]

  tags = {
    Name = "firewall-subnet-2-nfw-demo-dev"
  }

}

#-----------------------------------------------------------------------------
# Firewall Route Table
#-----------------------------------------------------------------------------
resource "aws_route_table" "firewall_route_table_1" {

  vpc_id = aws_vpc.vpc.id

  tags = {
    Name = "firewall-route-table-1-nfw-demo-dev"
  }

}

resource "aws_route_table" "firewall_route_table_2" {

  vpc_id = aws_vpc.vpc.id

  tags = {
    Name = "firewall-route-table-1-nfw-demo-dev"
  }

}


#-----------------------------------------------------------------------------
# Subnet association
#-----------------------------------------------------------------------------
resource "aws_route_table_association" "firewall_subnet_rt_association_1" {
  subnet_id      = aws_subnet.firewall_subnet_1.id
  route_table_id = aws_route_table.firewall_route_table_1.id

}

resource "aws_route_table_association" "firewall_subnet_rt_association_2" {
  subnet_id      = aws_subnet.firewall_subnet_2.id
  route_table_id = aws_route_table.firewall_route_table_2.id

}

#-----------------------------------------------------------------------------
# Internet Route Config
#-----------------------------------------------------------------------------
resource "aws_route" "firewall_subnet_1_route" {
  destination_cidr_block = "0.0.0.0/0"
  route_table_id         = aws_route_table.firewall_route_table_1.id
  gateway_id             = aws_internet_gateway.igw.id
}

resource "aws_route" "firewall_subnet_2_route" {
  destination_cidr_block = "0.0.0.0/0"
  route_table_id         = aws_route_table.firewall_route_table_2.id
  gateway_id             = aws_internet_gateway.igw.id

}

/*
 * Public Route Config
 */

#-----------------------------------------------------------------------------
# Firewall Subnets
#-----------------------------------------------------------------------------
resource "aws_subnet" "public_subnet_1" {
  cidr_block        = "10.1.1.0/24"
  vpc_id            = aws_vpc.vpc.id
  availability_zone = data.aws_availability_zones.available.names[0]

  tags = {
    Name = "public-subnet-1-nfw-demo-dev"
  }

}

resource "aws_subnet" "public_subnet_2" {
  cidr_block        = "10.1.3.0/24"
  vpc_id            = aws_vpc.vpc.id
  availability_zone = data.aws_availability_zones.available.names[1]

  tags = {
    Name = "public-subnet-1-nfw-demo-dev"
  }

}

#-----------------------------------------------------------------------------
# public Route Table
#-----------------------------------------------------------------------------
resource "aws_route_table" "public_route_table_1" {

  vpc_id = aws_vpc.vpc.id

  tags = {
    Name = "public-route-table-1-nfw-demo-dev"
  }

}

resource "aws_route_table" "public_route_table_2" {

  vpc_id = aws_vpc.vpc.id

  tags = {
    Name = "public-route-table-1-nfw-demo-dev"
  }

}

#-----------------------------------------------------------------------------
# Subnet association
#-----------------------------------------------------------------------------
resource "aws_route_table_association" "public_subnet_rt_association_1" {
  subnet_id      = aws_subnet.public_subnet_1.id
  route_table_id = aws_route_table.public_route_table_1.id

}

resource "aws_route_table_association" "public_subnet_rt_association_2" {
  subnet_id      = aws_subnet.public_subnet_2.id
  route_table_id = aws_route_table.public_route_table_2.id

}

#-----------------------------------------------------------------------------
# Firewall  Route Config
#-----------------------------------------------------------------------------
resource "aws_route" "public_subnet_1_route" {
  destination_cidr_block = "0.0.0.0/0"
  route_table_id         = aws_route_table.public_route_table_1.id
  vpc_endpoint_id        = (aws_networkfirewall_firewall.anfw.firewall_status[0].sync_states[*].attachment[0].endpoint_id)[0]
}

resource "aws_route" "public_subnet_2_route" {
  destination_cidr_block = "0.0.0.0/0"
  route_table_id         = aws_route_table.public_route_table_2.id
  vpc_endpoint_id        = (aws_networkfirewall_firewall.anfw.firewall_status[0].sync_states[*].attachment[0].endpoint_id)[1]


}


/*
 * private Route Config
 */

#-----------------------------------------------------------------------------
# Private Subnets
#-----------------------------------------------------------------------------
resource "aws_subnet" "private_subnet_1" {
  cidr_block        = "10.1.0.0/24"
  vpc_id            = aws_vpc.vpc.id
  availability_zone = data.aws_availability_zones.available.names[0]

  tags = {
    Name = "private-subnet-1-nfw-demo-dev"
  }

}

resource "aws_subnet" "private_subnet_2" {
  cidr_block        = "10.1.2.0/24"
  vpc_id            = aws_vpc.vpc.id
  availability_zone = data.aws_availability_zones.available.names[1]

  tags = {
    Name = "private-subnet-2-nfw-demo-dev"
  }

}

#-----------------------------------------------------------------------------
# private Route Table
#-----------------------------------------------------------------------------
resource "aws_route_table" "private_route_table_1" {

  vpc_id = aws_vpc.vpc.id

  tags = {
    Name = "private-route-table-1-nfw-demo-dev"
  }

}

resource "aws_route_table" "private_route_table_2" {

  vpc_id = aws_vpc.vpc.id

  tags = {
    Name = "private-route-table-2-nfw-demo-dev"
  }

}


#-----------------------------------------------------------------------------
# Subnet association
#-----------------------------------------------------------------------------
resource "aws_route_table_association" "private_subnet_rt_association_1" {
  subnet_id      = aws_subnet.private_subnet_1.id
  route_table_id = aws_route_table.private_route_table_1.id

}

resource "aws_route_table_association" "private_subnet_rt_association_2" {
  subnet_id      = aws_subnet.private_subnet_2.id
  route_table_id = aws_route_table.private_route_table_2.id

}

#-----------------------------------------------------------------------------
# NAT  Route Config
#-----------------------------------------------------------------------------
resource "aws_route" "private_subnet_1_route" {
  destination_cidr_block = "0.0.0.0/0"
  route_table_id         = aws_route_table.private_route_table_1.id
  gateway_id             = aws_nat_gateway.nat_gateway_1.id

  depends_on = [
    aws_nat_gateway.nat_gateway_1
  ]
}

resource "aws_route" "private_subnet_2_route" {
  destination_cidr_block = "0.0.0.0/0"
  route_table_id         = aws_route_table.private_route_table_2.id
  gateway_id             = aws_nat_gateway.nat_gateway_2.id

  depends_on = [
    aws_nat_gateway.nat_gateway_2
  ]

}

#----------------------------------------------------------------------------
# Ingress Route Table for return traffic
#-----------------------------------------------------------------------------
resource "aws_route_table" "ingress_route_table" {
  vpc_id = aws_vpc.vpc.id

  tags = {
    Name = "ingress-route-table-nfw-demo-dev"
  }

}

resource "aws_route_table_association" "igw_association" {
  gateway_id     = aws_internet_gateway.igw.id
  route_table_id = aws_route_table.ingress_route_table.id

}

resource "aws_route" "ingress_route_1" {
  route_table_id         = aws_route_table.ingress_route_table.id
  destination_cidr_block = "10.1.1.0/24"
  vpc_endpoint_id        = (aws_networkfirewall_firewall.anfw.firewall_status[0].sync_states[*].attachment[0].endpoint_id)[0]

}

resource "aws_route" "ingress_route_2" {
  route_table_id         = aws_route_table.ingress_route_table.id
  destination_cidr_block = "10.1.3.0/24"
  vpc_endpoint_id        = (aws_networkfirewall_firewall.anfw.firewall_status[0].sync_states[*].attachment[0].endpoint_id)[0]

}


#-----------------------------------------------------------------------------
# NAT  Gateway
#-----------------------------------------------------------------------------
resource "aws_eip" "nat_gateway_eip_1" {

  tags = {
    Name = "nat_gateway_eip_1"
  }
}

resource "aws_eip" "nat_gateway_eip_2" {

  tags = {
    Name = "nat_gateway_eip_2"
  }
}

resource "aws_nat_gateway" "nat_gateway_1" {
  subnet_id     = aws_subnet.public_subnet_1.id
  allocation_id = aws_eip.nat_gateway_eip_1.id

  tags = {
    Name = "nat_gateway_1"
  }
}


resource "aws_nat_gateway" "nat_gateway_2" {
  subnet_id     = aws_subnet.public_subnet_2.id
  allocation_id = aws_eip.nat_gateway_eip_2.id

  tags = {
    Name = "nat_gateway_2"
  }
}


#-----------------------------------------------------------------------------
#  AWS PrivateLink interface endpoint for services:
#-----------------------------------------------------------------------------
resource "aws_security_group" "endpoint_security_group" {
  name        = "vpce-sg-1-${random_id.random_id.hex}"
  description = "Allow instances to get to SSM Systems Manager"
  vpc_id      = aws_vpc.vpc.id

  ingress = [
    {
      description      = "All 443"
      from_port        = 443
      to_port          = 443
      protocol         = "tcp"
      ipv6_cidr_blocks = ["::/0"]
      cidr_blocks      = ["10.1.0.0/16"]
      self             = false
      security_groups  = []
      prefix_list_ids  = []
    }
  ]



  tags = {
    Name = "vpce-sg-1-${random_id.random_id.hex}"
  }

}

resource "aws_vpc_endpoint" "ssm_endpoint" {
  vpc_id       = aws_vpc.vpc.id
  service_name = "com.amazonaws.${var.region}.ssm"

  security_group_ids = [
    aws_security_group.endpoint_security_group.id
  ]

  subnet_ids = [
    aws_subnet.public_subnet_1.id,
  aws_subnet.public_subnet_2.id]

  vpc_endpoint_type   = "Interface"
  private_dns_enabled = true

}

resource "aws_vpc_endpoint" "ec2messages_endpoint" {
  vpc_id       = aws_vpc.vpc.id
  service_name = "com.amazonaws.${var.region}.ec2messages"

  security_group_ids = [
    aws_security_group.endpoint_security_group.id
  ]
  subnet_ids = [
    aws_subnet.public_subnet_1.id,
  aws_subnet.public_subnet_2.id]

  vpc_endpoint_type   = "Interface"
  private_dns_enabled = true

}
