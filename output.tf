output "aws_iam_policy_arn" {
  value = length(aws_iam_policy.cluster_autoscaler) == 0 ? null : aws_iam_policy.cluster_autoscaler.0.arn
}

output "kubernetes_deployment" {
  value = "${kubernetes_deployment.cluster_autoscaler.metadata.0.namespace}/${kubernetes_deployment.cluster_autoscaler.metadata.0.name}"
}
