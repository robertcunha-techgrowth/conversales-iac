resource "aws_lambda_function" "auth_efi" {
  depends_on = [aws_ecr_repository.auth_efi]

  function_name = "auth-efi"
  image_uri     = "${aws_ecr_repository.auth_efi.repository_url}:latest"
  package_type  = "Image"
  role          = aws_iam_role.auth_efi_role.arn
  timeout       = var.lambda_timeout
  vpc_config {
    subnet_ids         = [var.subnet_a_id, var.subnet_b_id, var.subnet_c_id]
    security_group_ids = [var.security_group_id]
  }
}

resource "aws_cloudwatch_log_group" "lambda_log_group_auth_efi" {
  name              = "/aws/lambda/${aws_lambda_function.auth_efi.function_name}"
  retention_in_days = 14
}

resource "aws_cloudwatch_event_rule" "auth_efi_schedule" {
  name                = "auth-efi-schedule"
  schedule_expression = var.auth_efi_schedule
}

resource "aws_lambda_permission" "auth_efi_cloudwatch" {
  statement_id  = "AllowCloudWatchToInvoke"
  action        = "lambda:InvokeFunction"
  function_name = aws_lambda_function.auth_efi.function_name
  principal     = "events.amazonaws.com"
  source_arn    = aws_cloudwatch_event_rule.auth_efi_schedule.arn
}

resource "aws_cloudwatch_event_target" "auth_efi_target" {
  depends_on = [aws_lambda_permission.auth_efi_cloudwatch]

  rule      = aws_cloudwatch_event_rule.auth_efi_schedule.name
  # target_id = "auth-efi-target"
  arn       = aws_lambda_function.auth_efi.arn
}
