// Alexandria
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
  cluster = "${aws_ecs_cluster.main.id}"
  task_definition = "${aws_ecs_task_definition.alexandria.arn}"
  desired_count = 1
}

// Charon
data "template_file" "charon_task_definition" {
  template = "${file("task-definitions/charon.json")}"
  vars {
    riot_api_key = "${var.riot_api_key}"
  }
}

resource "aws_ecs_task_definition" "charon" {
  family = "charon"
  container_definitions = "${data.template_file.charon_task_definition.rendered}"
}

resource "aws_ecs_service" "charon" {
  name = "charon"
  cluster = "${aws_ecs_cluster.main.id}"
  task_definition = "${aws_ecs_task_definition.charon.arn}"
  desired_count = 1
}

// Helios
resource "aws_ecs_task_definition" "helios" {
  family = "helios"
  container_definitions = "${file("task-definitions/helios.json")}"
}

resource "aws_ecs_service" "helios" {
  name = "helios"
  cluster = "${aws_ecs_cluster.main.id}"
  task_definition = "${aws_ecs_task_definition.helios.arn}"
  desired_count = 1
  iam_role = "${aws_iam_role.ecs_service_role.arn}"
  depends_on = ["aws_iam_role_policy.ecs_service_role_policy"]

  load_balancer {
    elb_name = "${aws_elb.helios.id}"
    container_name = "helios"
    container_port = 7921
  }
}

resource "aws_elb" "helios" {
  name = "helios-elb"
  subnets = ["${aws_subnet.main.id}"]

  listener {
    instance_port = 7921
    instance_protocol = "http"
    lb_port = 443
    lb_protocol = "https"
    ssl_certificate_id = "${var.asunaio_ssl_certificate_arn}"
  }

  health_check {
    healthy_threshold = 2
    unhealthy_threshold = 2
    timeout = 3
    target = "HTTPS:7922/health"
    interval = 30
  }

  # TODO instances = ["${aws_instance.id}"]
  idle_timeout = 60
  connection_draining = true
  connection_draining_timeout = 300

  tags {
    Name = "helios-elb"
  }
}

// Legends.ai
resource "aws_ecs_task_definition" "legends-ai" {
  family = "legends-ai"
  container_definitions = "${file("task-definitions/legends-ai.json")}"
}

resource "aws_ecs_service" "legends-ai" {
  name = "legends-ai"
  cluster = "${aws_ecs_cluster.main.id}"
  task_definition = "${aws_ecs_task_definition.legends-ai.arn}"
  desired_count = 1
}

// Lucinda
resource "aws_ecs_task_definition" "lucinda" {
  family = "lucinda"
  container_definitions = "${file("task-definitions/lucinda.json")}"
}

resource "aws_ecs_service" "lucinda" {
  name = "lucinda"
  cluster = "${aws_ecs_cluster.main.id}"
  task_definition = "${aws_ecs_task_definition.lucinda.arn}"
  desired_count = 1
}

// Luna
resource "aws_ecs_task_definition" "luna" {
  family = "luna"
  container_definitions = "${file("task-definitions/luna.json")}"
}

resource "aws_ecs_service" "luna" {
  name = "luna"
  cluster = "${aws_ecs_cluster.main.id}"
  task_definition = "${aws_ecs_task_definition.luna.arn}"
  desired_count = 1
}

// Nova
resource "aws_ecs_task_definition" "nova" {
  family = "nova"
  container_definitions = "${file("task-definitions/nova.json")}"
}

resource "aws_ecs_service" "nova" {
  name = "nova"
  cluster = "${aws_ecs_cluster.main.id}"
  task_definition = "${aws_ecs_task_definition.nova.arn}"
  desired_count = 1
}

// Vulgate
resource "aws_ecs_task_definition" "vulgate" {
  family = "vulgate"
  container_definitions = "${file("task-definitions/vulgate.json")}"
}

resource "aws_ecs_service" "vulgate" {
  name = "vulgate"
  cluster = "${aws_ecs_cluster.main.id}"
  task_definition = "${aws_ecs_task_definition.vulgate.arn}"
  desired_count = 1
  iam_role = "${aws_iam_role.ecs_service_role.arn}"
  depends_on = ["aws_iam_role_policy.ecs_service_role_policy"]

  load_balancer {
    elb_name = "${aws_elb.vulgate.id}"
    container_name = "vulgate"
    container_port = 6205
  }
}

resource "aws_elb" "vulgate" {
  name = "vulgate-elb"
  subnets = ["${aws_subnet.main.id}"]

  listener {
    lb_protocol = "http"
    lb_port = 6205

    instance_protocol = "http"
    instance_port = 6205
  }

  idle_timeout = 60
  connection_draining = true
  connection_draining_timeout = 300

  tags {
    Name = "vulgate-elb"
  }
}