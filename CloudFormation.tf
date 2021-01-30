## Create AWS VPC using Cloud Formation called in Terraform
resource "aws_cloudformation_stack" "cqpocsnetwork" {
  name = "vpc-stack-1"

  parameters = {
    VPCCidr = "172.16.0.0/16"
  }

  template_body = <<STACK
{
  "Parameters" : {
    "VPCCidr" : {
      "Type" : "String",
      "Default" : "10.0.0.0/16",
      "Description" : "Enter the CIDR block for the VPC. Default is 10.0.0.0/16."
    }
  },
  "Resources" : {
    "myVpc": {
      "Type" : "AWS::EC2::VPC",
      "Properties" : {
        "CidrBlock" : { "Ref" : "VPCCidr" },
        "Tags" : [
          {"Key": "Name", "Value": "CloudQuickPOC_VPC"}
        ]
      }
    }
  }
}
STACK
}