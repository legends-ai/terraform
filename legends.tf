variable "aws_region" {
  default = "us-east-1"
}

provider "aws" {
  region     = "${var.aws_region}"
  profile    = "asuna"
}

resource "aws_instance" "never_let_it_die" {
  ami = "ami-0d729a60"
  instance_type = "t2.micro"
}
