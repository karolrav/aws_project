provider "aws" {
  access_key = "${var.access_key}"
  secret_key = "${var.aws_secret_key}"
  region = "${var.region}" 
}