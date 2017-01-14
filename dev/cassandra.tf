resource "aws_instance" "cassandra_0" {
  instance_type = "m4.large"
  ami = "${lookup(var.cassandra_amis, var.region)}"
  key_name = "${aws_key_pair.user.key_name}"
  subnet_id = "${aws_subnet.main.id}"
  vpc_security_group_ids = ["${aws_security_group.ecs.id}"]
  ebs_optimized = true
  associate_public_ip_address = false

  tags {
    Name = "cassandra_0"
  }

  root_block_device {
    volume_type = "gp2"
    volume_size = "20" # GB
    delete_on_termination = true
  }

  provisioner "local-exec" {
    command = "mount /dev/sdh /var/lib/cassandra"
  }
}

resource "aws_volume_attachment" "cassandra_0_data" {
  device_name = "/dev/sdh"
  volume_id = "${aws_ebs_volume.cassandra_0.id}"
  instance_id = "${aws_instance.cassandra_0.id}"
}

resource "aws_ebs_volume" "cassandra_0" {
  availability_zone = "${var.availability_zone}"
  size = 40
  type = "gp2"
  tags {
    Name = "HelloWorld"
  }
}


resource "aws_eip" "cassandra_0" {
  instance = "${aws_instance.cassandra_0.id}"
  vpc      = true
}

resource "aws_route53_zone" "cassandra" {
  name = "cassandra.dev."
  vpc_id = "${aws_vpc.main.id}"
}

resource "aws_route53_record" "www" {
  zone_id = "${aws_route53_zone.cassandra.zone_id}"
  name = "node-0.${aws_route53_zone.cassandra.name}"
  type = "A"
  ttl = "300"
  records = ["${aws_eip.cassandra_0.private_ip}"]
}
