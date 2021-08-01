#-----------------------------------------------------------------------------
#VPC
#-----------------------------------------------------------------------------
resource "aws_vpc" "vpc" {
  cidr_block         = "10.1.0.0/16"
  enable_dns_support = true

  tags = {
    Name = "firewall-demo-vpc"
  }
}

#-----------------------------------------------------------------------------
# Internet Gateway
#-----------------------------------------------------------------------------
resource "aws_internet_gateway" "igw" {
  vpc_id = aws_vpc.vpc.id

  tags = {
    Name = "firewall-demo-vpc-igw"
  }

}

#-----------------------------------------------------------------------------
# Firewall Subnets
#-----------------------------------------------------------------------------
resource "aws_subnet" "firewall_subnet_1" {
  cidr_block = "10.1.16.0/28"
  vpc_id     = aws_vpc.vpc.id

  tags = {
    Name = "firewall_subnet_1"
  }

}

resource "aws_subnet" "firewall_subnet_2" {
  cidr_block = "10.1.16.16/28"
  vpc_id     = aws_vpc.vpc.id

  tags = {
    Name = "firewall_subnet_2"
  }

}

#-----------------------------------------------------------------------------
# Firewall Route Table
#-----------------------------------------------------------------------------
resource "aws_route_table" "firewall_route_table_1" {

  vpc_id = aws_vpc.vpc.id

  tags = {
    Name = "firewall_route_table_1"
  }

}

resource "aws_route_table" "firewall_route_table_2" {

  vpc_id = aws_vpc.vpc.id

  tags = {
    Name = "firewall_route_table_2"
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
  cidr_block = "10.1.1.0/24"
  vpc_id     = aws_vpc.vpc.id

  tags = {
    Name = "public_subnet_1"
  }

}

resource "aws_subnet" "public_subnet_2" {
  cidr_block = "10.1.3.0/24"
  vpc_id     = aws_vpc.vpc.id

  tags = {
    Name = "public_subnet_2"
  }

}

#-----------------------------------------------------------------------------
# public Route Table
#-----------------------------------------------------------------------------
resource "aws_route_table" "public_route_table_1" {

  vpc_id = aws_vpc.vpc.id

  tags = {
    Name = "public_route_table_1"
  }

}

resource "aws_route_table" "public_route_table_2" {

  vpc_id = aws_vpc.vpc.id

  tags = {
    Name = "public_route_table_2"
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
# Internet Route Config
#-----------------------------------------------------------------------------
resource "aws_route" "public_subnet_1_route" {
  destination_cidr_block = "0.0.0.0/0"
  route_table_id         = aws_route_table.public_route_table_1.id
  gateway_id             = aws_internet_gateway.igw.id
}

resource "aws_route" "public_subnet_2_route" {
  destination_cidr_block = "0.0.0.0/0"
  route_table_id         = aws_route_table.public_route_table_2.id
  gateway_id             = aws_internet_gateway.igw.id

}


/*
 * private Route Config
 */

#-----------------------------------------------------------------------------
# Firewall Subnets
#-----------------------------------------------------------------------------
resource "aws_subnet" "private_subnet_1" {
  cidr_block = "10.1.0.0/24"
  vpc_id     = aws_vpc.vpc.id

  tags = {
    Name = "private_subnet_1"
  }

}

resource "aws_subnet" "private_subnet_2" {
  cidr_block = "10.1.2.0/24"
  vpc_id     = aws_vpc.vpc.id

  tags = {
    Name = "private_subnet_2"
  }

}

#-----------------------------------------------------------------------------
# private Route Table
#-----------------------------------------------------------------------------
resource "aws_route_table" "private_route_table_1" {

  vpc_id = aws_vpc.vpc.id

  tags = {
    Name = "private_route_table_1"
  }

}

resource "aws_route_table" "private_route_table_2" {

  vpc_id = aws_vpc.vpc.id

  tags = {
    Name = "private_route_table_2"
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
# Internet Route Config
#-----------------------------------------------------------------------------
resource "aws_route" "private_subnet_1_route" {
  destination_cidr_block = "0.0.0.0/0"
  route_table_id         = aws_route_table.private_route_table_1.id
  gateway_id             = aws_nat_gateway.nat_gateway_1.id
}

resource "aws_route" "private_subnet_2_route" {
  destination_cidr_block = "0.0.0.0/0"
  route_table_id         = aws_route_table.private_route_table_2.id
  gateway_id             = aws_nat_gateway.nat_gateway_2.id

}


#----------------------------------------------------------------------------
# Ingress Route Table for return traffic
#-----------------------------------------------------------------------------
resource "aws_route_table" "ingress_route_table" {
  vpc_id = aws_vpc.vpc.id

  tags = {
    Name = "ingress_route_table"
  }

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
