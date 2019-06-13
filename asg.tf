resource "aws_launch_configuration" "nat_instance" {
  name_prefix          = "${var.name}"
  image_id             = "${var.ami_id}"
  instance_type        = "${var.instance_type}"
  key_name             = "${var.key_name}"
  iam_instance_profile = "${aws_iam_instance_profile.profile.name}"
  security_groups      = ["${aws_security_group.nat_instance.id}"]
  user_data_base64     = "${base64encode(data.template_file.user_data.rendered)}"

  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_autoscaling_group" "nat_instance" {
  name                      = "${var.name}"
  launch_configuration      = "${aws_launch_configuration.nat_instance.id}"
  min_size                  = 1
  max_size                  = 1
  health_check_grace_period = 5
  health_check_type         = "EC2"
  vpc_zone_identifier       = ["${var.subnet_id}"]

  tags = [
    {
      key                 = "Name"
      value               = "${var.name}"
      propagate_at_launch = true
    },
    {
      key                 = "NAT"
      value               = "true"
      propagate_at_launch = true
    },
  ]

  lifecycle {
    create_before_destroy = true
  }
}
