terraform {
  backend "local"{
    path = "./terraform.tfstate"
  }

  required_version = "1.3.4"

  required_providers {
    kubernetes = {
      source = "hashicorp/kubernetes"
      version = "2.15.0"
    }
  }
}

provider "kubernetes" {
  config_path    = "~/.kube/config"
}

resource "kubernetes_manifest" "namespace" {
  manifest = yamldecode(file("${path.module}/../kubernetes/namespace.yaml"))
}

locals {
  yamls = toset(split("---", file("${path.module}/../kubernetes/deployment.yaml")))
}

resource "kubernetes_manifest" "main" {
  for_each = local.yamls
  manifest = yamldecode(each.value)
  depends_on = [
    kubernetes_manifest.namespace
  ]
}