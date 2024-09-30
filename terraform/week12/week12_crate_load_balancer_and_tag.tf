##################################################################################
# VARIABLES
##################################################################################

variable "aws_access_key" {}
variable "aws_secret_key" {}
variable "aws_session_token" {}
variable "private_key_path" {}
variable "key_name" {}

variable "region" {
  default = "us-east-1"
}
variable "network_address_space" {
  default = "10.0.0.0/16"
}
variable "subnet1_address_space" {
  default = "10.0.1.0/24"
}
variable "subnet2_address_space" {
  default = "10.0.2.0/24"
}

##################################################################################
# PROVIDERS
##################################################################################

provider "aws" {
  access_key = var.aws_access_key
  secret_key = var.aws_secret_key
  token      = var.aws_session_token
  region     = var.region
}

##################################################################################
# DATA
##################################################################################

data "aws_ami" "aws-linux" {
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

##################################################################################
# Ref
# https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/
##################################################################################
# RESOURCES
##################################################################################

resource "aws_vpc" "testVPC" {
  cidr_block           = var.network_address_space
  enable_dns_hostnames = true

  tags = {
    Name = "itKMITL-testVPC"
  }
}

resource "aws_subnet" "Public1" {
  vpc_id                  = aws_vpc.testVPC.id
  cidr_block              = var.subnet1_address_space
  map_public_ip_on_launch = true

  tags = {
    Name = "itKMITL-Public1"
  }
}

resource "aws_subnet" "Public2" {
  vpc_id                  = aws_vpc.testVPC.id
  cidr_block              = var.subnet2_address_space
  map_public_ip_on_launch = true
  availability_zone = "us-east-1b"

  tags = {
    Name = "itKMITL-Public2"
  }
}


resource "aws_internet_gateway" "testIgw" {
  vpc_id = aws_vpc.testVPC.id

  tags = {
    Name = "itKMITL-testIgw"
  }
}

resource "aws_route_table" "publicRoute" {
  vpc_id = aws_vpc.testVPC.id
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.testIgw.id
  }
  tags = {
    Name = "itKMITL-publicRoute"
  }
}

resource "aws_route_table_association" "rt-pubsub1" {
  subnet_id      = aws_subnet.Public1.id
  route_table_id = aws_route_table.publicRoute.id
}

resource "aws_security_group" "allow_ssh_web" {
  name        = "itKMITL-npaWk11_demo"
  description = "Allow ssh and web access"
  vpc_id      = aws_vpc.testVPC.id

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = -1
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_instance" "Server1" {
  ami                    = data.aws_ami.aws-linux.id
  instance_type          = "t2.micro"
  key_name               = var.key_name
  vpc_security_group_ids = [aws_security_group.allow_ssh_web.id]
  subnet_id              = aws_subnet.Public1.id

  tags = {
    Name    = "itKMITL-Server1"
    itclass = "npa23"
    itgroup = "year3"
  }
}

resource "aws_instance" "Server2" {
  ami                    = data.aws_ami.aws-linux.id
  instance_type          = "t2.micro"
  key_name               = var.key_name
  vpc_security_group_ids = [aws_security_group.allow_ssh_web.id]
  subnet_id              = aws_subnet.Public1.id

  tags = {
    Name    = "itKMITL-Server2"
    itclass = "npa23"
    itgroup = "year3"
  }
}

##################################################################################
# OUTPUT
##################################################################################

output "aws_instance_public_ip_server1" {
  value = aws_instance.Server1.public_ip
}

output "aws_instance_public_ip_server2" {
  value = aws_instance.Server2.public_ip
}

resource "aws_lb" "elb-webLB" {
  name               = "itKMITL-elb-webLB"
  internal           = false
  load_balancer_type = "application"
  security_groups    = [aws_security_group.allow_ssh_web.id]
  subnets            = [aws_subnet.Public1.id, aws_subnet.Public2.id]
}

resource "aws_lb_target_group" "elb-webLB-tg" {
  name        = "itKMITL-elb-webLB-tg"
  port        = 80
  protocol    = "HTTP"
  target_type = "instance"
  vpc_id      = aws_vpc.testVPC.id
}

resource "aws_lb_target_group_attachment" "elb-webLB-tg-attach-server1" {
  target_group_arn = aws_lb_target_group.elb-webLB-tg.arn
  target_id        = aws_instance.Server1.id
  port             = 80
}

resource "aws_lb_target_group_attachment" "elb-webLB-tg-attach-server2" {
  target_group_arn = aws_lb_target_group.elb-webLB-tg.arn
  target_id        = aws_instance.Server1.id
  port             = 80
}

resource "aws_lb_listener" "elb-webLB-listener" {
  load_balancer_arn = aws_lb.elb-webLB.arn
  port              = 80
  protocol          = "HTTP"
  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.elb-webLB-tg.arn
  }

  tags = {
    Name = "itKMITL-elb-webLB-listener"
  }
}
