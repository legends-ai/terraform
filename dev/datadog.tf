data "template_file" "datadog_role" {
  template = "${file("policies/datadog-role.json")}"

  vars {
    dd_external_id = "${var.dd_external_id}"
  }
}

resource "aws_iam_role" "datadog" {
  name               = "datadog_role"
  assume_role_policy = "${data.template_file.datadog_role.rendered}"
}

resource "aws_iam_role_policy" "datadog" {
  name   = "datadog_role_policy"
  policy = "${file("policies/datadog-role-policy.json")}"
  role   = "${aws_iam_role.datadog.id}"
}

data "template_file" "dd-agent_task_definition" {
  template = "${file("task-definitions/dd-agent.json")}"

  vars {
    dd_api_key = "${var.dd_api_key}"
  }
}

resource "aws_ecs_task_definition" "dd-agent" {
  family                = "dd-agent"
  container_definitions = "${data.template_file.dd-agent_task_definition.rendered}"

  volume {
    name      = "docker_sock"
    host_path = "/var/run/docker.sock"
  }

  volume {
    name      = "proc"
    host_path = "/proc/"
  }

  volume {
    name      = "cgroup"
    host_path = "/cgroup/"
  }
}

resource "aws_ecs_service" "dd-agent" {
  name            = "dd-agent"
  cluster         = "${aws_ecs_cluster.main.id}"
  task_definition = "${aws_ecs_task_definition.dd-agent.arn}"
  desired_count   = 2

  placement_constraints {
    type = "distinctInstance"
  }
}
