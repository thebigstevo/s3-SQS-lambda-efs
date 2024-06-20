resource "aws_lambda_function" "s3tolambdatoefs" {
  function_name = "s3_to_lambda_to_efs"
  handler       = "lambda_function.lambda_handler"
  role          = aws_iam_role.lambda_role.arn
  runtime = "python3.11"
  filename = "s3_to_lambda_to_efs.zip"
  source_code_hash = filebase64sha256("s3_to_lambda_to_efs.zip")
  vpc_config {
    vpc_id = data.aws_vpc.vpc.id
    subnet_ids = data.aws_subnet_ids.subnets.ids
    security_group_ids = [ aws_security_group.efs_sg ]
  }
  environment {
    variables = {
      aws_efs_access_point= aws_efs_access_point.efs_ap.id
    }
  }
  file_system_config {
    arn = aws_efs_access_point.efs_ap.arn
    local_mount_path = "/mnt/efs"
    
  }
}
