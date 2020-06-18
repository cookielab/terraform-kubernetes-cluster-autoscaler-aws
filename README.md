# Terraform module for Kubernetes Cluster Autoscaler on AWS

This module deploys [Cluster Autoscaler](https://github.com/kubernetes/autoscaler/tree/master/cluster-autoscaler) for AWS to your Kubernetes cluster.

## Usage

```terraform
provider "kubernetes" {
  # your kubernetes provider config
}

provider "aws" {
  # your aws provider config
}

data "aws_iam_role" "kubernetes_worker_node" {
  name = "kube-clb-main-wg-primary"
}

module "kubernetes_dashboard" {
  source = "cookielab/cluster-autoscaler-aws/kubernetes"
  version = "0.10.0"

  aws_iam_role_for_policy = data.aws_iam_role.kubernetes_worker_node.name

  asg_tags = [
    "k8s.io/cluster-autoscaler/enabled",
    "k8s.io/cluster-autoscaler/${var.kubernetes_cluster_name}",
  ]

  kubernetes_deployment_image_tag = "v1.16.0" # v1.16.0 is for kubernetes 1.16.x
}
```
