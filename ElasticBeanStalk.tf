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
}

## VPC Subnet
resource "aws_subnet" "main" {
  vpc_id     = aws_vpc.main.id
  cidr_block = "10.0.1.0/24"

  tags = {
    Name = "Main"
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
    value     = "${aws_vpc.main.arn}"
  }

  setting {
    namespace = "aws:ec2:vpc"
    name      = "Subnets"
    value     = "${aws_subnet.main.arn}"
  }
}