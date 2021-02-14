## AWS aws_organizations
resource "aws_organizations_organization" "cqpocs" {}

## DEV
resource "aws_organizations_organizational_unit" "dev" {
  name      = "DEV"
  parent_id = "${aws_organizations_organization.test.roots.0.id}"
}

## TST
resource "aws_organizations_organizational_unit" "tst" {
  name      = "TEST"
  parent_id = "${aws_organizations_organization.test.roots.0.id}"
}

## PROD
resource "aws_organizations_organizational_unit" "prod" {
  name      = "PROD"
  parent_id = "${aws_organizations_organization.test.roots.0.id}"
}

## Move an AWS Account to destination OU
resource "aws_organizations_account" "example" {
  email     = "vrchinnarathod@gmail.com"
  name      = "Rekhu Gopal"
  parent_id = "${aws_organizations_organizational_unit.dev.id}"
}