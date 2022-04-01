terraform {
  required_providers {
    hcloud = {
      source  = "hetznercloud/hcloud"
      version = "1.33.1"
    }
  }
}

provider "hcloud" {
  token = var.hcloud_token
}

resource "hcloud_ssh_key" "default" {
  name       = "p9mk ssh pub key"
  public_key = file("./ssh.pub")
}

resource "hcloud_server" "p9mk" {
  name        = "p9mk-master"
  image       = "ubuntu-20.04"
  server_type = "cx41" # cx41 is the bare minimum for platform9
  user_data = file("./vm_data.yaml")
  ssh_keys = [hcloud_ssh_key.default.id]
}
