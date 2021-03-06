output "access_list" {
  value = var.access_list
}

output "public_ip" {
  value = aws_eip.eip.public_ip
}

output "ami_id" {
  value = var.ami_id
}

output "eni" {
  value = aws_network_interface.interface.id
}

output "eip" {
  value = aws_eip.eip.id
}

output "public_fqdn" {
  value = var.public_fqdn
}

output "private_fqdn" {
  value = var.private_fqdn
}

output "key_name" {
  value = var.key_name
}

