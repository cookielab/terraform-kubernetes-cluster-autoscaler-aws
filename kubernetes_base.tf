resource "kubernetes_namespace" "cluster_autoscaler" {
  count = var.kubernetes_namespace_create ? 1 : 0

  metadata {
    name = var.kubernetes_namespace
  }
}
