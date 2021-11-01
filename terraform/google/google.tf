terraform {
  required_providers {
    google = {
      source  = "hashicorp/google"
      version = "=3.89.0"
    }
  }
}

resource "random_pet" "server" {}

variable "google_project_id" {
  type = string
}
variable "google_application_credentials" {
  type = string
}
variable "google_username" {
  type = string
}
variable "google_ssh_key_pub" {
  type = string
}
variable "google_ssh_key_pvt" {
  type = string
}

provider "google" {
  project     = var.google_project_id
  credentials = file("${var.google_application_credentials}")
  region      = "us-central1"
  zone        = "us-central1-c"
}

locals {
  ip = google_compute_instance.server.network_interface.0.access_config.0.nat_ip
}

resource "google_compute_instance" "server" {
  name           = random_pet.server.id
  machine_type   = "n1-standard-8"
  enable_display = true

  guest_accelerator {
    type  = "nvidia-tesla-t4"
    count = 1
  }

  boot_disk {
    initialize_params {
      image = "ubuntu-2004-lts"
      size  = 100
    }
  }

  scheduling {
    on_host_maintenance = "TERMINATE"
  }

  network_interface {
    network = "default"
    access_config {}
  }

  labels = {
    "colmap"    = ""
    "terraform" = ""
  }

  metadata = {
    ssh-keys = "${var.google_username}:${file(var.google_ssh_key_pub)}"
  }

  #   provisioner "local-exec" {
  #     when    = create
  #     command = "ANSIBLE_HOST_KEY_CHECKING=False ansible-playbook -u ${var.google_username} -i '${self.network_interface.0.access_config.0.nat_ip},' --private-key ${var.google_ssh_key_pvt} -e 'pub_key=${var.google_ssh_key_pub}' ../../ansible/nvidia-docker.yml"
  #   }

  #   provisioner "local-exec" {
  #     when    = create
  #     command = "ANSIBLE_HOST_KEY_CHECKING=False ansible-playbook -u rodones -i '${self.public_ip_address},' --private-key ${var.arm_ssh_key_pvt} -e 'pub_key=${var.arm_ssh_key_pub}' ../../ansible/init.yml"
  #   }
}


output "host" {
  value = google_compute_instance.server.network_interface.0.access_config.0.nat_ip
}
output "username" {
  value = var.google_username
}
