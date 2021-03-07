## Get root data
data "aws_organizations_organization" "SCPDemoOU" {}

## OU Unit
resource "aws_organizations_organizational_unit" "SCPDemoOU" {
  name      = "SCPDemoOU"
  parent_id = data.aws_organizations_organization.SCPDemoOU.roots.0.id
}

## Attachiing policy to OU
resource "aws_organizations_policy_attachment" "aws_ou_scp" {
  policy_id = aws_organizations_policy.aws_ou_scp.id
  target_id = aws_organizations_organizational_unit.SCPDemoOU.id
}

## Create SCP - to stop other than "t2.micro" instance
resource "aws_organizations_policy" "aws_ou_scp" {
  name = "aws_ou_scp"
 content = <<CONTENT
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Sid": "RequireMicroInstanceType",
      "Effect": "Deny",
      "Action": "ec2:RunInstances",
      "Resource": "arn:aws:ec2:*:*:instance/*",
      "Condition": {
        "StringNotEquals":{               	
          "ec2:InstanceType":"t2.micro"
        }
      }
    }
  ]
}
CONTENT
}