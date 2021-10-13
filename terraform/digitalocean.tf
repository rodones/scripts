terraform {
  required_providers {
    digitalocean = {
      source  = "digitalocean/digitalocean"
      version = "~> 2.0"
    }
  }
}

resource "random_pet" "server" {}

variable "digitalocean_token" {
  type = string
}
variable "digitalocean_ssh_keys" {
  type = list(any)
}
variable "ssh_key_pvt" {
  type = string
}
variable "ssh_key_pub" {
  type = string
}

provider "digitalocean" {
  token = var.digitalocean_token
}

resource "digitalocean_droplet" "server" {
  image  = "docker-20-04"
  name   = random_pet.server.id
  region = "fra1"
  # size     = "c4"
  size     = "s-1vcpu-1gb"
  ssh_keys = var.digitalocean_ssh_keys
  tags     = ["colmap", "terraform"]

  provisioner "local-exec" {
    when    = create
    command = "ANSIBLE_HOST_KEY_CHECKING=False ansible-playbook -u root -i '${self.ipv4_address},' --private-key ${var.ssh_key_pvt} -e 'pub_key=${var.ssh_key_pub}' ../ansible/init.yml"
  }
}
