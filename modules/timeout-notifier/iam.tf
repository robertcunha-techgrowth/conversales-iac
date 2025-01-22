resource "aws_iam_role" "timeout_notifier_role" {
  name = "timeout-notifier-role"

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

resource "aws_iam_policy" "timeout_notifier_policy" {
  name        = "timeout-notifier-policy"
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

resource "aws_iam_role_policy_attachment" "timeout_notifier_policy_attachment" {
  policy_arn = aws_iam_policy.timeout_notifier_policy.arn
  role       = aws_iam_role.timeout_notifier_role.name
}
