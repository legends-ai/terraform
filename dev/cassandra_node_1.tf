/*
resource "aws_instance" "cassandra_1" {
  instance_type          = "m4.large"
  ami                    = "${lookup(var.cassandra_amis, var.region)}"
  key_name               = "${aws_key_pair.user.key_name}"
  subnet_id              = "${aws_subnet.main.id}"
  vpc_security_group_ids = ["${aws_security_group.cassandra.id}"]

  # TODO(igm): forces new resource
  # associate_public_ip_address = false

  tags {
    Name = "dev:cassandra_1"
  }

  root_block_device {
    volume_type           = "gp2"
    volume_size           = "20"  # GB
    delete_on_termination = true
  }
}

resource "aws_volume_attachment" "cassandra_1" {
  device_name = "/dev/xvdh"
  volume_id   = "${aws_ebs_volume.cassandra_1.id}"
  instance_id = "${aws_instance.cassandra_1.id}"

  provisioner "remote-exec" {
    inline = [
      "sudo mkfs -t ext4 /dev/xvdh",
      "sudo mkdir -p /var/lib/cassandra",
      "sudo mount -t ext4 /dev/xvdh /var/lib/cassandra",
    ]

    connection {
      host                = "${aws_instance.cassandra_1.private_ip}"
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

resource "aws_ebs_volume" "cassandra_1" {
  availability_zone = "${var.availability_zone}"
  size              = 40
  type              = "gp2"

  tags {
    Name = "dev:cassandra_1 data"
  }
}

resource "aws_route53_record" "cassandra_1" {
  zone_id = "${aws_route53_zone.main.zone_id}"
  name    = "node-1.cassandra.${aws_route53_zone.main.name}"
  type    = "A"
  ttl     = "300"
  records = ["${aws_instance.cassandra_1.private_ip}"]
}
*/

