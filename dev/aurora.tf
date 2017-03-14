resource "aws_db_subnet_group" "aurora" {
  name       = "aurora-dev"
  subnet_ids = ["${aws_subnet.main.id}", "${aws_subnet.main_2.id}"]
}

resource "aws_security_group" "aurora" {
  name   = "dev:aurora"
  vpc_id = "${aws_vpc.main.id}"

  ingress {
    from_port   = 3306
    to_port     = 3306
    protocol    = "tcp"
    cidr_blocks = ["10.0.0.0/16"]
  }

  egress {
    from_port   = 3306
    to_port     = 3306
    protocol    = "tcp"
    cidr_blocks = ["10.0.0.0/16"]
  }
}

resource "aws_db_parameter_group" "aurora" {
  name   = "aurora-dev"
  family = "aurora5.6"

  parameter {
    name  = "performance_schema"
    value = 1
    apply_method = "pending-reboot"
  }
}

/*
resource "aws_rds_cluster" "aurora" {
  cluster_identifier      = "aurora-dev"
  db_subnet_group_name    = "${aws_db_subnet_group.aurora.id}"
  vpc_security_group_ids  = ["${aws_security_group.aurora.id}"]
  database_name           = "${var.aurora_database}"
  master_username         = "${var.aurora_username}"
  master_password         = "${var.aurora_password}"
  backup_retention_period = 1
  preferred_backup_window = "05:00-06:00"
  port                    = 3306
}

resource "aws_rds_cluster_instance" "aurora" {
  count                = 2
  identifier           = "aurora-dev-${count.index}"
  cluster_identifier   = "${aws_rds_cluster.aurora.id}"
  db_subnet_group_name = "${aws_db_subnet_group.aurora.id}"
  publicly_accessible  = false
  instance_class       = "db.r3.large"
}
*/
