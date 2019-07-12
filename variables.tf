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

variable "aws_create_policy" {
  type = bool
  default = true
  description = "Do you want to create IAM policy?"
}

variable "aws_role_for_policy" {
  type = string
  default = null
  description = "AWS role name for attaching IAM policy"
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

variable "kubernetes_service_account_name" {
  type = string
  default = "cluster-autoscaler"
  description = "Kubernetes service account name."
}

variable "kubernetes_cluster_role_name" {
  type = string
  default = "cluster-autoscaler"
  description = "Kubernetes cluster role name."
}

variable "kubernetes_cluster_role_binding_name" {
  type = string
  default = "cluster-autoscaler"
  description = "Kubernetes cluster role binding name."
}

variable "kubernetes_role_name" {
  type = string
  default = "cluster-autoscaler"
  description = "Kubernetes role name."
}

variable "kubernetes_role_binding_name" {
  type = string
  default = "cluster-autoscaler"
  description = "Kubernetes role binding name."
}

variable "kubernetes_deployment_name" {
  type = string
  default = "cluster-autoscaler"
  description = "Kubernetes deployment name."
}