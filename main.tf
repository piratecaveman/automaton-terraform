# Plugin used: https://registry.terraform.io/providers/lxc/incus/latest/docs

terraform {
  required_providers {
    incus = {
      source = "lxc/incus"
    }
  }
}

provider "incus" {
  generate_client_certificates = true
  accept_remote_certificate    = true
}

variable "instance_names" {
  type = list(string)
  default = [
    "kube-control-1",
    "kube-control-2",
    "kube-control-3",
    "kube-minion-1",
    "kube-minion-2",
    "kube-minion-3",
    "kube-lb-1",
  ]
}

resource "incus_instance" "kube" {
  count     = length(var.instance_names)
  name      = var.instance_names[count.index]
  image     = "images:ubuntu/22.04/cloud"
  type      = "virtual-machine"
  ephemeral = false

  config = {
    "boot.autostart" = true
  }

  limits = {
    cpu    = 2
    memory = "3GB"
  }

  profiles = ["access"]
}
