## Create VPC-1
resource "aws_vpc" "useastvpccqpoc" {
  cidr_block = "10.1.0.0/16"
  tags = {
    Name = "VPC-1"
  }
}

## Create VPC-2
resource "aws_vpc" "uswestvpccqpoc" {
  provider   =  aws.central
  cidr_block = "172.16.0.0/16"
  tags = {
    Name = "VPC-2"
  }
}

## Create Peering between VPC-1 and VPC-2
resource "aws_vpc_peering_connection" "vpcpeerigdemo" {
  peer_owner_id = "357171621133"
  peer_vpc_id   = aws_vpc.uswestvpccqpoc.id
  vpc_id        = aws_vpc.useastvpccqpoc.id
  peer_region   = "us-west-1"
  auto_accept   = false

  tags = {
    Name = "VPC1cqpocs-to-VPC2cqpocs"
  }
}

## Accepter's side of the connection.
resource "aws_vpc_peering_connection_accepter" "peer" {
  provider                  =  aws.central
  vpc_peering_connection_id = aws_vpc_peering_connection.vpcpeerigdemo.id
  auto_accept               = true

  tags = {
    Side = "Accepter"
  }
}
