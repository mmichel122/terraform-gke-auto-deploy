provider "google" {
  #credentials = "${file("./creds/serviceaccount.json")}"
  project = var.project_id
  region  = var.location
}

terraform {
  backend "remote" {
    organization = "modus-demo"
    workspaces {
      name = "gcp-k8s-blog-eu"
    }
  }
}

module "network" {
  source       = "./network"
  project_name = var.project_name
  cidr_block   = var.cidr_block
  network_name = var.network_name
}

module "cluster" {
  source       = "./cluster"
  project_name = var.project_name
  cluster_name = var.cluster_name
  network_vpc  = module.network.network_vpc_uri
  subnetwork   = module.network.subnetwork_link
  location     = var.location
  username     = var.username
  password     = var.password
}

module "filestore" {
  source       = "./file"
  region       = var.location
  file_name    = var.cluster_name
  network_name = var.network_name
}

module "k8s" {
  source   = "./k8s"
  host     = module.cluster.host
  username = var.username
  password = var.password

  client_certificate     = module.cluster.client_certificate
  client_key             = module.cluster.client_key
  cluster_ca_certificate = module.cluster.cluster_ca_certificate
}
