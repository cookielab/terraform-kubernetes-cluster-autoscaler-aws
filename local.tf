locals {
  kube_container_command = [
    "./cluster-autoscaler",
    "--v=4",
    "--stderrthreshold=info",
    "--cloud-provider=aws",
    "--skip-nodes-with-local-storage=${var.skip_nodes_with_local_storage ? "false" : "true"}",
    "--expander=${var.expander}",
    "--node-group-auto-discovery=asg:tag=${join(",", var.asg_tags)}",
  ]
}