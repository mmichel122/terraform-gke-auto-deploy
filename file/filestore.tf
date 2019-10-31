resource "google_filestore_instance" "kube_file" {
  name = "${var.file_name}"
  zone = "${var.region}-c"
  tier = "STANDARD"

  file_shares {
    capacity_gb = 1024
    name        = "wordpress_files"
  }

  networks {
    network = var.network_name
    modes   = ["MODE_IPV4"]
  }
}
