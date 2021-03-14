resource "aws_iam_role" "sm_notebook_instance_role" {
  name = "sm-notebook-instance-role"

  tags = {
    Group     = "DemoIamSagmaker"
    CreatedBy = "CQPOCs"
  }

  assume_role_policy = <<EOF
{
    "Version": "2012-10-17",
    "Statement": [
        {
            "Effect": "Allow",
            "Principal": {
                "Service": "sagemaker.amazonaws.com"
            },
            "Action": "sts:AssumeRole"
        }
    ]
}
EOF
}

resource "aws_iam_role_policy_attachment" "sm_notebook_instance" {
  role       = aws_iam_role.sm_notebook_instance_role.name
  policy_arn = aws_iam_policy.sm_notebook_instance_policy.arn
}

resource "aws_iam_policy" "sm_notebook_instance_policy" {
  name        = "sm-notebook-instance-policy"
  description = "Policy for the Notebook Instance to manage training jobs, models and endpoints"
  path        = "/"

  policy = <<EOF
{
    "Version": "2012-10-17",
    "Statement": [
        {
            "Effect": "Allow",
            "Action": [
                "s3:GetBucketLocation",
                "s3:ListBucket",
                "s3:GetObject",
                "s3:PutObject",
                "s3:DeleteObject"
            ],
            "Resource": [
                "arn:aws:s3:::${aws_s3_bucket.s3_bucket_1.id}",
                "arn:aws:s3:::${aws_s3_bucket.s3_bucket_1.id}/*",
                "arn:aws:s3:::${aws_s3_bucket.fraud_detection_function_bucket.id}/*"
            ]
        },
        {
            "Effect": "Allow",
            "Action": [
                "sagemaker:CreateTrainingJob",
                "sagemaker:DescribeTrainingJob",
                "sagemaker:CreateModel",
                "sagemaker:DescribeModel",
                "sagemaker:DeleteModel",
                "sagemaker:CreateEndpoint",
                "sagemaker:CreateEndpointConfig",
                "sagemaker:DescribeEndpoint",
                "sagemaker:DescribeEndpointConfig",
                "sagemaker:DeleteEndpoint"
            ],
            "Resource": [
                "arn:aws:sagemaker:us-east-1:${data.aws_caller_identity.current.account_id}:*"
            ]
        },
        {
            "Effect": "Allow",
            "Action": [
                "ecr:GetDownloadUrlForLayer",
                "ecr:BatchGetImage",
                "ecr:BatchCheckLayerAvailability"
            ],
            "Resource": [
                "arn:aws:ecr:us-east-1:${data.aws_caller_identity.current.account_id}:repository/*"
            ]
        },
        {
            "Effect": "Allow",
            "Action": [
                "ec2:CreateVpcEndpoint",
                "ec2:DescribeRouteTables"
            ],
            "Resource": "*"
        },
        {
            "Sid": "EnforceInstanceType",
            "Effect": "Allow",
            "Action": [
                "sagemaker:CreateTrainingJob",
                "sagemaker:CreateHyperParameterTuningJob"
            ],
            "Resource": "*",
            "Condition": {
                "ForAllValues:StringLike": {
                    "sagemaker:InstanceTypes": ["ml.t2.large"]
                }
            }
        },
        {
            "Effect": "Allow",
            "Action": [
                "cloudwatch:PutMetricData",
                "cloudwatch:GetMetricData",
                "cloudwatch:GetMetricStatistics",
                "cloudwatch:ListMetrics"
            ],
            "Resource": [
                "arn:aws:cloudwatch:us-east-1:${data.aws_caller_identity.current.account_id}:*"
            ]
        },
        {
            "Effect": "Allow",
            "Action": [
                "logs:CreateLogGroup",
                "logs:CreateLogStream",
                "logs:DescribeLogStreams",
                "logs:GetLogEvents",
                "logs:PutLogEvents"
            ],
            "Resource": [
                "arn:aws:logs:us-east-1:${data.aws_caller_identity.current.account_id}:log-group:/aws/sagemaker/*"
            ]
        },
        {
            "Effect": "Allow",
            "Action": [
                "iam:PassRole"
            ],
            "Resource": [
                "${aws_iam_role.sm_notebook_instance_role.arn}"
            ],
            "Condition": {
                "StringEquals": {
                    "iam:PassedToService": "sagemaker.amazonaws.com"
                }
            }
        },
        {
            "Effect": "Allow",
            "Action": [
                "iam:GetRole"
            ],
            "Resource": [
                "${aws_iam_role.sm_notebook_instance_role.arn}"
            ]
        }
    ]
}
EOF
}
