resource "aws_security_group" "ecs" {
  name        = "ecs"
  description = "Allows all traffic"
  vpc_id      = "${aws_vpc.main.id}"

  // allow all
  ingress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["10.0.0.0/16"]
  }

  // ssh
  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["10.0.0.0/16"]
  }

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

data "template_file" "ecs_0-config" {
  template = "${file("ecs-0.config")}"

  vars {
    ecs_cluster_name = "${var.ecs_cluster_name}"
  }
}

resource "aws_instance" "ecs_0" {
  instance_type               = "${var.ecs_instance_type}"
  ami                         = "${lookup(var.amis, var.region)}"
  placement_group             = "${aws_placement_group.main.id}"
  key_name                    = "${aws_key_pair.user.key_name}"
  subnet_id                   = "${aws_subnet.main.id}"
  iam_instance_profile        = "${aws_iam_instance_profile.ecs.name}"
  vpc_security_group_ids      = ["${aws_security_group.ecs.id}"]
  ebs_optimized               = false
  associate_public_ip_address = true
  user_data                   = "${data.template_file.ecs_0-config.rendered}"

  tags {
    Name = "dev:ecs_0"
  }

  root_block_device {
    volume_type           = "gp2"
    volume_size           = "20"  # GB
    delete_on_termination = true
  }
}

data "template_file" "ecs_1-config" {
  template = "${file("ecs-1.config")}"

  vars {
    ecs_cluster_name = "${var.ecs_cluster_name}"
  }
}

resource "aws_instance" "ecs_1" {
  instance_type               = "${var.ecs_instance_type}"
  ami                         = "${lookup(var.amis, var.region)}"
  placement_group             = "${aws_placement_group.main.id}"
  key_name                    = "${aws_key_pair.user.key_name}"
  subnet_id                   = "${aws_subnet.main.id}"
  iam_instance_profile        = "${aws_iam_instance_profile.ecs.name}"
  vpc_security_group_ids      = ["${aws_security_group.ecs.id}"]
  ebs_optimized               = false
  associate_public_ip_address = true
  user_data                   = "${data.template_file.ecs_1-config.rendered}"

  tags {
    Name = "dev:ecs_1"
  }

  root_block_device {
    volume_type           = "gp2"
    volume_size           = "20"  # GB
    delete_on_termination = true
  }
}

resource "aws_iam_role" "ecs_host_role" {
  name               = "ecs_host_role_debug"
  assume_role_policy = "${file("policies/ecs-role.json")}"
}

resource "aws_iam_role_policy" "ecs_instance_role_policy" {
  name   = "ecs_instance_role_policy"
  policy = "${file("policies/ecs-instance-role-policy.json")}"
  role   = "${aws_iam_role.ecs_host_role.id}"
}

resource "aws_iam_role" "ecs_service_role" {
  name               = "ecs_service_role_debug"
  assume_role_policy = "${file("policies/ecs-role.json")}"
}

resource "aws_iam_role_policy" "ecs_service_role_policy" {
  name   = "ecs_service_role_policy"
  policy = "${file("policies/ecs-service-role-policy.json")}"
  role   = "${aws_iam_role.ecs_service_role.id}"
}

resource "aws_iam_instance_profile" "ecs" {
  name  = "ecs_instance_profile_debug"
  path  = "/"
  roles = ["${aws_iam_role.ecs_host_role.name}"]
}

resource "aws_cloudwatch_log_group" "asuna" {
  # TODO(igm): interpolate
  name = "asuna-debug"
}

resource "aws_route53_record" "ecs_0" {
  zone_id = "${aws_route53_zone.main.zone_id}"
  name    = "ecs-0.muramasa.${aws_route53_zone.main.name}"
  type    = "A"
  ttl     = "300"
  records = ["${aws_instance.ecs_0.private_ip}"]
}

resource "aws_route53_record" "ecs_1" {
  zone_id = "${aws_route53_zone.main.zone_id}"
  name    = "ecs-1.muramasa.${aws_route53_zone.main.name}"
  type    = "A"
  ttl     = "300"
  records = ["${aws_instance.ecs_1.private_ip}"]
}
