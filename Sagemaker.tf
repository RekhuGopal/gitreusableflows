data "aws_caller_identity" "current" {}

data "aws_region" "current" {}

resource "aws_iam_role" "sgmrole" {
  name = "terraform-sagemaker-cqpocs-role"
  path = "/"
  assume_role_policy = "${data.aws_iam_policy_document.assume_role.json}"
}

data "aws_iam_policy_document" "assume_role" {
  statement {
    actions = [ "sts:AssumeRole" ]
    principals {
      type = "Service"
      identifiers = [ "sagemaker.amazonaws.com" ]
    }
  }
}

resource "aws_iam_policy" "sgmpolicy" {
  name = "terraform-sagemaker-cqpocs-policy"
  description = "Allow Sagemaker to create model"
  policy = "${data.aws_iam_policy_document.policydef.json}"
}

data "aws_iam_policy_document" "policydef" {
  statement {
    effect = "Allow"
    actions = [
      "sagemaker:*"
    ]
    resources = [
      "*"
    ]
  }
  statement {
    effect = "Allow"
    actions = [
      "cloudwatch:PutMetricData",
      "logs:CreateLogStream",
      "logs:PutLogEvents",
      "logs:CreateLogGroup",
      "logs:DescribeLogStreams",
      "ecr:GetAuthorizationToken",
      "ecr:BatchCheckLayerAvailability",
      "ecr:GetDownloadUrlForLayer",
      "ecr:BatchGetImage"
    ]
    resources = [
      "*"]
  }
  statement {
    effect = "Allow"
    actions = [
      "s3:GetObject"
    ]
    resources = [
      "arn:aws:s3:::${aws_s3_bucket.buckettostoremodel.bucket}",
      "arn:aws:s3:::${aws_s3_bucket.buckettostoremodel.bucket}/*"
    ]
  }
}

resource "aws_iam_role_policy_attachment" "role_policy" {
  role = "${aws_iam_role.sgmrole.name}"
  policy_arn = "${aws_iam_policy.sgmpolicy.arn}"
}

resource "aws_s3_bucket" "buckettostoremodel" {
  bucket = "terraform-sagemaker"
  acl    = "private"
  force_destroy = true
}

resource "aws_s3_bucket_object" "object" {
  bucket = "${aws_s3_bucket.buckettostoremodel.bucket}"
  key    = "model.tar.gz"
  source = "model.tar.gz"
}

resource "aws_sagemaker_model" "sgmmodel" {
  name = "terraform-sagemaker-model"
  execution_role_arn = "${aws_iam_role.sgmrole.arn}"

  primary_container {
    image = "${data.aws_caller_identity.current.account_id}.dkr.ecr.${data.aws_region.current.name}.amazonaws.com/foo:latest"
    model_data_url = "https://s3-us-east-1.amazonaws.com/${aws_s3_bucket.buckettostoremodel.bucket}/model.tar.gz"
  }

  tags {
    Name = "cqpocs"
  }
}

resource "aws_sagemaker_endpoint_configuration" "sgmakerconfig" {
  name = "terraform-sagemaker-config"

  production_variants {
    variant_name = "variant-1"
    model_name = "${aws_sagemaker_model.sgmmodel.name}"
    initial_instance_count  = 1
    instance_type = "ml.t2.medium"
    initial_variant_weight  = 1
  }

  tags {
    Name = "cqpocs"
  }
}

resource "aws_sagemaker_endpoint" "sgmakerendpoint1" {
  name = "terraform-sagemaker-endpoint1"
  endpoint_config_name = "${aws_sagemaker_endpoint_configuration.sgmakerconfig.name}"

  tags {
    Name = "cqpocs"
  }
}