resource "yandex_vpc_network" "test-net" {
  name = var.vpc_name
}
resource "yandex_vpc_subnet" "test-net" {
  name           = var.vpc_name
  zone           = var.default_zone
  network_id     = yandex_vpc_network.test-net.id
  v4_cidr_blocks = var.default_cidr
}

## normal image
data "yandex_compute_image" "image_src" {
  family = var.vms_common_options.image_family
}

## docker image
data "yandex_compute_image" "container-optimized-image" {
  family = "container-optimized-image"
}

## TC-server instance
resource "yandex_compute_instance" "tc-server" {
  boot_disk {
    initialize_params {
      image_id = data.yandex_compute_image.container-optimized-image.id
    }
  }
  network_interface {
    subnet_id = yandex_vpc_subnet.test-net.id
    nat = var.vms_common_options.net_nat
  }
  resources {
    cores = 4
    memory = 4
    core_fraction = var.vms_common_options.cores_fraction
  }
  metadata = {
    docker-container-declaration = file("${path.module}/declaration-tcserver.yaml")
    user-data          = data.template_file.cloudinit.rendered
    serial-port-enable = var.vms_common_options.meta_serial-port-enable
  }
}

## TC-agent instance
resource "yandex_compute_instance" "tc-agent" {
  boot_disk {
    initialize_params {
      image_id = data.yandex_compute_image.container-optimized-image.id
    }
  }
  network_interface {
    subnet_id = yandex_vpc_subnet.test-net.id
    nat = var.vms_common_options.net_nat
  }
  resources {
    cores = 2
    memory = 4
    core_fraction = var.vms_common_options.cores_fraction
  }
  metadata = {
    docker-container-declaration = data.template_file.declaration_tcagent.rendered
    user-data          = data.template_file.cloudinit.rendered
    serial-port-enable = var.vms_common_options.meta_serial-port-enable
  }
}

## Nexus node
resource "yandex_compute_instance" "test" {
  count = length(var.vm_names)
  name        = var.vm_names[count.index]
  platform_id = var.vms_common_options.platform
  hostname    = var.vm_names[count.index]
  resources {
    cores         = var.vms_common_options.cores
    memory        = var.vms_common_options.memory
    core_fraction = var.vms_common_options.cores_fraction
  }

  boot_disk {
    initialize_params {
      image_id = data.yandex_compute_image.image_src.image_id
      size     = var.vms_common_options.boot_disk_size

    }
  }
  scheduling_policy {
    preemptible = var.vms_common_options.preemptible
  }

  network_interface {
    subnet_id = yandex_vpc_subnet.test-net.id
    nat       = var.vms_common_options.net_nat
  }

  metadata = {
    user-data          = data.template_file.cloudinit.rendered
    serial-port-enable = var.vms_common_options.meta_serial-port-enable
  }

}

data "template_file" "declaration_tcagent" {
  template = file("./declaration-tcagent.yaml")
  vars = {
    tcserver_host        = yandex_compute_instance.tc-server.network_interface[0].nat_ip_address

  }
}

data "template_file" "cloudinit" {
  template = file("./cloud-init.yml")
  vars = {
    username        = var.vms_ssh_user
    ssh_public_key  = local.vms_ssh_root_key

  }
}

output "ansible_hosts" {
  value = {
  for v in range(0, length(var.vm_names)) : var.vm_names[v] => yandex_compute_instance.test[v].network_interface[0].nat_ip_address
  }
}

output "tcserver_host" {
  value = {
    tcserver = yandex_compute_instance.tc-server.network_interface[0].nat_ip_address
  }
}

output "tcagent_host" {
  value = {
    tcagent = yandex_compute_instance.tc-agent.network_interface[0].nat_ip_address
  }
}

