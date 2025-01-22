resource "aws_ecr_repository" "timeout_notifier" {
  name                 = "timeout-notifier"
  image_tag_mutability = "MUTABLE"
}

resource "aws_ecr_lifecycle_policy" "timeout_notifier_expiry_policy" {
  repository = aws_ecr_repository.timeout_notifier.name

  policy = <<EOF
{
    "rules": [
        {
            "rulePriority": 1,
            "description": "Expire images untagged",
            "selection": {
                "tagStatus": "untagged",
                "countType": "sinceImagePushed",
                "countUnit": "days",
                "countNumber": 1
            },
            "action": {
                "type": "expire"
            }
        }
    ]
}
EOF
}