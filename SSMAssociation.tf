## create SSM document
resource "aws_ssm_document" "cqpocsssmdocument" {
  name          = "cqpocs_document"
  document_type = "Command"

  content = <<DOC
  {
    "schemaVersion": "1.2",
    "description": "Check ip configuration of a Linux instance.",
    "parameters": {

    },
    "runtimeConfig": {
      "aws:runShellScript": {
        "properties": [
          {
            "id": "0.aws:runShellScript",
            "runCommand": ["ifconfig"]
          }
        ]
      }
    }
  }
DOC
}

## Create SSM Association
resource "aws_ssm_association" "cqpocsssmassociation" {
  name = aws_ssm_document.cqpocsssmdocument.name

  targets {
    key    = "tag:run_ssm_document"
    values = ["yes"]
  }
}