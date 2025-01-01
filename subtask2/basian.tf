# Get the IPv4 of the machine in runtime
data "http" "myip" {
  url = "https://ipv4.icanhazip.com"
}

resource "aws_security_group" "bastian" {
  name        = "bastian"
  description = "Allow TLS inbound traffic and all outbound traffic"
  vpc_id      = aws_vpc.task_vpc.id

  tags = {
    Name = "bastian"
    purpose = var.upgrad_tag
  }
}

resource "aws_vpc_security_group_ingress_rule" "allow_tls_ipv4" {
  security_group_id = aws_security_group.bastian.id
  cidr_ipv4         = ["${chomp(data.http.myip.response_body)}/32"]
  from_port         = 22
  ip_protocol       = "tcp"
  to_port           = 22
}

resource "aws_vpc_security_group_egress_rule" "allow_all_traffic_ipv4" {
  security_group_id = aws_security_group.bastian.id
  cidr_ipv4         = "0.0.0.0/0"
  ip_protocol       = "-1" # semantically equivalent to all ports
}

resource "aws_vpc_security_group_egress_rule" "allow_all_traffic_ipv6" {
  security_group_id = aws_security_group.bastian.id
  cidr_ipv6         = "::/0"
  ip_protocol       = "-1" # semantically equivalent to all ports
}


module "ec2_instance" {
  source  = "terraform-aws-modules/ec2-instance/aws"

  name = "bastian-instance"

  instance_type          = "t2.medium"
  key_name               = "upgrad_auth"
  monitoring             = true
  vpc_security_group_ids = aws_security_group.bastian.id
  subnet_id              = aws_subnet.task_public_subnet_1a.id

  tags = {
    Name = "task_bastian"
    purpose = var.upgrad_tag
  }
}

