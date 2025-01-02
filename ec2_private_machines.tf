# data "external" "local_ip" {
#   program = ["bash", "get_ip.sh"]

#   provisioner "local-exec" {
#     command = "echo 'IP address is: ${self.id}'"
#   }
# }

resource "aws_security_group" "private_ec2_sg" {
  name        = "private_ec2_sg"
  description = "Allow TLS inbound traffic and all outbound traffic"
  vpc_id      = aws_vpc.task_vpc.id

  tags = {
    Name    = "private_ec2_sg"
    purpose = var.upgrad_tag
  }
}

resource "aws_vpc_security_group_ingress_rule" "allow_tls_ipv4" {
  security_group_id = aws_security_group.private_ec2_sg.id
  cidr_ipv4         = var.vpc_cidr
  ip_protocol       = "-1" # semantically equivalent to all ports
}

resource "aws_vpc_security_group_egress_rule" "allow_all_traffic_ipv4" {
  security_group_id = aws_security_group.private_ec2_sg.id
  cidr_ipv4         = "0.0.0.0/0"
  ip_protocol       = "-1" # semantically equivalent to all ports
}

resource "aws_vpc_security_group_egress_rule" "allow_all_traffic_ipv6" {
  security_group_id = aws_security_group.private_ec2_sg.id
  cidr_ipv6         = "::/0"
  ip_protocol       = "-1" # semantically equivalent to all ports
}


module "ec2_instance" {
  
  name = "private_ec2_instance"

  ami = "ami-0e2c8caa4b6378d8c"
  instance_type               = "t2.medium"
  key_name                    = "auth"
  monitoring                  = true
  associate_public_ip_address = true
  subnet_id                   = aws_subnet.task_private_subnet_1a_1.id
  vpc_security_group_ids = [aws_security_group.private_ec2_sg.id]

  tags = {
    Name    = "task_private_1a"
    purpose = var.upgrad_tag
  }
}

module "ec2_instance" {
  
  name = "private_ec2_instance"

  ami = "ami-0e2c8caa4b6378d8c"
  instance_type               = "t2.medium"
  key_name                    = "auth"
  monitoring                  = true
  associate_public_ip_address = true
  subnet_id                   = aws_subnet.task_private_subnet_1b_1.id
  vpc_security_group_ids = [aws_security_group.private_ec2_sg.id]

  tags = {
    Name    = "task_private_1b"
    purpose = var.upgrad_tag
  }
}