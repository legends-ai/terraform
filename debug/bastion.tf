resource "aws_instance" "bastion" {
  instance_type = "${var.bastion_instance_type}"
  ami           = "${lookup(var.bastion_amis, var.region)}"
  key_name      = "${aws_key_pair.user.key_name}"
  subnet_id     = "${aws_subnet.main.id}"

  vpc_security_group_ids = [
    "${aws_security_group.cassandra.id}",
    "${aws_security_group.ecs.id}",
    "${aws_security_group.bastion.id}",
  ]

  associate_public_ip_address = true
  source_dest_check           = false

  tags {
    Name = "bastion"
  }

  root_block_device {
    volume_type           = "gp2"
    volume_size           = "10"  # GB
    delete_on_termination = true
  }
}

resource "aws_security_group" "bastion" {
  name        = "bastion"
  description = "Allow access from allowed_network via SSH"
  vpc_id      = "${aws_vpc.main.id}"

  # SSH
  ingress = {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["${split(",", var.allowed_cidr_blocks)}"]
    self        = false
  }

  egress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["${split(",", var.internal_cidr_blocks)}"]
  }

  tags = {
    Name   = "bastion"
    stream = "bastion"
  }
}

resource "aws_eip" "bastion" {
  instance = "${aws_instance.bastion.id}"

  # TODO(igm): forces new resource

  # vpc      = false
}
