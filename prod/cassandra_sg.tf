resource "aws_security_group" "cassandra" {
  name        = "prod:cassandra"
  vpc_id      = "${aws_vpc.main.id}"

  // CQL Native Transport Port
  ingress {
    from_port   = 9042
    to_port     = 9042
    protocol    = "tcp"
    cidr_blocks = ["10.0.0.0/16"]
  }

  // JMX Monitoring Port
  ingress {
    from_port   = 7199
    to_port     = 7199
    protocol    = "tcp"
    cidr_blocks = ["10.0.0.0/16"]
  }

  ingress {
    from_port   = 22
    to_port     = 22
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
