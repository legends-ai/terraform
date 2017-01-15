provider "cloudflare" {
  email = "${var.cloudflare_email}"
  token = "${var.cloudflare_token}"
}

# Create a record
resource "cloudflare_record" "bastion" {
  domain = "asuna.io"
  name   = "bastion.dev"
  value  = "${aws_eip.bastion.public_ip}"
  type   = "A"
}
