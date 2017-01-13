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

// Alexandria
resource "aws_ecr_repository" "alexandria" {
  name = "alexandria"
}

resource "aws_ecs_task_definition" "alexandria" {
  family = "alexandria"
  container_definitions = "${file("task-definitions/alexandria.json")}"

  volume {
    name = "alexandria-storage"
    host_path = "/ecs/alexandria-storage"
  }
}

resource "aws_ecs_service" "alexandria" {
  name = "alexandria"
  cluster = "${aws_ecs_cluster.asuna.id}"
  task_definition = "${aws_ecs_task_definition.alexandria.arn}"
  desired_count = 1
}
