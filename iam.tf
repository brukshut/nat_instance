data "aws_iam_policy_document" "document" {
  // autoscaling
  statement {
    actions = [
      "autoscaling:DescribeAutoScalingGroups",
    ]

    resources = ["*"]
  }

  statement {
    actions = [
      "autoscaling:DescribeAutoScalingInstances",
    ]

    resources = ["*"]
  }

  // eni
  statement {
    actions = [
      "ec2:DescribeNetworkInterfaces",
    ]

    resources = ["*"]
  }

  statement {
    actions = [
      "ec2:DetachNetworkInterface",
      "ec2:AttachNetworkInterface",
    ]

    resources = ["*"]
  }
}

module "nat_policy" {
  name   = "${var.name}"
  policy = "${data.aws_iam_policy_document.document.json}"
  source = "../../modules/iam/policy"
}

module "nat_role" {
  policy_arn = ["${module.nat_policy.arn}"]
  name       = "${var.name}"
  source     = "../../modules/iam/role"
}

module "nat_profile" {
  source = "../../modules/iam/profile"
  role   = "${module.nat_role.name}"
  name   = "${var.name}"
}
