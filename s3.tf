# S3 bucket
resource "aws_s3_bucket" "receiving_bucket" {
  bucket        = "sle24-bucket"
  force_destroy = true
}

# S3 bucket notification
resource "aws_s3_bucket_notification" "s3toltoefs_notification" {
  bucket = aws_s3_bucket.receiving_bucket.id
  lambda_function {
    lambda_function_arn = aws_lambda_function.s3tolambdatoefs.arn
    events              = ["s3:ObjectCreated:*"]
  }
}