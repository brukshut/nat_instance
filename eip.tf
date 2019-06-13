resource "aws_eip" "eip" {
  vpc                       = true
  associate_with_private_ip = "${var.private_ip}"

  tags {
    Name = "${var.public_fqdn}"
  }
}

resource "aws_network_interface" "interface" {
  subnet_id         = "${var.eni_subnet_id}"
  private_ips       = ["${var.private_ip}"]
  security_groups   = ["${aws_security_group.group.id}"]
  source_dest_check = false

  tags {
    Name = "${var.name}"
    FQDN = "${var.private_fqdn}"
  }
}

resource "aws_eip_association" "association" {
  network_interface_id = "${aws_network_interface.interface.id}"
  allocation_id        = "${aws_eip.eip.id}"
  private_ip_address   = "${var.private_ip}"
}
