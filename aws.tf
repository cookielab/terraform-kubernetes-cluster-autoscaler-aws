resource "aws_iam_policy" "cluster_autoscaler" {
  count = var.aws_create_iam_policy ? 1 : 0

  name = var.aws_iam_policy_name
  path = "/"
  description = "Allows access to resources needed to run kubernetes cluster autoscaler."

  policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Action": [
        "autoscaling:DescribeAutoScalingGroups",
        "autoscaling:DescribeAutoScalingInstances",
        "autoscaling:DescribeTags",
        "autoscaling:SetDesiredCapacity",
        "autoscaling:TerminateInstanceInAutoScalingGroup"
      ],
      "Resource": "*"
    }
  ]
}
EOF

}

resource "aws_iam_role_policy_attachment" "cluster_autoscaler" {
  count = var.aws_create_iam_policy && var.aws_iam_role_for_policy != null ? 1 : 0

  role = var.aws_iam_role_for_policy
  policy_arn = aws_iam_policy.cluster_autoscaler.0.arn
}
