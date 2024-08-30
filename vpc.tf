resource "aws_vpc" "user5vpc" {
  default = "10.0.1.0/18"

  tags = {
    Name = "user5vpc"
  }

}

resource "aws_subnet" "publicsubnet" {
  cidr_block                      = var.websubnet
  vpc_id                          = aws_vpc.user5vpc.id
  map_customer_owned_ip_on_launch = true

  tags = {
    Name = "websubnet"
  }

}

resource "aws_subnet" "internalsubnet" {
  cidr_block                      = var.dbsubnet
  vpc_id                          = aws_vpc.user5vpc.id
  map_customer_owned_ip_on_launch = false

  tags = {
    Name = "dbsubnet"
  }

}

resource "aws_internet_gateway" "user5vpc-Intgw" {
  vpc_id = aws_vpc.user5vpc.id
  tags = {
    Name = "User5VPC Internetgateway"
  }

}


resource "aws_nat_gateway" "User5vpc-natgw" {
  allocation_id = aws_eip.User5vpc-natgw.id
  subnet_id     = aws_subnet.publicsubnet.id

  tags = {
    Name = "User5VPC-NAtgw for publicip"
  }

}


resource "aws_route_table" "RT_dbsubnet" {
  vpc_id = aws_vpc.user5vpc.id
  route = {
    cidr_block           = var.dbsubnet
    network_interface_id = aws_network_interface.user5vpc.id
    gateway_id           = "local"
  }

  tags = {
    Name = "Route table for the internal dbsubnet"
  }


}


resource "aws_route_table" "RT_websubnet" {
  vpc_id = aws_vpc.user5vpc.id
  route = {
    cidr_block           = "0.0.0.0/0"
    network_interface_id = aws_network_interface.user5vpc.id
    gateway_id           = aws_internet_gateway.user5vpc-Intgw.id

  }
  tags = {
    Name = "Route table for the internetfacing websubnet"
  }


}

resource "aws_route_table_association" "websubnet_rt_map" {
  subnet_id      = aws_subnet.publicsubnet
  route_table_id = aws_route_table.RT_websubnet.id
}

resource "aws_route_table_association" "dbsubnet_rt_map" {
  subnet_id      = aws_subnet.internalsubnet
  route_table_id = aws_route_table.RT_dbsubnet.id
}


resource "aws_network_acl" "ingress-http-acl" {
  vpc_id = aws_vpc.user5vpc.id

  ingress {
    protocol   = "tcp"
    rule_no    = 200
    action     = "allow"
    cidr_block = var.websubnet
    from_port  = 0
    to_port    = 80
  }

  egress {
    protocol   = "tcp"
    rule_no    = 100
    action     = "allow"
    cidr_block = var.websubnet
    from_port  = 0
    to_port    = 0
  }

  tags = {
    Name = "Nw-acl-http-webserver"
  }
}


resource "aws_network_acl" "ingress-ssh-acl" {
  vpc_id = aws_vpc.user5vpc.id

  ingress {
    protocol   = "tcp"
    rule_no    = 400
    action     = "allow"
    cidr_block = var.websubnet
    from_port  = 0
    to_port    = 22
  }

  egress {
    protocol   = "tcp"
    rule_no    = 300
    action     = "allow"
    cidr_block = var.websubnet
    from_port  = 0
    to_port    = 0
  }

  tags = {
    Name = "Nw-acl-http-webserver"
  }
}