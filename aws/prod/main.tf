provider "aws" {
  region  = "${var.region}"
  profile = "asuna"
}

resource "aws_key_pair" "user" {
  key_name   = "asuna-prod-ecs"
  public_key = "${file(var.ssh_pubkey_file)}"
}

resource "aws_vpc" "main" {
  cidr_block           = "10.0.0.0/16"
  enable_dns_hostnames = true
  enable_dns_support   = true
}

resource "aws_route53_zone" "main" {
  name   = "prod"
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
