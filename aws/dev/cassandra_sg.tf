resource "aws_security_group" "cassandra" {
  name   = "dev:cassandra"
  vpc_id = "${aws_vpc.main.id}"

  // CQL Native Transport Port
  ingress {
    from_port   = 9042
    to_port     = 9042
    protocol    = "tcp"
    cidr_blocks = ["10.0.0.0/16"]
  }

  // Cassandra Thrift Client Port
  ingress {
    from_port   = 9160
    to_port     = 9160
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

  // Internode Communication Port
  ingress {
    from_port   = 7000
    to_port     = 7000
    protocol    = "tcp"
    cidr_blocks = ["10.0.0.0/16"]
  }

  // Internode Communication Secure Port
  ingress {
    from_port   = 7001
    to_port     = 7001
    protocol    = "tcp"
    cidr_blocks = ["10.0.0.0/16"]
  }

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["10.0.0.0/16"]
  }

  ingress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}
