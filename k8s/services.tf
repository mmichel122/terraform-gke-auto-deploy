resource "kubernetes_service" "ghost_service" {
  metadata {
    name = "ghost-service"
  }
  spec {
    selector = {
      app = "${kubernetes_deployment.ghost_deployment.spec.0.template.0.metadata.0.labels.app}"
    }
    port {
      port        = "80"
      target_port = "2368"
      node_port   = "30000"
    }

    type = "LoadBalancer"
  }
}
