// nat_instance role
resource "aws_iam_role" "role" {
  name = var.name

  assume_role_policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Action": "sts:AssumeRole",
      "Principal": {
        "Service": "ec2.amazonaws.com"
      },
      "Effect": "Allow",
      "Sid": ""
    }
  ]
}
EOF

}

// nat_instance needs to see autotscaling groups and handle enis
data "aws_iam_policy_document" "document" {
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

// create our nat_instance iam_policy
resource "aws_iam_policy" "policy" {
  name   = var.name
  policy = data.aws_iam_policy_document.document.json
}

// attach iam_policy to nat_instance role
resource "aws_iam_role_policy_attachment" "attachment" {
  role       = var.name
  policy_arn = aws_iam_policy.policy.arn
}

// create profile from role
resource "aws_iam_instance_profile" "profile" {
  role = aws_iam_role.role.name
  name = var.name
}

