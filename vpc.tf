#EFS security group
resource "aws_security_group" "efs_sg" {
  name_prefix = "efs_sg"
  vpc_id      = data.aws_vpc.myvpc.id

  ingress {
    from_port   = 2049
    to_port     = 2049
    protocol    = "tcp"
    cidr_blocks = [data.aws_vpc.myvpc.cidr_block]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}