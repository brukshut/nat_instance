variable "access_list" {
  description = "list of ips for ssh access in CIDR notation"
  type        = list(string)
}

variable "ami_id" {
}

variable "public_fqdn" {
}

variable "private_fqdn" {
}

variable "instance_type" {
}

variable "key_name" {
}

variable "private_key" {
  description = "path to public key for terraform provider ssh access"
}

variable "private_ip" {
}

variable "name" {
}

variable "region" {
}

variable "subnet_id" {
}

variable "eni_subnet_id" {
}

variable "vpc_cidr" {
}

variable "vpc_id" {
}

variable "public_zone_id" {
}

variable "private_zone_id" {
}

variable "user" {
}

