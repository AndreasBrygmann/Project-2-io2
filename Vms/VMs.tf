terraform {
    required_providers {
        openstack = {
            source = "terraform-provider-openstack/openstack"
        }
    }
}
# Specifies the provider
provider "openstack" {
    cloud = "openstack" # defined in ~/.config/openstack/clouds.yaml
    
}
# Creates virtual machine Controll Node
resource "openstack_compute_instance_v2" "ControllNode" {
    name = "ControllNode"
    image_name = "ubuntu 22.04-LTS (Jammy Jellyfish)"
    flavor_name = "aem.1c2r.50g"
    key_pair = "newkey"
    security_groups = ["default"]

    network {
    name = "oslomet"
    }
}
# Creates 3 worker nodes
resource "openstack_compute_instance_v2" "Node1" {
    name = "Node1"
    image_name = "ubuntu 22.04-LTS (Jammy Jellyfish)"
    flavor_name = "aem.1c2r.50g"
    key_pair = "newkey"
    security_groups = ["default"]

    network {
    name = "oslomet"
    }
}
resource "openstack_compute_instance_v2" "Node2" {
    name = "Node2"
    image_name = "ubuntu 22.04-LTS (Jammy Jellyfish)"
    flavor_name = "aem.1c2r.50g"
    key_pair = "newkey"
    security_groups = ["default"]

    network {
    name = "oslomet"
    }
}

resource "openstack_compute_instance_v2" "Node3" {
    name = "Node3"
    image_name = "ubuntu 22.04-LTS (Jammy Jellyfish)"
    flavor_name = "aem.1c2r.50g"
    key_pair = "newkey"
    security_groups = ["default"]

    network {
    name = "oslomet"
    }
}

# Creates 3 volumes
resource "openstack_blockstorage_volume_v3" "volume_1" {
  name = "volume_1"
  size = 10
}
resource "openstack_blockstorage_volume_v3" "volume_2" {
  name = "volume_2"
  size = 10
}
resource "openstack_blockstorage_volume_v3" "volume_3" {
  name = "volume_3"
  size = 10
}

# Attaches volumes to worker nodes
resource "openstack_compute_volume_attach_v2" "va_1" {
  instance_id = openstack_compute_instance_v2.Node1.id
  volume_id   = openstack_blockstorage_volume_v3.volume_1.id
}
resource "openstack_compute_volume_attach_v2" "va_2" {
  instance_id = openstack_compute_instance_v2.Node2.id
  volume_id   = openstack_blockstorage_volume_v3.volume_2.id
}
resource "openstack_compute_volume_attach_v2" "va_3" {
  instance_id = openstack_compute_instance_v2.Node3.id
  volume_id   = openstack_blockstorage_volume_v3.volume_3.id
}

# Outputs ip adresses
output "instance_ip_address" {
value = openstack_compute_instance_v2.ControllNode.access_ip_v4
}
output "instance_ip_address2" {
value = openstack_compute_instance_v2.Node1.access_ip_v4
}
output "instance_ip_address2" {
value = openstack_compute_instance_v2.Node2.access_ip_v4
}
output "instance_ip_address2" {
value = openstack_compute_instance_v2.Node3.access_ip_v4
}