/*
resource "aws_db_subnet_group" "aurora-dev" {
  name       = "aurora-dev"
  subnet_ids = ["${aws_subnet.main.id}", "${aws_subnet.main_2.id}"]

  tags {
    Name = "aurora subnet group"
  }
}

resource "aws_rds_cluster" "aurora-dev" {
  cluster_identifier      = "aurora-dev"
  availability_zones      = ["us-east-1a", "us-east-1b"]
  db_subnet_group_name    = "${aws_db_subnet_group.aurora-dev.id}"
  database_name           = "${var.aurora_database}"
  master_username         = "${var.aurora_username}"
  master_password         = "${var.aurora_password}"
  backup_retention_period = 1
  preferred_backup_window = "05:00-06:00"
  port                    = 3306
}

resource "aws_rds_cluster_instance" "aurora" {
  count                = 2
  identifier           = "aurora-dev"
  cluster_identifier   = "${aws_rds_cluster.aurora-dev.id}"
  db_subnet_group_name = "${aws_db_subnet_group.aurora-dev.id}"
  publicly_accessible  = false
  instance_class       = "db.r3.large"
}
*/
