#-----------------------------------------------------------------------------
# Malicious VPC
#-----------------------------------------------------------------------------
resource "aws_vpc" "malicious_vpc" {
  cidr_block       = "10.0.0.0/16"
  instance_tenancy = "default"

  tags = {
    Name = "MaliciousVpc"
  }

}

#-----------------------------------------------------------------------------
# Internet Gateway
#-----------------------------------------------------------------------------

resource "aws_internet_gateway" "malicious_vpc_igw" {
  vpc_id = aws_vpc.malicious_vpc.id

  tags = {
    Name = "MaliciousInternetGateway"
  }

}


#-----------------------------------------------------------------------------
# Subnet
#-----------------------------------------------------------------------------
resource "aws_subnet" "malicious_subnet" {
  cidr_block              = "10.0.1.0/24"
  vpc_id                  = aws_vpc.malicious_vpc.id
  availability_zone       = data.aws_availability_zones.available.names[0]
  map_public_ip_on_launch = true

  tags = {
    Name = "MaliciousSubnet"
  }

}

#-----------------------------------------------------------------------------
# RT
#-----------------------------------------------------------------------------
resource "aws_route_table" "malicious_rt" {
  vpc_id = aws_vpc.malicious_vpc.id
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.malicious_vpc_igw.id
  }

  depends_on = [
    aws_internet_gateway.malicious_vpc_igw
  ]

  tags = {
    Name = "MaliciousRouteTable"
  }


}

resource "aws_route_table_association" "malicious_subnet_association" {
  route_table_id = aws_route_table.malicious_rt.id
  subnet_id      = aws_subnet.malicious_subnet.id

}
