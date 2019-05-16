resource "aws_route53_record" "public" {
  zone_id = "${var.public_zone_id}"
  name    = "${var.public_fqdn}"
  type    = "A"
  ttl     = "300"
  records = ["${aws_eip.nat_instance.public_ip}"]
}

resource "aws_route53_record" "private" {
  zone_id = "${var.private_zone_id}"
  name    = "${var.private_fqdn}"
  type    = "A"
  ttl     = "300"
  records = ["${var.private_ip}"]
}
