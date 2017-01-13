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

// Consul for service discovery
module "consul" {
  source = "github.com/hashicorp/consul/terraform/aws"

  instance_type = "t2.micro"  // ayylmao this is dev
  key_name = "asunachan"
  key_path = "~/asuna.pem"
  region = "${var.aws_region}"
  servers = "1"
}
