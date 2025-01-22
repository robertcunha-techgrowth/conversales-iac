resource "aws_ecr_repository" "auth_efi" {
  name                 = "auth-efi"
  image_tag_mutability = "MUTABLE"
}

resource "aws_ecr_lifecycle_policy" "auth_efi_expiry_policy" {
  repository = aws_ecr_repository.auth_efi.name

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