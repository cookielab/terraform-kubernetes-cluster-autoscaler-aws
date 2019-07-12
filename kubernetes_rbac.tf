resource "kubernetes_service_account" "cluster_autoscaler" {
  metadata {
    name = var.kubernetes_service_account_name
    namespace = var.kubernetes_namespace
    labels = {
      k8s-addon = "cluster-autoscaler.addons.k8s.io"
      k8s-app = "tf-aws-kube-cluster-autoscaler"
    }
  }

  automount_service_account_token = true
}

resource "kubernetes_cluster_role" "cluster_autoscaler" {
  metadata {
    name = var.kubernetes_cluster_role_name
    labels = {
      k8s-addon = "cluster-autoscaler.addons.k8s.io"
      k8s-app = "tf-aws-kube-cluster-autoscaler"
    }
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
    name = var.kubernetes_role_name
    namespace = kubernetes_service_account.cluster_autoscaler.metadata.0.namespace
    labels = {
      k8s-addon = "cluster-autoscaler.addons.k8s.io"
      k8s-app = "tf-aws-kube-cluster-autoscaler"
    }
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
    name = var.kubernetes_cluster_role_binding_name
    labels = {
      k8s-addon = "cluster-autoscaler.addons.k8s.io"
      k8s-app = "tf-aws-kube-cluster-autoscaler"
    }
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
    name = var.kubernetes_role_binding_name
    namespace = kubernetes_service_account.cluster_autoscaler.metadata.0.namespace
    labels = {
      k8s-addon = "cluster-autoscaler.addons.k8s.io"
      k8s-app = "tf-aws-kube-cluster-autoscaler"
    }
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
