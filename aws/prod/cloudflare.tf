provider "cloudflare" {
  email = "${var.cloudflare_email}"
  token = "${var.cloudflare_token}"
}

resource "cloudflare_record" "bastion" {
  domain = "asuna.io"
  name   = "bastion.prod"
  value  = "${aws_eip.bastion.public_ip}"
  type   = "A"
}

/*
resource "cloudflare_record" "prod" {
  domain = "legends.ai"
  name   = "www"
  value  = "${aws_eip.ecs.public_ip}"
  type   = "A"
}
*/
