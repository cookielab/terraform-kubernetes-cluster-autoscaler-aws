variable "asg_tags" {
  type = list(string)
  default = ["k8s.io/cluster-autoscaler/enabled"]
  description = "AWS AutoScalingGroup tags."
}

variable "skip_nodes_with_local_storage" {
  type = bool
  default = false
  description = "Skip nodes with local storage."
}

variable "expander" {
  type = string
  default = "least-waste"
  description = "Expanders provide different strategies for selecting the node group to which new nodes will be added. Possible values and info here: https://github.com/kubernetes/autoscaler/blob/master/cluster-autoscaler/FAQ.md#what-are-expanders"
}

variable "kubernetes_namespace" {
  type = string
  default = "kube-system"
  description = "Kubernetes namespace to deploy cluster autoscaler."
}

variable "kubernetes_namespace_create" {
  type = bool
  default = false
  description = "Do you want to create kubernetes namespace?"
}

variable "kubernetes_resources_name_prefix" {
  type = string
  default = ""
  description = "Prefix for kubernetes resources name. For example `tf-module-`"
}

variable "kubernetes_resources_labels" {
  type = map(string)
  default = {}
  description = "Additional labels for kubernetes resources."
}

variable "kubernetes_deployment_image_registry" {
  type = string
  default = "k8s.gcr.io/cluster-autoscaler"
}

variable "kubernetes_deployment_image_tag" {
  type = string
  default = "v1.15.1"
}

variable "kubernetes_deployment_node_selector" {
  type = map(string)
  default = {}
  description = "Node selectors for kubernetes deployment"
}

variable "aws_create_iam_policy" {
  type = bool
  default = true
  description = "Do you want to create AWS IAM policy?"
}

variable "aws_iam_policy_name" {
  type = string
  default = "KubernetesClusterAutoscaler"
  description = "Name of AWS IAM policy"
}

variable "aws_iam_role_for_policy" {
  type = string
  default = null
  description = "AWS IAM Role name for attaching AWS IAM policy."
}

variable "kubernetes_deployment_annotations" {
  type = map(string)
  default = {}
  description = "Annotations for pod template"
}
