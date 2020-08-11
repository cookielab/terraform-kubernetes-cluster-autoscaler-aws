locals {
  kubernetes_resources_labels = merge({
    "cookielab.io/terraform-module" = "aws-kube-cluster-autoscaler",
    k8s-addon = "cluster-autoscaler.addons.k8s.io",
  }, var.kubernetes_resources_labels)

  kubernetes_deployment_labels_selector = {
    "cookielab.io/deployment" = "aws-kube-cluster-autoscaler-tf-module",
  }

  kubernetes_deployment_labels = merge(local.kubernetes_deployment_labels_selector, local.kubernetes_resources_labels)

  kubernetes_deployment_image = "${var.kubernetes_deployment_image_registry}:${var.kubernetes_deployment_image_tag}"

  kubernetes_deployment_container_command = concat([
    "./cluster-autoscaler",
    "--v=4",
    "--stderrthreshold=info",
    "--cloud-provider=aws",
    "--skip-nodes-with-local-storage=${var.skip_nodes_with_local_storage ? "false" : "true"}",
    "--expander=${var.expander}",
    "--node-group-auto-discovery=asg:tag=${join(",", var.asg_tags)}",
  ], var.additional_autoscaler_options)
}
