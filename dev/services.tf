// Alexandria
resource "aws_ecs_task_definition" "alexandria" {
  family                = "alexandria"
  container_definitions = "${file("task-definitions/alexandria.json")}"

  volume {
    name      = "alexandria-storage"
    host_path = "/ecs/alexandria-storage"
  }
}

resource "aws_ecs_service" "alexandria" {
  name            = "alexandria"
  cluster         = "${aws_ecs_cluster.main.id}"
  task_definition = "${aws_ecs_task_definition.alexandria.arn}"
  desired_count   = 1
  iam_role        = "${aws_iam_role.ecs_service_role.arn}"

  depends_on = [
    "aws_iam_role_policy.ecs_service_role_policy",
    "aws_alb_listener.alexandria",
  ]

  load_balancer {
    container_name   = "alexandria"
    container_port   = 22045
    target_group_arn = "${aws_alb.alexandria.arn}"
  }
}

resource "aws_route53_record" "alexandria" {
  zone_id = "${aws_route53_zone.main.zone_id}"
  name    = "alexandria.${aws_route53_zone.main.name}"
  type    = "A"

  alias = {
    name                   = "${aws_alb.alexandria.dns_name}"
    zone_id                = "${aws_alb.alexandria.zone_id}"
    evaluate_target_health = false
  }
}

resource "aws_alb" "alexandria" {
  name         = "alexandria-alb"
  internal     = true
  idle_timeout = 60

  security_groups = [
    "${aws_security_group.ecs.id}",
  ]

  subnets = [
    "${aws_subnet.main.id}",
    "${aws_subnet.main_2.id}",
  ]

  tags {
    name = "alexandria-alb"
  }
}

resource "aws_alb_target_group" "alexandria" {
  name     = "alexandria-alb-tg"
  port     = 22045
  protocol = "HTTP"
  vpc_id   = "${aws_vpc.main.id}"
}

resource "aws_alb_listener" "alexandria" {
  load_balancer_arn = "${aws_alb.alexandria.arn}"
  port              = 22045
  protocol          = "HTTP"

  default_action {
    target_group_arn = "${aws_alb_target_group.alexandria.arn}"
    type             = "forward"
  }
}

// Charon
data "template_file" "charon_task_definition" {
  template = "${file("task-definitions/charon.json")}"

  vars {
    riot_api_key = "${var.riot_api_key}"
  }
}

resource "aws_ecs_task_definition" "charon" {
  family                = "charon"
  container_definitions = "${data.template_file.charon_task_definition.rendered}"
}

resource "aws_ecs_service" "charon" {
  name            = "charon"
  cluster         = "${aws_ecs_cluster.main.id}"
  task_definition = "${aws_ecs_task_definition.charon.arn}"
  desired_count   = 1
  iam_role        = "${aws_iam_role.ecs_service_role.arn}"

  depends_on = [
    "aws_iam_role_policy.ecs_service_role_policy",
    "aws_alb_listener.charon",
  ]

  load_balancer {
    container_name   = "charon"
    container_port   = 5609
    target_group_arn = "${aws_alb.charon.arn}"
  }
}

resource "aws_route53_record" "charon" {
  zone_id = "${aws_route53_zone.main.zone_id}"
  name    = "charon.${aws_route53_zone.main.name}"
  type    = "A"

  alias = {
    name                   = "${aws_alb.charon.dns_name}"
    zone_id                = "${aws_alb.charon.zone_id}"
    evaluate_target_health = false
  }
}

resource "aws_alb" "charon" {
  name         = "charon-alb"
  internal     = true
  idle_timeout = 60

  security_groups = [
    "${aws_security_group.ecs.id}",
  ]

  subnets = [
    "${aws_subnet.main.id}",
    "${aws_subnet.main_2.id}",
  ]

  tags {
    name = "charon-alb"
  }
}

resource "aws_alb_target_group" "charon" {
  name     = "charon-alb-tg"
  port     = 5609
  protocol = "HTTP"
  vpc_id   = "${aws_vpc.main.id}"
}

resource "aws_alb_listener" "charon" {
  load_balancer_arn = "${aws_alb.charon.arn}"
  port              = 5609
  protocol          = "HTTP"

  default_action {
    target_group_arn = "${aws_alb_target_group.charon.arn}"
    type             = "forward"
  }
}

// Helios
resource "aws_ecs_task_definition" "helios" {
  family                = "helios"
  container_definitions = "${file("task-definitions/helios.json")}"
}

resource "aws_ecs_service" "helios" {
  name            = "helios"
  cluster         = "${aws_ecs_cluster.main.id}"
  task_definition = "${aws_ecs_task_definition.helios.arn}"
  desired_count   = 1
  iam_role        = "${aws_iam_role.ecs_service_role.arn}"

  depends_on = [
    "aws_iam_role_policy.ecs_service_role_policy",
    "aws_alb_listener.helios",
  ]

  load_balancer {
    container_name   = "helios"
    container_port   = 7921
    target_group_arn = "${aws_alb.helios.arn}"
  }
}

resource "aws_alb" "helios" {
  name         = "helios-alb"
  internal     = true
  idle_timeout = 60

  security_groups = [
    "${aws_security_group.ecs.id}",
  ]

  subnets = [
    "${aws_subnet.main.id}",
    "${aws_subnet.main_2.id}",
  ]

  tags {
    name = "helios-alb"
  }
}

resource "aws_alb_target_group" "helios" {
  name     = "helios-alb-tg"
  port     = 7921
  protocol = "HTTP"
  vpc_id   = "${aws_vpc.main.id}"

  health_check {
    interval            = 30
    path                = "/health"
    port                = 7922
    healthy_threshold   = 5
    unhealthy_threshold = 2
    timeout             = 5
    matcher             = 200
  }
}

resource "aws_alb_listener" "helios" {
  load_balancer_arn = "${aws_alb.helios.arn}"
  port              = 443
  protocol          = "HTTPS"
  ssl_policy        = "ELBSecurityPolicy-2015-05"
  certificate_arn   = "${var.asunaio_ssl_certificate_arn}"

  default_action {
    target_group_arn = "${aws_alb_target_group.helios.arn}"
    type             = "forward"
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
  desired_count   = 1
  iam_role        = "${aws_iam_role.ecs_service_role.arn}"

  depends_on = [
    "aws_iam_role_policy.ecs_service_role_policy",
    "aws_alb_listener.legends-ai",
  ]

  load_balancer {
    container_name   = "legends-ai"
    container_port   = 7448
    target_group_arn = "${aws_alb.legends-ai.arn}"
  }
}

resource "aws_alb" "legends-ai" {
  name         = "legends-ai-alb"
  internal     = true
  idle_timeout = 60

  security_groups = [
    "${aws_security_group.ecs.id}",
  ]

  subnets = [
    "${aws_subnet.main.id}",
    "${aws_subnet.main_2.id}",
  ]

  security_groups = [
    "${aws_security_group.ecs.id}",
  ]

  tags {
    Name = "legends-ai-alb"
  }
}

resource "aws_alb_target_group" "legends-ai" {
  name     = "legends-ai-alb-tg"
  port     = 7448
  protocol = "HTTP"
  vpc_id   = "${aws_vpc.main.id}"
}

resource "aws_alb_listener" "legends-ai" {
  load_balancer_arn = "${aws_alb.legends-ai.arn}"
  port              = 443
  protocol          = "HTTPS"
  ssl_policy        = "ELBSecurityPolicy-2015-05"
  certificate_arn   = "${var.asunaio_ssl_certificate_arn}"

  default_action {
    target_group_arn = "${aws_alb_target_group.legends-ai.arn}"
    type             = "forward"
  }
}

// Lucinda
resource "aws_ecs_task_definition" "lucinda" {
  family                = "lucinda"
  container_definitions = "${file("task-definitions/lucinda.json")}"
}

resource "aws_ecs_service" "lucinda" {
  name            = "lucinda"
  cluster         = "${aws_ecs_cluster.main.id}"
  task_definition = "${aws_ecs_task_definition.lucinda.arn}"
  desired_count   = 1
  iam_role        = "${aws_iam_role.ecs_service_role.arn}"

  depends_on = [
    "aws_iam_role_policy.ecs_service_role_policy",
    "aws_alb_listener.lucinda",
  ]

  load_balancer {
    container_name   = "lucinda"
    container_port   = 45045
    target_group_arn = "${aws_alb.lucinda.arn}"
  }
}

resource "aws_route53_record" "lucinda" {
  zone_id = "${aws_route53_zone.main.zone_id}"
  name    = "lucinda.${aws_route53_zone.main.name}"
  type    = "A"

  alias = {
    name                   = "${aws_alb.lucinda.dns_name}"
    zone_id                = "${aws_alb.lucinda.zone_id}"
    evaluate_target_health = false
  }
}

resource "aws_alb" "lucinda" {
  name         = "lucinda-alb"
  internal     = true
  idle_timeout = 60

  security_groups = [
    "${aws_security_group.ecs.id}",
  ]

  subnets = [
    "${aws_subnet.main.id}",
    "${aws_subnet.main_2.id}",
  ]

  tags {
    name = "lucinda-alb"
  }
}

resource "aws_alb_target_group" "lucinda" {
  name     = "lucinda-alb-tg"
  port     = 45045
  protocol = "HTTP"
  vpc_id   = "${aws_vpc.main.id}"
}

resource "aws_alb_listener" "lucinda" {
  load_balancer_arn = "${aws_alb.lucinda.arn}"
  port              = 45045
  protocol          = "HTTP"

  default_action {
    target_group_arn = "${aws_alb_target_group.lucinda.arn}"
    type             = "forward"
  }
}

// Luna
resource "aws_ecs_task_definition" "luna" {
  family                = "luna"
  container_definitions = "${file("task-definitions/luna.json")}"
}

resource "aws_ecs_service" "luna" {
  name            = "luna"
  cluster         = "${aws_ecs_cluster.main.id}"
  task_definition = "${aws_ecs_task_definition.luna.arn}"
  desired_count   = 1
  iam_role        = "${aws_iam_role.ecs_service_role.arn}"

  depends_on = [
    "aws_iam_role_policy.ecs_service_role_policy",
    "aws_alb_listener.luna",
  ]

  load_balancer {
    container_name   = "luna"
    container_port   = 2389
    target_group_arn = "${aws_alb.luna.arn}"
  }
}

resource "aws_route53_record" "luna" {
  zone_id = "${aws_route53_zone.main.zone_id}"
  name    = "luna.${aws_route53_zone.main.name}"
  type    = "A"

  alias = {
    name                   = "${aws_alb.luna.dns_name}"
    zone_id                = "${aws_alb.luna.zone_id}"
    evaluate_target_health = false
  }
}

resource "aws_alb" "luna" {
  name         = "luna-alb"
  internal     = true
  idle_timeout = 60

  security_groups = [
    "${aws_security_group.ecs.id}",
  ]

  subnets = [
    "${aws_subnet.main.id}",
    "${aws_subnet.main_2.id}",
  ]

  tags {
    name = "luna-alb"
  }
}

resource "aws_alb_target_group" "luna" {
  name     = "luna-alb-tg"
  port     = 2389
  protocol = "HTTP"
  vpc_id   = "${aws_vpc.main.id}"
}

resource "aws_alb_listener" "luna" {
  load_balancer_arn = "${aws_alb.luna.arn}"
  port              = 2389
  protocol          = "HTTP"

  default_action {
    target_group_arn = "${aws_alb_target_group.luna.arn}"
    type             = "forward"
  }
}

// Nova
resource "aws_ecs_task_definition" "nova" {
  family                = "nova"
  container_definitions = "${file("task-definitions/nova.json")}"
}

resource "aws_ecs_service" "nova" {
  name            = "nova"
  cluster         = "${aws_ecs_cluster.main.id}"
  task_definition = "${aws_ecs_task_definition.nova.arn}"
  desired_count   = 1
}

// Vulgate
resource "aws_ecs_task_definition" "vulgate" {
  family                = "vulgate"
  container_definitions = "${file("task-definitions/vulgate.json")}"
}

resource "aws_ecs_service" "vulgate" {
  name            = "vulgate"
  cluster         = "${aws_ecs_cluster.main.id}"
  task_definition = "${aws_ecs_task_definition.vulgate.arn}"
  desired_count   = 1
  iam_role        = "${aws_iam_role.ecs_service_role.arn}"

  depends_on = [
    "aws_iam_role_policy.ecs_service_role_policy",
    "aws_alb_listener.vulgate",
  ]

  load_balancer {
    container_name   = "vulgate"
    container_port   = 6205
    target_group_arn = "${aws_alb.vulgate.arn}"
  }
}

resource "aws_route53_record" "vulgate" {
  zone_id = "${aws_route53_zone.main.zone_id}"
  name    = "vulgate.${aws_route53_zone.main.name}"
  type    = "A"

  alias = {
    name                   = "${aws_alb.vulgate.dns_name}"
    zone_id                = "${aws_alb.vulgate.zone_id}"
    evaluate_target_health = false
  }
}

resource "aws_alb" "vulgate" {
  name         = "vulgate-alb"
  internal     = true
  idle_timeout = 60

  security_groups = [
    "${aws_security_group.load_balancers.id}",
  ]

  subnets = [
    "${aws_subnet.main.id}",
    "${aws_subnet.main_2.id}",
  ]

  tags {
    name = "vulgate-alb"
  }
}

resource "aws_alb_target_group" "vulgate" {
  name     = "vulgate-alb-tg"
  port     = 6205
  protocol = "HTTP"
  vpc_id   = "${aws_vpc.main.id}"
}

resource "aws_alb_listener" "vulgate" {
  load_balancer_arn = "${aws_alb.vulgate.arn}"
  port              = 6205
  protocol          = "HTTP"

  default_action {
    target_group_arn = "${aws_alb_target_group.vulgate.arn}"
    type             = "forward"
  }
}
