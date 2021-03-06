## Get root data
data "aws_organizations_organization" "SCPDemoOU" {}

## OU Unit
resource "aws_organizations_organizational_unit" "SCPDemoOU" {
  name      = "SCPDemoOU"
  parent_id = aws_organizations_organization.SCPDemoOU.roots[0].id
}

## Attachiing policy
resource "aws_organizations_policy_attachment" "aws_ou_scp" {
  policy_id = aws_organizations_policy.aws_ou_scp.id
  target_id = aws_organizations_organizational_unit.SCPDemoOU.id
}

## Create SCP
resource "aws_organizations_policy" "aws_ou_scp" {
  name = "aws_ou_scp"
 content = <<CONTENT
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Sid": "DenyRootUser",
      "Effect": "Deny",
      "Action": "*",
      "Resource": "*",
      "Condition": {
        "StringLike": { "aws:PrincipalArn": "arn:aws:iam::*:root" }
      }
    },
    {
        "Effect": "Deny",
        "Action": "organizations:LeaveOrganization",
        "Resource": "*"
    }
  ]
}
CONTENT
}