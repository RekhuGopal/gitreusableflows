## create SSM document
resource "aws_ssm_document" "cqpocsssmdocument" {
  name          = "cqpocs_document"
  document_type = "Command"

  content = <<DOC
  {
    "schemaVersion": "1.2",
    "description": "To restart mysql service.",
    "parameters": {

    },
    "runtimeConfig": {
      "aws:runShellScript": {
        "properties": [
          {
            "id": "0.aws:runShellScript",
            "runCommand": ["sudo service mysql start"]
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
  schedule_expression = "cron(0 0 0 ? * * *)"
  targets {
    key    = "tag:run_ssm_document"
    values = ["yes"]
  }
}