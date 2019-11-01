provider "kubernetes" {
  host     = "${var.host}"
  username = "${var.username}"
  password = "${var.password}"

  client_certificate     = "${base64decode(var.client_certificate)}"
  client_key             = "${base64decode(var.client_key)}"
  cluster_ca_certificate = "${base64decode(var.cluster_ca_certificate)}"
}

resource "kubernetes_deployment" "ghost_deployment" {
  metadata {
    name = "ghost-blog"
  }

  spec {
    replicas = "3"

    selector {
      match_labels = {
        app = "ghost-blog"
      }
    }

    template {
      metadata {
        labels = {
          app = "ghost-blog"
        }
      }

      spec {
        container {
          name  = "ghost"
          image = "ghost:alpine"
          port {
            container_port = "2368"
          }
        }
      }
    }
  }
}
