provider "aws" {
  region  = "${var.region}"
  profile = "asuna"
}

resource "aws_key_pair" "user" {
  key_name   = "asuna-dev-ecs"
  public_key = "${file(var.ssh_pubkey_file)}"
}

resource "aws_vpc" "main" {
  cidr_block           = "10.0.0.0/16"
  enable_dns_hostnames = true
  enable_dns_support   = true
}

resource "aws_route53_zone" "main" {
  name   = "dev"
  vpc_id = "${aws_vpc.main.id}"
}

resource "aws_route_table" "external" {
  vpc_id = "${aws_vpc.main.id}"

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = "${aws_internet_gateway.main.id}"
  }
}

resource "aws_route_table_association" "external-main" {
  subnet_id      = "${aws_subnet.main.id}"
  route_table_id = "${aws_route_table.external.id}"
}

resource "aws_subnet" "main" {
  vpc_id            = "${aws_vpc.main.id}"
  cidr_block        = "10.0.1.0/24"
  availability_zone = "${var.availability_zone}"
}

resource "aws_subnet" "main_2" {
  vpc_id            = "${aws_vpc.main.id}"
  cidr_block        = "10.0.2.0/24"
  availability_zone = "${var.availability_zone_2}"
}

resource "aws_internet_gateway" "main" {
  vpc_id = "${aws_vpc.main.id}"
}

resource "aws_security_group" "ecs" {
  name        = "ecs"
  description = "Allows all traffic"
  vpc_id      = "${aws_vpc.main.id}"

  // Legends.AI
  ingress {
    from_port   = 7448
    to_port     = 7448
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  // Helios
  ingress {
    from_port   = 7921
    to_port     = 7921
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_ecs_cluster" "main" {
  name = "${var.ecs_cluster_name}"
}

resource "aws_instance" "ecs" {
  instance_type               = "m4.xlarge"
  ami                         = "${lookup(var.amis, var.region)}"
  key_name                    = "${aws_key_pair.user.key_name}"
  subnet_id                   = "${aws_subnet.main.id}"
  iam_instance_profile        = "${aws_iam_instance_profile.ecs.name}"
  vpc_security_group_ids      = ["${aws_security_group.ecs.id}"]
  ebs_optimized               = true
  associate_public_ip_address = true
  user_data                   = "#!/bin/bash\necho ECS_CLUSTER='${var.ecs_cluster_name}' > /etc/ecs/ecs.config"

  # TODO(igm): forces new resource
  # associate_public_ip_address = false
  tags {
    Name = "dev_ecs"
  }

  root_block_device {
    volume_type           = "gp2"
    volume_size           = "20"  # GB
    delete_on_termination = true
  }
}

resource "aws_eip" "ecs" {
  instance = "${aws_instance.cassandra_0.id}"
  vpc      = true
}

resource "aws_iam_role" "ecs_host_role" {
  name               = "ecs_host_role"
  assume_role_policy = "${file("policies/ecs-role.json")}"
}

resource "aws_iam_role_policy" "ecs_instance_role_policy" {
  name   = "ecs_instance_role_policy"
  policy = "${file("policies/ecs-instance-role-policy.json")}"
  role   = "${aws_iam_role.ecs_host_role.id}"
}

resource "aws_iam_role" "ecs_service_role" {
  name               = "ecs_service_role"
  assume_role_policy = "${file("policies/ecs-role.json")}"
}

resource "aws_iam_role_policy" "ecs_service_role_policy" {
  name   = "ecs_service_role_policy"
  policy = "${file("policies/ecs-service-role-policy.json")}"
  role   = "${aws_iam_role.ecs_service_role.id}"
}

resource "aws_iam_instance_profile" "ecs" {
  name  = "ecs-instance-profile"
  path  = "/"
  roles = ["${aws_iam_role.ecs_host_role.name}"]
}

resource "aws_cloudwatch_log_group" "asuna" {
  # TODO(igm): interpolate
  name = "asuna"
}
