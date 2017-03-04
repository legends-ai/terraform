variable "riot_api_key" {
  description = "The Riot API key."
}

variable "region" {
  description = "The AWS region."
  default     = "us-east-1"
}

variable "availability_zone" {
  description = "The availability zone"
  default     = "us-east-1a"
}

variable "availability_zone_2" {
  description = "The other availability zone"
  default     = "us-east-1b"
}

variable "ecs_cluster_name" {
  description = "The name of the Amazon ECS cluster."
  default     = "prod"
}

variable "amis" {
  description = "Which AMI to spawn. Defaults to the AWS ECS optimized images."

  # TODO: support other regions.
  default = {
    us-east-1 = "ami-d69c74c0"
  }
}

variable "asunaio_ssl_certificate_arn" {
  description = "The ssl certificate ARN for asuna.io, *.asuna.io, *.dev.asuna.io"
}

variable "autoscale_min" {
  default     = "1"
  description = "Minimum autoscale (number of EC2)"
}

variable "autoscale_max" {
  default     = "1"
  description = "Maximum autoscale (number of EC2)"
}

variable "autoscale_desired" {
  default     = "1"
  description = "Desired autoscale (number of EC2)"
}

variable "cassandra_amis" {
  description = "Which AMI to spawn. Defaults to the Bitnami HVM image."

  # TODO: support other regions.
  default = {
    us-east-1 = "ami-17326800"
  }
}

variable "ecs_instance_type" {
  default = "r4.xlarge"
}

variable "ssh_pubkey_file" {
  description = "Path to an SSH public key"
  default     = "~/asuna-dev.pub"
}

variable "ssh_privkey_file" {
  description = "Path to an SSH private key"
  default     = "~/asuna-dev.pem"
}

variable "bastion_amis" {
  description = "Which AMI to spawn. Defaults to the AWS Linux images."

  default = {
    us-east-1 = "ami-9be6f38c"
  }
}

variable "bastion_instance_type" {
  default = "t2.nano"
}

variable "allowed_cidr_blocks" {
  default = "0.0.0.0/0"
}

variable "internal_cidr_blocks" {
  default = "0.0.0.0/0"
}

variable "cloudflare_email" {}

variable "cloudflare_token" {}

variable "dd_api_key" {}

variable "dd_external_id" {}
