#---------------------------------------------------------------------------
# Inspection VPC
#---------------------------------------------------------------------------
resource "aws_vpc" "inspection_vpc" {
  cidr_block       = "100.64.0.0/16"
  instance_tenancy = "default"

  tags = {
    Name = "inspection-vpc"
  }

}

#---------------------------------------------------------------------------
# Firewall Subnets
#---------------------------------------------------------------------------
resource "aws_subnet" "inspection_vpc_firewall_subnet_a" {
  vpc_id            = aws_vpc.inspection_vpc.id
  availability_zone = "ap-southeast-2a"
  cidr_block        = "100.64.32.0/19"

  tags = {
    Name = "inspection-vpc/firewall-subnet-a"
  }

}

resource "aws_subnet" "inspection_vpc_firewall_subnet_b" {
  vpc_id            = aws_vpc.inspection_vpc.id
  availability_zone = "ap-southeast-2b"
  cidr_block        = "100.64.64.0/19"

  tags = {
    Name = "inspection-vpc/firewall-subnet-b"
  }

}

resource "aws_subnet" "inspection_vpc_firewall_subnet_c" {
  vpc_id            = aws_vpc.inspection_vpc.id
  availability_zone = "ap-southeast-2c"
  cidr_block        = "100.64.96.0/19"

  tags = {
    Name = "inspection-vpc/firewall-subnet-c"
  }

}

#---------------------------------------------------------------------------
# Transit Gateway  Subnets
#---------------------------------------------------------------------------
resource "aws_subnet" "inspection_vpc_tgw_subnet_a" {
  vpc_id            = aws_vpc.inspection_vpc.id
  availability_zone = "ap-southeast-2a"
  cidr_block        = "100.64.128.0/19"

  tags = {
    Name = "inspection-vpc/firewall-subnet-a"
  }

}

resource "aws_subnet" "inspection_vpc_tgw_subnet_b" {
  vpc_id            = aws_vpc.inspection_vpc.id
  availability_zone = "ap-southeast-2b"
  cidr_block        = "100.64.160.0/19"

  tags = {
    Name = "inspection-vpc/firewall-subnet-b"
  }

}

resource "aws_subnet" "inspection_vpc_tgw_subnet_c" {
  vpc_id            = aws_vpc.inspection_vpc.id
  availability_zone = "ap-southeast-2c"
  cidr_block        = "100.64.192.0/19"

  tags = {
    Name = "inspection-vpc/firewall-subnet-c"
  }

}

#---------------------------------------------------------------------------
# Firewall Route Table
#---------------------------------------------------------------------------
resource "aws_route_table" "inspection_vpc_firewall_rt" {
  vpc_id = aws_vpc.inspection_vpc.id

  route {
    cidr_block      = "0.0.0.0/0"
    vpc_endpoint_id = (aws_networkfirewall_firewall.nfw.firewall_status[0].sync_states[*].attachment[0].endpoint_id)[0]
  }

  depends_on = [
    aws_networkfirewall_firewall.nfw
  ]

  tags = {
    Name = "inspection-vpc/firewall-route-table"
  }

}

resource "aws_route_table_association" "firewall_subnet_association_a" {
  subnet_id      = aws_subnet.inspection_vpc_firewall_subnet_a.id
  route_table_id = aws_route_table.inspection_vpc_firewall_rt.id

}

resource "aws_route_table_association" "firewall_subnet_association_b" {
  subnet_id      = aws_subnet.inspection_vpc_firewall_subnet_b.id
  route_table_id = aws_route_table.inspection_vpc_firewall_rt.id

}


resource "aws_route_table_association" "firewall_subnet_association_c" {
  subnet_id      = aws_subnet.inspection_vpc_firewall_subnet_c.id
  route_table_id = aws_route_table.inspection_vpc_firewall_rt.id

}

#---------------------------------------------------------------------------
# Transit Gateway  Route Table
#---------------------------------------------------------------------------
resource "aws_route_table" "inspection_vpc_tgw_rt" {
  vpc_id = aws_vpc.inspection_vpc.id

  route {
    cidr_block         = "0.0.0.0/0"
    transit_gateway_id = aws_ec2_transit_gateway.tgw.id
  }

  # depends_on = [
  #   module.tgw.ec2_transit_gateway_id
  # ]


  tags = {
    Name = "inspection-vpc/tgw-route-table"
  }

}

resource "aws_route_table_association" "tgw_subnet_association_a" {
  subnet_id      = aws_subnet.inspection_vpc_tgw_subnet_a.id
  route_table_id = aws_route_table.inspection_vpc_tgw_rt.id

}

resource "aws_route_table_association" "tgw_subnet_association_b" {
  subnet_id      = aws_subnet.inspection_vpc_tgw_subnet_b.id
  route_table_id = aws_route_table.inspection_vpc_tgw_rt.id

}


resource "aws_route_table_association" "tgw_subnet_association_c" {
  subnet_id      = aws_subnet.inspection_vpc_tgw_subnet_c.id
  route_table_id = aws_route_table.inspection_vpc_tgw_rt.id

}

