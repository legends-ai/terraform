resource "aws_instance" "cassandra_0" {
  instance_type          = "t2.medium"
  ami                    = "${lookup(var.cassandra_amis, var.region)}"
  key_name               = "${aws_key_pair.user.key_name}"
  subnet_id              = "${aws_subnet.main.id}"
  vpc_security_group_ids = ["${aws_security_group.cassandra.id}"]

  # TODO(igm): forces new resource


  # associate_public_ip_address = false

  tags {
    Name = "cassandra_0"
  }
  root_block_device {
    volume_type           = "gp2"
    volume_size           = "20"  # GB
    delete_on_termination = true
  }
}

resource "aws_security_group" "cassandra" {
  name        = "cassandra"
  description = "Allows all traffic"
  vpc_id      = "${aws_vpc.main.id}"

  ingress {
    from_port   = 9042
    to_port     = 9042
    protocol    = "tcp"
    cidr_blocks = ["10.0.0.0/16"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_volume_attachment" "cassandra_0" {
  device_name = "/dev/xvdh"
  volume_id   = "${aws_ebs_volume.cassandra_0.id}"
  instance_id = "${aws_instance.cassandra_0.id}"

  provisioner "remote-exec" {
    inline = [
      "sudo mkfs -t ext4 /dev/xvdh",
      "sudo mkdir -p /var/lib/cassandra",
      "sudo mount -t ext4 /dev/xvdh /var/lib/cassandra",
    ]

    connection {
      host                = "${aws_instance.cassandra_0.private_ip}"
      type                = "ssh"
      user                = "ubuntu"
      timeout             = "5m"
      private_key         = "${file(var.ssh_privkey_file)}"
      bastion_host        = "${aws_eip.bastion.public_ip}"
      bastion_user        = "ec2-user"
      bastion_private_key = "${file(var.ssh_privkey_file)}"
    }
  }
}

resource "aws_ebs_volume" "cassandra_0" {
  availability_zone = "${var.availability_zone}"
  size              = 40
  type              = "gp2"

  tags {
    Name = "Cassandra 0 data"
  }
}

resource "aws_eip" "cassandra_0" {
  instance = "${aws_instance.cassandra_0.id}"
  vpc      = true
}

resource "aws_route53_record" "cassandra" {
  zone_id = "${aws_route53_zone.main.zone_id}"
  name    = "node-0.cassandra.${aws_route53_zone.main.name}"
  type    = "A"
  ttl     = "300"
  records = ["${aws_eip.cassandra_0.private_ip}"]
}
