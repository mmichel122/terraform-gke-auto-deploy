
resource "google_container_cluster" "primary" {
  name       = var.cluster_name
  location   = var.location
  network    = var.network_vpc
  subnetwork = var.subnetwork

  remove_default_node_pool = true
  initial_node_count       = 1

  master_auth {
    username = "${var.username}"
    password = "${var.password}"
    client_certificate_config {
      issue_client_certificate = true
    }
  }
}

resource "google_container_node_pool" "primary_nodes" {
  name       = "nodes"
  location   = var.location
  cluster    = "${google_container_cluster.primary.name}"
  node_count = 1

  autoscaling {
    min_node_count = 1
    max_node_count = 6
  }

  management {
    auto_repair  = true
    auto_upgrade = true
  }

  node_config {
    machine_type = "g1-small"
    oauth_scopes = [
      "https://www.googleapis.com/auth/devstorage.read_only",
      "https://www.googleapis.com/auth/logging.write",
      "https://www.googleapis.com/auth/monitoring",
      "https://www.googleapis.com/auth/service.management.readonly",
      "https://www.googleapis.com/auth/servicecontrol",
      "https://www.googleapis.com/auth/trace.append",
      "https://www.googleapis.com/auth/compute",
    ]
  }
}
