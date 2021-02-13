## AWS IAM Instance Profile
resource "aws_iam_instance_profile" "test_profile" {
  name = "test_profile"
  role = aws_iam_role.role.name
}

## AWS IAM Role
resource "aws_iam_role" "role" {
  name = "test_role"
  path = "/"

  assume_role_policy = <<EOF
{
    "Version": "2012-10-17",
    "Statement": [
        {
            "Action": "sts:AssumeRole",
            "Principal": {
               "Service": "ec2.amazonaws.com"
            },
            "Effect": "Allow",
            "Sid": ""
        }
    ]
}
EOF
}

## VPC
resource "aws_vpc" "main" {
  cidr_block = "10.0.0.0/16"
   tags = {
    Name = "MainVPC"
  }
}

## VPC Subnet
resource "aws_subnet" "main" {
  vpc_id     = aws_vpc.main.id
  cidr_block = "10.0.1.0/24"

  tags = {
    Name = "Main"
  }
}

## VPC ELBSubnets
resource "aws_subnet" "ELBSubnets" {
  vpc_id     = aws_vpc.main.id
  cidr_block = "10.0.2.0/27"

  tags = {
    Name = "ELBSubnets"
  }
}

## Internet Gateway
resource "aws_internet_gateway" "gw" {
  vpc_id = aws_vpc.main.id

  tags = {
    Name = "main"
  }
}

## AWS Security Securitygroup
resource "aws_security_group" "sg" {
  name        = "allow_tls"
  description = "Allow TLS inbound traffic"
  vpc_id      = aws_vpc.main.id

  ingress {
    description = "TLS from VPC"
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = [aws_vpc.main.cidr_block]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "allow_tls"
  }
}

## Elastic bean stalk app
resource "aws_elastic_beanstalk_application" "application" {
  name        = "my-cqpocs-app"
}

## Elastic bean stalk app environment
resource "aws_elastic_beanstalk_environment" "environment" {
  name                = "my-cqpocs-environment"
  application         = aws_elastic_beanstalk_application.application.name
  solution_stack_name = "64bit Amazon Linux 2 v3.1.5 running Python 3.7"
  setting {
        namespace = "aws:autoscaling:launchconfiguration"
        name      = "IamInstanceProfile"
        value     =  "${aws_iam_instance_profile.test_profile.arn}"
   }
  setting {
    namespace = "aws:ec2:vpc"
    name      = "VPCId"
    value     = "${aws_vpc.main.id}"
  }

  setting {
    namespace = "aws:ec2:vpc"
    name      = "Subnets"
    value     = "${aws_subnet.main.id}"
  }

    setting {
    namespace = "aws:ec2:vpc"
    name = "ELBSubnets"
    value = "${aws_subnet.ELBSubnets.id}"
  }

    setting {
    namespace = "aws:ec2:vpc"
    name = "AssociatePublicIpAddress"
    value = "true"
  }

  setting {
    namespace = "aws:ec2:vpc"
    name = "ELBScheme"
    value = "internal"
  }
    setting {
    namespace = "aws:autoscaling:launchconfiguration"
    name = "SecurityGroups"
    value = "${aws_security_group.sg.id}"
  }
}