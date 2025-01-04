resource "aws_security_group" "private_ec2_sg" {
  name        = "private_ec2_sg"
  description = "Allow TLS inbound traffic and all outbound traffic"
  vpc_id      = aws_vpc.task_vpc.id

  tags = {
    Name    = "private_ec2_sg"
    purpose = var.upgrad_tag
  }
}

resource "aws_vpc_security_group_ingress_rule" "allow_tls_ipv4_private" {
  security_group_id = aws_security_group.private_ec2_sg.id
  cidr_ipv4         = var.vpc_cidr # only allow all incoming traffic from within VPC
  ip_protocol       = "-1" # semantically equivalent to all ports
}

resource "aws_vpc_security_group_egress_rule" "allow_all_traffic_ipv4_private" {
  security_group_id = aws_security_group.private_ec2_sg.id
  cidr_ipv4         = "0.0.0.0/0"
  ip_protocol       = "-1" # semantically equivalent to all ports
}

resource "aws_vpc_security_group_egress_rule" "allow_all_traffic_ipv6_private" {
  security_group_id = aws_security_group.private_ec2_sg.id
  cidr_ipv6         = "::/0"
  ip_protocol       = "-1" # semantically equivalent to all ports
}


resource "aws_instance" "jenkins_host" {
  ami           = "ami-0e2c8caa4b6378d8c"
  instance_type = "t3.medium"
  subnet_id = aws_subnet.task_private_subnet_1a_1.id
  security_groups = [aws_security_group.private_ec2_sg.id]
  key_name = "prac_auth"
  tags = {
    Name    = "jenkins_host"
    purpose = var.upgrad_tag
  }
}

resource "aws_instance" "app" {
  ami           = "ami-0e2c8caa4b6378d8c"
  instance_type = "t3.medium"
  subnet_id = aws_subnet.task_private_subnet_1a_1.id
  security_groups = [aws_security_group.private_ec2_sg.id]
  key_name = "prac_auth"
  tags = {
    Name    = "app"
    purpose = var.upgrad_tag
  }
}

# resource "aws_instance" "task_private_1b" {
#   ami           = "ami-0e2c8caa4b6378d8c"
#   instance_type = "t3.medium"
#   subnet_id = aws_subnet.task_private_subnet_1b_1.id
#   security_groups = [aws_security_group.private_ec2_sg.id]
#   key_name = "auth"
#   tags = {
#     Name    = "task_private_1b"
#     purpose = var.upgrad_tag
#   }
# }
