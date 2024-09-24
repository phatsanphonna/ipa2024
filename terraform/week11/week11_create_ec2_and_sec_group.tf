data "aws_ami" "amzn-linux" {
  most_recent = true
  owners      = ["amazon"]

  filter {
    name   = "name"
    values = ["al2023-ami-2023.*-x86_64"]
  }

  filter {
    name   = "root-device-type"
    values = ["ebs"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }
}

resource "aws_security_group" "AllowSSHandWeb" {
  name   = "AllowSSHandWeb"
  vpc_id = aws_vpc.testVPC.id

  tags = {
    name = "AllowSSHandWeb"
  }
}

resource "aws_vpc_security_group_ingress_rule" "AllowSSHandWeb_SSH" {
  security_group_id = aws_security_group.AllowSSHandWeb.id
  cidr_ipv4         = "0.0.0.0/0"
  from_port         = 22
  ip_protocol       = "tcp"
  to_port           = 22

  tags = {
    Name = "SSH"
  }
}

resource "aws_vpc_security_group_ingress_rule" "AllowSSHandWeb_Web" {
  security_group_id = aws_security_group.AllowSSHandWeb.id
  cidr_ipv4         = "0.0.0.0/0"
  from_port         = 443
  ip_protocol       = "tcp"
  to_port           = 443

  tags = {
    Name = "Web"
  }
}

resource "aws_instance" "tfTest" {
  availability_zone = aws_subnet.Public1.availability_zone

  ami           = data.aws_ami.amzn-linux.id
  instance_type = "t2.micro"

  subnet_id       = aws_subnet.Public1.id
  security_groups = [aws_security_group.AllowSSHandWeb.id]

  key_name = "vockey"

  root_block_device {
    volume_type = "gp2"
    volume_size = 8
  }

  tags = {
    Name = "tfTest"
  }
}
