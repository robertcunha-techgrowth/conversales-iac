resource "aws_iam_role" "auth_efi_role" {
  name = "auth-efi-role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [{
      Effect = "Allow"
      Principal = {
        Service = "lambda.amazonaws.com"
      }
      Action = "sts:AssumeRole"
    }]
  })
}

resource "aws_iam_policy" "auth_efi_policy" {
  name        = "lambda-auth-efi-policy"
  description = "Allow lambda to create log groups and streams"
  
  policy = jsonencode({
    Version = "2012-10-17",
    Statement = [{
      Action = [
        "logs:CreateLogGroup",
        "logs:CreateLogStream",
        "logs:PutLogEvents",
      ],
      Effect   = "Allow",
      Resource = "arn:aws:logs:*:*:log-group:/aws/lambda/*"
    }, {
        Action = [
          "secretsmanager:CreateSecret",
          "secretsmanager:PutSecretValue",
          "secretsmanager:UpdateSecret",
          "secretsmanager:DescribeSecret",
          "secretsmanager:DeleteSecret"
        ],
        Effect   = "Allow",
        Resource = "arn:aws:secretsmanager:*:*:secret:*"
      }, 
      {
      Action = [
        "ec2:CreateNetworkInterface",
        "ec2:DescribeNetworkInterfaces",
        "ec2:DeleteNetworkInterface"
      ],
      Effect   = "Allow",
      Resource = "*"
    }]
  })
}

resource "aws_iam_role_policy_attachment" "auth_efi_policy_attachment" {
  policy_arn = aws_iam_policy.auth_efi_policy.arn
  role       = aws_iam_role.auth_efi_role.name
}
