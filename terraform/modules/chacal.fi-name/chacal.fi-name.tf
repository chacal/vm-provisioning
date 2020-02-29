variable "hostname" {
  type = string
}

variable "ip" {
  type = string
}

resource "aws_route53_record" "fqdn" {
  zone_id = "Z2BP7OJ10ULLAP"
  name    = var.hostname
  type    = "A"
  ttl     = "60"
  records = [var.ip]
}
