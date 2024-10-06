
variable "aws_access_key" {}
variable "aws_secret_key" {}
variable "aws_session_token" {}
variable "private_key_path" {}
variable "key_name" {}

variable "region" {
  default = "us-east-1"
}

variable "availability_zone" {
  default = {
    zone_a = "us-east-1a"
    zone_b = "us-east-1b"
  }
}

variable "network_address_space" {
  default = "10.0.0.0/16"
}
variable "subnet1_address_space" {
  default = "10.0.1.0/24"
}
variable "subnet2_address_space" {
  default = "10.0.2.0/24"
}