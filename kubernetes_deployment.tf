resource "kubernetes_deployment" "cluster_autoscaler" {
  metadata {
    name = var.kubernetes_deployment_name
    namespace = var.kubernetes_namespace
    labels = {
      app = "tf-aws-kube-cluster-autoscaler"
    }
  }

  spec {
    replicas = 1

    selector {
      match_labels = {
        app = "tf-aws-kube-cluster-autoscaler"
      }
    }

    template {
      metadata {
        labels = {
          app = "tf-aws-kube-cluster-autoscaler"
        }
      }

      spec {
        service_account_name = kubernetes_service_account.cluster_autoscaler.metadata.0.name

        container {
          image = "k8s.gcr.io/cluster-autoscaler:v1.15.0"
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

          command = local.kube_container_command

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
      }
    }
  }
}
