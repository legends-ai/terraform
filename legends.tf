variable "access_key" {}
variable "secret_key" {}
variable "region" {
  default = "us-east-1"
}

provider "aws" {
  access_key = "${var.access_key}"
  secret_key = "${var.secret_key}"
  region     = "${var.region}"
}

resource "aws_instance" "never_let_it_die" {
  ami = "ami-0d729a60"
  instance_type = "t2.micro"
}
