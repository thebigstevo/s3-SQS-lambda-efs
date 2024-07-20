resource aws_instance "test_server" {
   ami = var.ami_id #Amazon Linux 2023 AMI 2023.5.20240708.0 x86_64 HVM kernel-6.1
   instance_type = var.instance_type

}


#create testserver
resource "aws_instance" "test_server" {
  ami                         = "ami-0b995c42184e99f98" #eu-west-1
  instance_type               = "t2.micro"
  associate_public_ip_address = true
  subnet_id                   = var.ec2_security_group_ids
  security_groups             = [aws_security_group.webserver_sg.id]
  # EBS Block Device Mapping
  root_block_device {
    volume_size = 16
    volume_type = "gp3"
  }
 
  #   user_data = <<EOF
  #   #!/bin/bash

  # # Update package information
  # sudo apt-get update

  # # Install Apache HTTP Server
  # sudo apt-get install apache2 -y

  # # Start Apache HTTP Server
  # sudo service apache2 start

  # # Create index.html file
  # echo "Hey, it's a me, WEB 1!" | sudo tee /var/www/html/index.html

  # EOF

}