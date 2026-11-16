# Create VPC
resource "aws_vpc" "tf-vpc-e2" {
  cidr_block       = "10.0.0.0/24"
  instance_tenancy = "default"

  tags = {
    Name = "vpc-tf-2"
  }
}

# Creating public subnet

resource "aws_subnet" "public-sn" {
  vpc_id     = aws_vpc.tf-vpc-e2.id
  cidr_block = "10.0.0.0/25"

  tags = {
    Name = "public-sn-e2"
  }
}

# Creating private Subnet
resource "aws_subnet" "private-sn" {
  vpc_id     = aws_vpc.tf-vpc-e2.id
  cidr_block = "10.0.0.128/25"

  tags = {
    Name = "private-sn-e2"
  }
}

# Creating internet gateway

resource "aws_internet_gateway" "igw" {
  vpc_id = aws_vpc.tf-vpc-e2.id

  tags = {
    Name = "igw-e2"
  }
}

# Creating public rt

resource "aws_route_table" "public-rt" {
  vpc_id = aws_vpc.tf-vpc-e2.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.igw.id
  }

  tags = {
    Name = "public-rt-e2"
  }
}

# Creating private rt

resource "aws_route_table" "private-rt" {
  vpc_id = aws_vpc.tf-vpc-e2.id

  tags = {
    Name = "private-rt-e2"
  }
}

# Associating public-rt to public-sn

resource "aws_route_table_association" "pub-rt-ass" {
  subnet_id      = aws_subnet.public-sn.id
  route_table_id = aws_route_table.public-rt.id
}

# Associating private-rt to private-sn

resource "aws_route_table_association" "priv-rt-ass" {
  subnet_id      = aws_subnet.private-sn.id
  route_table_id = aws_route_table.private-rt.id
}