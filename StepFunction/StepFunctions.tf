## Get the lambda function been create.
variable "pythonfunctionapparn" {
}

## AWS Step function role
resource "aws_iam_role" "step_function_role" {
  name               = "cloudquickpocsstepfunction-role"
  assume_role_policy = <<-EOF
  {
    "Version": "2012-10-17",
    "Statement": [
      {
        "Action": "sts:AssumeRole",
        "Principal": {
          "Service": "states.amazonaws.com"
        },
        "Effect": "Allow",
        "Sid": "StepFunctionAssumeRole"
      }
    ]
  }
  EOF
}

## AWS Step function role-policy
resource "aws_iam_role_policy" "step_function_policy" {
  name    = "cqpdstepfunctionrole-policy"
  role    = aws_iam_role.step_function_role.id

  policy  = <<-EOF
  {
    "Version": "2012-10-17",
    "Statement": [
      {
        "Action": [
          "lambda:InvokeFunction"
        ],
        "Effect": "Allow",
        "Resource": "${var.pythonfunctionapparn}"
      }
    ]
  }
  EOF
}

##AWS State function - State machine
resource "aws_sfn_state_machine" "sfn_state_machine" {
  name     = "cloudquickpocsstepfunction"
  role_arn = aws_iam_role.step_function_role.arn

  definition = <<EOF
  {
    "Comment": "Invoke AWS Lambda from AWS Step Functions with Terraform",
    "StartAt": "ExampleLambdaFunctionApp",
    "States": {
      "ExampleLambdaFunctionApp": {
        "Type": "Task",
        "Resource": "${var.pythonfunctionapparn}",
        "End": true
      }
    }
  }
  EOF
}