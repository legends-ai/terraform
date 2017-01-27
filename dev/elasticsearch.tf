resource "aws_elasticsearch_domain" "es" {
  domain_name = "muramasa-es-cluster"
  elasticsearch_version = "2.3"
  advanced_options {
    "rest.action.multi.allow_explicit_index" = true
  }

  access_policies = <<CONFIG
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Principal": {
        "AWS": "arn:aws:iam::096202052535:user/ian"
      },
      "Action": "es:*",
      "Resource": "arn:aws:es:us-east-1:096202052535:domain/muramasa-es/*"
    }
  ]
}
CONFIG

  cluster_config {
    instance_type = "t2.micro"
    instance_count = 1
  }

  snapshot_options {
    automated_snapshot_start_hour = 23
  }

  tags {
    Domain = "muramasa-es-cluster"
  }
}
