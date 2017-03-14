variable "ecs_0_address" {
  default = "10.0.1.254"
}

// Alexandria
data "template_file" "alexandria" {
  template = "${file("task-definitions/alexandria.json")}"

  vars {
    ecs_0           = "${var.ecs_0_address}"
    cassandra_0     = "${aws_route53_record.cassandra_0.fqdn}"
    aurora_writer   = "aurora-dev.cluster-cfualisfu68a.us-east-1.rds.amazonaws.com"
    aurora_reader   = "aurora-dev-1.cfualisfu68a.us-east-1.rds.amazonaws.com"
    aurora_username = "${var.aurora_username}"
    aurora_password = "${var.aurora_password}"
  }
}

resource "aws_ecs_task_definition" "alexandria" {
  family                = "alexandria"
  container_definitions = "${data.template_file.alexandria.rendered}"
}

resource "aws_ecs_service" "alexandria" {
  name            = "alexandria"
  cluster         = "${aws_ecs_cluster.main.id}"
  task_definition = "${aws_ecs_task_definition.alexandria.arn}"
  desired_count   = 1

  placement_constraints {
    type       = "memberOf"
    expression = "attribute:type == general"
  }
}

// Charon
data "template_file" "charon" {
  template = "${file("task-definitions/charon.json")}"

  vars {
    ecs_0        = "${var.ecs_0_address}"
    riot_api_key = "${var.riot_api_key}"
  }
}

resource "aws_ecs_task_definition" "charon" {
  family                = "charon"
  container_definitions = "${data.template_file.charon.rendered}"
}

resource "aws_ecs_service" "charon" {
  name            = "charon"
  cluster         = "${aws_ecs_cluster.main.id}"
  task_definition = "${aws_ecs_task_definition.charon.arn}"
  desired_count   = 1

  placement_constraints {
    type       = "memberOf"
    expression = "attribute:type == general"
  }
}

// Helios
data "template_file" "helios" {
  template = "${file("task-definitions/helios.json")}"

  vars {
    ecs_0 = "${var.ecs_0_address}"
  }
}

resource "aws_ecs_task_definition" "helios" {
  family                = "helios"
  container_definitions = "${data.template_file.helios.rendered}"
}

resource "aws_ecs_service" "helios" {
  name            = "helios"
  cluster         = "${aws_ecs_cluster.main.id}"
  task_definition = "${aws_ecs_task_definition.helios.arn}"
  desired_count   = 1

  placement_constraints {
    type       = "memberOf"
    expression = "attribute:type == general"
  }
}

// Legends.ai
resource "aws_ecs_task_definition" "legends-ai" {
  family                = "legends-ai"
  container_definitions = "${file("task-definitions/legends-ai.json")}"
}

resource "aws_ecs_service" "legends-ai" {
  name            = "legends-ai"
  cluster         = "${aws_ecs_cluster.main.id}"
  task_definition = "${aws_ecs_task_definition.legends-ai.arn}"
  desired_count   = 0

  placement_constraints {
    type       = "memberOf"
    expression = "attribute:type == general"
  }
}

// Lucinda
data "template_file" "lucinda" {
  template = "${file("task-definitions/lucinda.json")}"

  vars {
    ecs_0 = "${var.ecs_0_address}"
  }
}

resource "aws_ecs_task_definition" "lucinda" {
  family                = "lucinda"
  container_definitions = "${data.template_file.lucinda.rendered}"
}

resource "aws_ecs_service" "lucinda" {
  name            = "lucinda"
  cluster         = "${aws_ecs_cluster.main.id}"
  task_definition = "${aws_ecs_task_definition.lucinda.arn}"
  desired_count   = 1

  placement_constraints {
    type       = "memberOf"
    expression = "attribute:type == general"
  }
}

// Luna
data "template_file" "luna" {
  template = "${file("task-definitions/luna.json")}"

  vars {
    ecs_0 = "${var.ecs_0_address}"
  }
}

resource "aws_ecs_task_definition" "luna" {
  family                = "luna"
  container_definitions = "${data.template_file.luna.rendered}"
}

resource "aws_ecs_service" "luna" {
  name            = "luna"
  cluster         = "${aws_ecs_cluster.main.id}"
  task_definition = "${aws_ecs_task_definition.luna.arn}"
  desired_count   = 1

  placement_constraints {
    type       = "memberOf"
    expression = "attribute:type == general"
  }
}

// Nova
data "template_file" "nova" {
  template = "${file("task-definitions/nova.json")}"

  vars {
    ecs_0 = "${var.ecs_0_address}"
  }
}

resource "aws_ecs_task_definition" "nova" {
  family                = "nova"
  container_definitions = "${data.template_file.nova.rendered}"
}

resource "aws_ecs_service" "nova" {
  name            = "nova"
  cluster         = "${aws_ecs_cluster.main.id}"
  task_definition = "${aws_ecs_task_definition.nova.arn}"
  desired_count   = 1

  placement_constraints {
    type       = "memberOf"
    expression = "attribute:type == general"
  }
}

// Nova Queue
resource "aws_ecs_task_definition" "nova-queue" {
  family                = "nova-queue"
  container_definitions = "${file("task-definitions/nova-queue.json")}"
}

resource "aws_ecs_service" "nova-queue" {
  name            = "nova-queue"
  cluster         = "${aws_ecs_cluster.main.id}"
  task_definition = "${aws_ecs_task_definition.nova-queue.arn}"
  desired_count   = 1

  placement_constraints {
    type       = "memberOf"
    expression = "attribute:type == general"
  }
}

// Vulgate
data "template_file" "vulgate" {
  template = "${file("task-definitions/vulgate.json")}"

  vars {
    ecs_0 = "${var.ecs_0_address}"
  }
}

resource "aws_ecs_task_definition" "vulgate" {
  family                = "vulgate"
  container_definitions = "${data.template_file.vulgate.rendered}"
}

resource "aws_ecs_service" "vulgate" {
  name            = "vulgate"
  cluster         = "${aws_ecs_cluster.main.id}"
  task_definition = "${aws_ecs_task_definition.vulgate.arn}"
  desired_count   = 1

  placement_constraints {
    type       = "memberOf"
    expression = "attribute:type == general"
  }
}
