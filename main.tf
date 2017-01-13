variable "riot_api_key" {}

variable "aws_region" {
  default = "us-east-1"
}

provider "aws" {
  region = "${var.aws_region}"
  profile = "asuna"
}

resource "aws_ecs_cluster" "asuna" {
  name = "asuna"
}
