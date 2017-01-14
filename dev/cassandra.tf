resource "aws_autoscaling_group" "cassandra-cluster" {
  availability_zones = ["${var.availability_zone}"]
  name = "cassandra-dev"
  min_size = "${var.cassandra_autoscale_min}"
  max_size = "${var.cassandra_autoscale_max}"
  desired_capacity = "${var.cassandra_autoscale_desired}"
  health_check_type = "EC2"
  launch_configuration = "${aws_launch_configuration.ecs.name}"
  vpc_zone_identifier = ["${aws_subnet.main.id}"]
}

resource "aws_launch_configuration" "cassandra" {
  name = "cassandra-dev"
  image_id = "${lookup(var.cassandra_amis, var.region)}"
  instance_type = "m4.large"
  security_groups = ["${aws_security_group.ecs.id}"]
  iam_instance_profile = "${aws_iam_instance_profile.ecs.name}"
  key_name = "${aws_key_pair.user.key_name}"
  associate_public_ip_address = false
  ebs_optimized = true

  root_block_device {
    volume_type = "gp2"
    volume_size = "20" # GB
    delete_on_termination = true
  }

  ebs_block_device {
    device_name = "cassandra_data"
    volume_type = "gp2"
    volume_size = "40" # GB
    delete_on_termination = false
  }

}
