provider "cloudflare" {
  email = "${var.cloudflare_email}"
  token = "${var.cloudflare_token}"
}

resource "cloudflare_record" "bastion" {
  domain = "asuna.io"
  name   = "bastion.dev"
  value  = "${aws_eip.bastion.public_ip}"
  type   = "A"
}

resource "cloudflare_record" "legends-ai" {
  domain = "asuna.io"
  name   = "gt40.dev"
  value  = "${aws_alb.legends-ai.dns_name}"
  type   = "CNAME"
}

resource "cloudflare_record" "helios" {
  domain = "asuna.io"
  name   = "helios.dev"
  value  = "${aws_alb.helios.dns_name}"
  type   = "CNAME"
}
