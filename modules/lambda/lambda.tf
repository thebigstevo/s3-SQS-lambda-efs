# Lambda function
resource "aws_lambda_function" "s3tolambdatoefs" {
  function_name = "s3_to_lambda_to_efs"
  handler       = "s3_to_lambda_to_efs.lambda_handler"
  role          = aws_iam_role.lambda_role.arn
  runtime       = "python3.9"
  filename      = "s3_to_lambda_to_efs.zip"
  timeout       = "120"
  memory_size   = "128"

  source_code_hash = "s3_to_lambda_to_efs"
  vpc_config {
    security_group_ids = [var.lambda_security_group_ids]
    subnet_ids         = [
      var.public_subnet_1_id,
      var.public_subnet_2_id,
      var.public_subnet_3_id
    ]
  }

  environment {
    variables = {
      aws_efs_access_point = var.lambda_security_group_ids
    }
  }

  file_system_config {
    arn              = var.efs_access_point_arn
    local_mount_path = "/mnt/efs"
  }
}


# Lambda permissions for S3
resource "aws_lambda_permission" "with_s3" {
  statement_id  = "s3invokelambda"
  action        = "lambda:InvokeFunction"
  function_name = aws_lambda_function.s3tolambdatoefs.function_name
  principal     = "s3.amazonaws.com"
  source_arn    = aws_s3_bucket.receiving_bucket.arn
}