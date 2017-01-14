variable "region" {
  description = "The AWS region."
  default = "us-east-1"
}

variable "availability_zone" {
  description = "The availability zone"
  default = "us-east-1a"
}

variable "ecs_cluster_name" {
  description = "The name of the Amazon ECS cluster."
  default = "dev-cassandra"
}

variable "amis" {
  description = "Which AMI to spawn. Defaults to the AWS ECS optimized images."
  # TODO: support other regions.
  default = {
    us-east-1 = "ami-a58760b3"
  }
}

variable "autoscale_min" {
  default = "1"
  description = "Minimum autoscale (number of EC2)"
}

variable "autoscale_max" {
  default = "1"
  description = "Maximum autoscale (number of EC2)"
}

variable "autoscale_desired" {
  default = "1"
  description = "Desired autoscale (number of EC2)"
}


variable "instance_type" {
  default = "m4.large"
}

variable "ssh_pubkey_file" {
  description = "Path to an SSH public key"
  default = "~/.ssh/id_rsa.pub"
}
