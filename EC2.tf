## Random
resource "random_pet" "sg" {}

## AWS VPC
resource "aws_vpc" "awsec2demo" {
  cidr_block = "172.16.0.0/16"

  tags = {
    Name = "quickcloudpocs"
  }
}

## AWS VPC Subnet
resource "aws_subnet" "awsec2demo" {
  vpc_id            = aws_vpc.awsec2demo.id
  cidr_block        = "172.16.10.0/24"
  
  tags = {
    Name = "quickcloudpocs"
  }
}

## AWS Network Interface
resource "aws_network_interface" "awsec2demo" {
  subnet_id   = aws_subnet.awsec2demo.id
  private_ips = ["172.16.10.100"]

  tags = {
    Name = "quickcloudpocs"
  }
}

## AWS Security Group
resource "aws_security_group" "awsec2demo" {
  name = "${random_pet.sg.id}-sg"
  vpc_id      = aws_vpc.awsec2demo.id
  ingress {
    from_port   = 8080
    to_port     = 8080
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

## AWS EC2 
resource "aws_instance" "awsec2demo" {
  ami           = "ami-0be2609ba883822ec" # us-east-1
  instance_type = "t2.micro"
  vpc_security_group_ids = [aws_security_group.awsec2demo.id]

  network_interface {
    network_interface_id = aws_network_interface.awsec2demo.id
    device_index         = 0
  }
}

