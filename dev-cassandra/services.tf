resource "aws_ecs_task_definition" "cassandra" {
  family = "cassandra"
  container_definitions = "${file("task-definitions/cassandra.json")}"

  volume {
    name = "cassandra-storage"
    host_path = "/ecs/cassandra-storage"
  }
}

resource "aws_ecs_service" "cassandra" {
  name = "cassandra"
  cluster = "${aws_ecs_cluster.main.id}"
  task_definition = "${aws_ecs_task_definition.cassandra.arn}"
  desired_count = 1
  iam_role = "${aws_iam_role.ecs_service_role.arn}"
  depends_on = ["aws_iam_role_policy.ecs_service_role_policy"]

  load_balancer {
    elb_name = "${aws_elb.cassandra.id}"
    container_name = "cassandra"
    container_port = 9042
  }
}

resource "aws_elb" "cassandra" {
  name = "cassandra-elb"
  subnets = [
    "${aws_subnet.main.id}"
  ]

  listener {
    instance_port = 9042
    instance_protocol = "tcp"
    lb_port = 9042
    lb_protocol = "tcp"
  }

  idle_timeout = 60
  connection_draining = true
  connection_draining_timeout = 300

  tags {
    Name = "cassandra-elb"
  }
}
