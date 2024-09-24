variable "aws_access_key_id" {
  description = "Key ID"
  sensitive = true
}

variable "aws_secret_access_key" {
  description = "Secret Access Key"
  sensitive = true
}
variable "aws_session_token" {
  description = "Session Token"
  sensitive = true
}

provider "aws" {
  region     = "us-east-1"
  access_key = var.aws_access_key_id
  secret_key = var.aws_secret_access_key
  token      = var.aws_session_token
}

resource "aws_vpc" "testVPC" {
  cidr_block = "10.0.0.0/16"

  enable_dns_hostnames = true

  tags = {
    Name = "testVPC"
  }
}

resource "aws_subnet" "Public1" {
  vpc_id            = aws_vpc.testVPC.id
  cidr_block        = "10.0.1.0/24"
  availability_zone = "us-east-1b"
  map_public_ip_on_launch = true

  tags = {
    Name = "Public1"
  }
}

resource "aws_internet_gateway" "Public1_IGW" {
  vpc_id = aws_vpc.testVPC.id

  tags = {
    Name = "Public1_IGW"
  }
}

# resource "aws_internet_gateway_attachment" "Public1_IGW_Attachment" {
#   vpc_id             = aws_vpc.testVPC.id
#   internet_gateway_id = aws_internet_gateway.Public1_IGW.id
# }

resource "aws_route_table" "Public1_RT" {
  vpc_id = aws_vpc.testVPC.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.Public1_IGW.id
  }
  
  tags = {
    Name = "Public1_RT"
  }
}

resource "aws_route_table_association" "Public1_RT_Association" {
  subnet_id      = aws_subnet.Public1.id
  route_table_id = aws_route_table.Public1_RT.id
}