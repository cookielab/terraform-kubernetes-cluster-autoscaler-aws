resource "kubernetes_service_account" "cluster_autoscaler" {
  metadata {
    name = "${var.kubernetes_resources_name_prefix}cluster-autoscaler"
    namespace = var.kubernetes_namespace
    labels = local.kubernetes_resources_labels
  }
}

resource "kubernetes_cluster_role" "cluster_autoscaler" {
  metadata {
    name = "${var.kubernetes_resources_name_prefix}cluster-autoscaler"
    labels = local.kubernetes_resources_labels
  }

  rule {
    api_groups = [""]
    resources = ["events", "endpoints"]
    verbs = ["create", "patch"]
  }

  rule {
    api_groups = [""]
    resources = ["pods/eviction"]
    verbs = ["create"]
  }

  rule {
    api_groups = [""]
    resources = ["pods/status"]
    verbs = ["update"]
  }

  rule {
    api_groups = [""]
    resources = ["endpoints"]
    resource_names = ["cluster-autoscaler"]
    verbs = ["get", "update"]
  }

  rule {
    api_groups = [""]
    resources = ["nodes"]
    verbs = ["watch", "list", "get", "update"]
  }

  rule {
    api_groups = [""]
    resources = ["pods", "services", "replicationcontrollers", "persistentvolumeclaims", "persistentvolumes"]
    verbs = ["watch", "list", "get"]
  }

  rule {
    api_groups = ["extensions"]
    resources = ["replicasets", "daemonsets"]
    verbs = ["watch", "list", "get"]
  }

  rule {
    api_groups = ["policy"]
    resources = ["poddisruptionbudgets"]
    verbs = ["watch", "list"]
  }

  rule {
    api_groups = ["apps"]
    resources = ["statefulsets", "replicasets", "daemonsets"]
    verbs = ["watch", "list", "get"]
  }

  rule {
    api_groups = ["storage.k8s.io"]
    resources = ["storageclasses"]
    verbs = ["watch", "list", "get"]
  }

  rule {
    api_groups = ["batch", "extensions"]
    resources = ["jobs"]
    verbs = ["get", "list", "watch", "patch"]
  }
}

resource "kubernetes_role" "cluster_autoscaler" {
  metadata {
    name = "${var.kubernetes_resources_name_prefix}cluster-autoscaler"
    namespace = kubernetes_service_account.cluster_autoscaler.metadata.0.namespace
    labels = local.kubernetes_resources_labels
  }

  rule {
    api_groups = [""]
    resources = ["configmaps"]
    verbs = ["create","list","watch"]
  }

  rule {
    api_groups = [""]
    resources = ["configmaps"]
    resource_names = ["cluster-autoscaler-status", "cluster-autoscaler-priority-expander"]
    verbs = ["delete", "get", "update", "watch"]
  }
}

resource "kubernetes_cluster_role_binding" "cluster_autoscaler" {
  metadata {
    name = "${var.kubernetes_resources_name_prefix}cluster-autoscaler"
    labels = local.kubernetes_resources_labels
  }

  role_ref {
    api_group = "rbac.authorization.k8s.io"
    kind = "ClusterRole"
    name = kubernetes_cluster_role.cluster_autoscaler.metadata.0.name
  }

  subject {
    kind = "ServiceAccount"
    name = kubernetes_service_account.cluster_autoscaler.metadata.0.name
    namespace = kubernetes_service_account.cluster_autoscaler.metadata.0.namespace
  }
}

resource "kubernetes_role_binding" "cluster_autoscaler" {
  metadata {
    name = "${var.kubernetes_resources_name_prefix}cluster-autoscaler"
    namespace = kubernetes_service_account.cluster_autoscaler.metadata.0.namespace
    labels = local.kubernetes_resources_labels
  }

  role_ref {
    api_group = "rbac.authorization.k8s.io"
    kind = "Role"
    name = kubernetes_role.cluster_autoscaler.metadata.0.name
  }

  subject {
    kind = "ServiceAccount"
    name = kubernetes_service_account.cluster_autoscaler.metadata.0.name
    namespace = kubernetes_service_account.cluster_autoscaler.metadata.0.namespace
  }
}

resource "kubernetes_deployment" "cluster_autoscaler" {
  metadata {
    name = "${var.kubernetes_resources_name_prefix}cluster-autoscaler"
    namespace = var.kubernetes_namespace
    labels = local.kubernetes_resources_labels
  }

  spec {
    replicas = 1

    selector {
      match_labels = local.kubernetes_deployment_labels_selector
    }

    template {
      metadata {
        labels = local.kubernetes_deployment_labels
        annotations = var.kubernetes_deployment_annotations
      }

      spec {
        service_account_name = kubernetes_service_account.cluster_autoscaler.metadata.0.name

        container {
          image = local.kubernetes_deployment_image
          name = "cluster-autoscaler"

          resources{
            limits {
              cpu = "100m"
              memory = "300Mi"
            }
            requests {
              cpu = "100m"
              memory = "300Mi"
            }
          }

          command = local.kubernetes_deployment_container_command

          volume_mount {
            name = "ssl-certs"
            mount_path = "/etc/ssl/certs/ca-certificates.crt"
            read_only = true
          }

          volume_mount { # hack for automountServiceAccountToken
            name = kubernetes_service_account.cluster_autoscaler.default_secret_name
            mount_path = "/var/run/secrets/kubernetes.io/serviceaccount"
            read_only = true
          }

          image_pull_policy = "Always"
        }

        volume {
          name = "ssl-certs"
          host_path {
            path = "/etc/ssl/certs/ca-bundle.crt"
          }
        }

        volume { # hack for automountServiceAccountToken
          name = kubernetes_service_account.cluster_autoscaler.default_secret_name
          secret {
            secret_name = kubernetes_service_account.cluster_autoscaler.default_secret_name
          }
        }

        node_selector = var.kubernetes_deployment_node_selector
      }
    }
  }
}
