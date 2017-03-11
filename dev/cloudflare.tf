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

resource "cloudflare_record" "dev" {
  domain = "asuna.io"
  name   = "muramasa.dev"
  value  = "${aws_instance.ecs_0.public_ip}"
  type   = "A"
}
