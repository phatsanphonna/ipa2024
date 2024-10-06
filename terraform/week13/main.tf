##################################################################################
# DATA
##################################################################################

data "aws_ami" "aws-linux" {
  most_recent = true
  owners      = ["amazon"]

  filter {
    name   = "name"
    values = ["al2023-ami-2023.*-x86_64"]
  }

  filter {
    name   = "root-device-type"
    values = ["ebs"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }
}

##################################################################################
# OUTPUT
##################################################################################

output "aws_instance_public_ip_server1" {
  value = aws_instance.Server1.public_ip
}

output "aws_instance_public_ip_server2" {
  value = aws_instance.Server2.public_ip
}
