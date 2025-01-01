
resource "aws_vpc" "task_vpc" {
  cidr_block       = "10.0.0.0/16"
  instance_tenancy = "default"

  tags = {
    Name = "task_vpc"
    purpose = var.upgrad_tag
  }
}

resource "aws_internet_gateway" "task_igw" {
  vpc_id = aws_vpc.task_vpc.id

  tags = {
    Name = "task_igw"
    purpose = var.upgrad_tag
  }
}

# public subnets 
resource "aws_subnet" "task_public_subnet_1a" {
  vpc_id     = aws_vpc.task_vpc.id
  cidr_block = "10.0.1.0/24"

  tags = {
    Name = "task_public_subnet_1a"
    purpose = var.upgrad_tag
  }
}

resource "aws_subnet" "task_public_subnet_1b" {
  vpc_id     = aws_vpc.task_vpc.id
  cidr_block = "10.0.2.0/24"

  tags = {
    Name = task_public_subnet_1b
    purpose = var.upgrad_tag
  }
}

# private subnets 

resource "aws_subnet" "task_private_subnet_1a_1" {
  vpc_id     = aws_vpc.task_vpc.id
  cidr_block = "10.0.3.0/24"

  tags = {
    Name = "task_private_subnet_1a_1"
    purpose = var.upgrad_tag
  }
}

resource "aws_subnet" "task_private_subnet_1a_2" {
  vpc_id     = aws_vpc.task_vpc.id
  cidr_block = "10.0.4.0/24"

  tags = {
    Name = "task_private_subnet_1a_2"
    purpose = var.upgrad_tag
  }
}

resource "aws_subnet" "task_private_subnet_1b_1" {
  vpc_id     = aws_vpc.task_vpc.id
  cidr_block = "10.0.5.0/24"

  tags = {
    Name = "task_private_subnet_1b_1"
    purpose = var.upgrad_tag
  }
}

resource "aws_subnet" "task_private_subnet_1b_2" {
  vpc_id     = aws_vpc.task_vpc.id
  cidr_block = "10.0.6.0/24"

  tags = {
    Name = "task_private_subnet_1b_1"
    purpose = var.upgrad_tag
  }
}

# NAT Gateway

resource "aws_eip" "task_lb" {
  domain   = "vpc"
}

resource "aws_nat_gateway" "task_ng" {
  allocation_id = aws_eip.task_lb.id
  subnet_id     = aws_subnet.task_public_subnet_1a.id

  tags = {
    Name = "task_nat"
    purpose = var.upgrad_tag
  }
}

# Route tables

resource "aws_route_table" "task_igw_rt" {
  vpc_id = aws_vpc.task_vpc.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.task_igw.id
  }

  tags = {
    Name = "task_rt_igw"
    purpose = var.upgrad_tag
  }
}

resource "aws_route_table" "task_nat_rt" {
  vpc_id = aws_vpc.task_vpc.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_nat_gateway.task_ng.id
  }

  tags = {
    Name = "task_rt_nat"
    purpose = var.upgrad_tag
  }
}

# Route tables association

# public
resource "aws_route_table_association" "task_public_subnet_1a_rt" {
  subnet_id      = aws_subnet.task_public_subnet_1a.id
  route_table_id = aws_route_table.task_igw_rt.id
}
resource "aws_route_table_association" "task_public_subnet_1b_rt" {
  subnet_id      = aws_subnet.task_public_subnet_1b.id
  route_table_id = aws_route_table.task_igw_rt.id
}

#private
resource "aws_route_table_association" "task_private_subnet_1a_1_rt" {
  subnet_id      = aws_subnet.task_private_subnet_1a_1.id
  route_table_id = aws_route_table.task_nat_rt.id
}
resource "aws_route_table_association" "task_private_subnet_1a_2_rt" {
  subnet_id      = aws_subnet.task_private_subnet_1a_2.id
  route_table_id = aws_route_table.task_nat_rt.id
}

resource "aws_route_table_association" "task_private_subnet_1b_1_rt" {
  subnet_id      = aws_subnet.task_private_subnet_1b_1.id
  route_table_id = aws_route_table.task_nat_rt.id
}

resource "aws_route_table_association" "task_private_subnet_1b_2_rt" {
  subnet_id      = aws_subnet.task_private_subnet_1b_2.id
  route_table_id = aws_route_table.task_nat_rt.id
}