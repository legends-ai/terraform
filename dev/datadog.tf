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
  desired_count   = 1
}
