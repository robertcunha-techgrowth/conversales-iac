resource "aws_lambda_function" "timeout_notifier" {
  depends_on = [aws_ecr_repository.timeout_notifier]

  function_name = "timeout-notifier"
  image_uri     = "${aws_ecr_repository.timeout_notifier.repository_url}:latest"
  package_type  = "Image"
  role          = aws_iam_role.timeout_notifier_role.arn
  timeout       = var.lambda_timeout
  vpc_config {
    subnet_ids         = [var.subnet_a_id, var.subnet_b_id, var.subnet_c_id]
    security_group_ids = [var.security_group_id]
  }
}

resource "aws_cloudwatch_log_group" "lambda_log_group_timeout_notifier" {
  name              = "/aws/lambda/${aws_lambda_function.timeout_notifier.function_name}"
  retention_in_days = 14
}


resource "aws_cloudwatch_event_rule" "timeout_notifier_schedule" {
  name                = "timeout-notifier-schedule"
  schedule_expression = var.schedule_expression
}

resource "aws_lambda_permission" "timeout_notifier_cloudwatch" {
  statement_id  = "AllowCloudWatchToInvoke"
  action        = "lambda:InvokeFunction"
  function_name = aws_lambda_function.timeout_notifier.function_name
  principal     = "events.amazonaws.com"
  source_arn    = aws_cloudwatch_event_rule.timeout_notifier_schedule.arn
}

resource "aws_cloudwatch_event_target" "timeout_notifier_target" {
  depends_on = [aws_lambda_permission.timeout_notifier_cloudwatch]

  rule      = aws_cloudwatch_event_rule.timeout_notifier_schedule.name
  # target_id = "auth-efi-target"
  arn       = aws_lambda_function.timeout_notifier.arn
}