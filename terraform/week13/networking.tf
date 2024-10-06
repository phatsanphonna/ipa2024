resource "aws_vpc" "testVPC" {
  cidr_block           = var.network_address_space
  enable_dns_hostnames = true

  tags = {
    Name    = "${local.prefix}testVPC"
    itclass = local.itclass
    itgroup = local.itgroup
  }
}

resource "aws_subnet" "Public1" {
  vpc_id                  = aws_vpc.testVPC.id
  cidr_block              = var.subnet1_address_space
  map_public_ip_on_launch = true
  availability_zone       = var.availability_zone.zone_a

  tags = {
    Name    = "${local.prefix}Public1"
    itclass = local.itclass
    itgroup = local.itgroup
  }
}

resource "aws_subnet" "Public2" {
  vpc_id                  = aws_vpc.testVPC.id
  cidr_block              = var.subnet2_address_space
  map_public_ip_on_launch = true
  availability_zone       = var.availability_zone.zone_b

  tags = {
    Name    = "${local.prefix}Public2"
    itclass = local.itclass
    itgroup = local.itgroup
  }
}

resource "aws_internet_gateway" "testIgw" {
  vpc_id = aws_vpc.testVPC.id

  tags = {
    Name    = "${local.prefix}testIgw"
    itclass = local.itclass
    itgroup = local.itgroup
  }
}

resource "aws_route_table" "publicRoute" {
  vpc_id = aws_vpc.testVPC.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.testIgw.id
  }

  tags = {
    Name    = "${local.prefix}publicRoute"
    itclass = local.itclass
    itgroup = local.itgroup
  }
}

resource "aws_route_table_association" "rt-pubsub1" {
  subnet_id      = aws_subnet.Public1.id
  route_table_id = aws_route_table.publicRoute.id
}
