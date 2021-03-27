##  Adding an user in multiple groups
resource "aws_iam_user_group_membership" "MultipleGroups" {
  user = aws_iam_user.U1.name

  groups = [
    aws_iam_group.G1.name,
    aws_iam_group.G2.name,
  ]
}

## Adding an user to a group
resource "aws_iam_user_group_membership" "SingleGroups" {
  user = aws_iam_user.U1.name

  groups = [
    aws_iam_group.G3.name,
  ]
}

# User1
resource "aws_iam_user" "U1" {
  name = "user1"
}

# Group1
resource "aws_iam_group" "G1" {
  name = "group1"
}

# Group2
resource "aws_iam_group" "G2" {
  name = "group2"
}

# Group3
resource "aws_iam_group" "G3" {
  name = "group3"
}

##