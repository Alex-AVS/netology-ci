resource "yandex_vpc_network" "test-net" {
  name = var.vpc_name
}
resource "yandex_vpc_subnet" "test-net" {
  name           = var.vpc_name
  zone           = var.default_zone
  network_id     = yandex_vpc_network.test-net.id
  v4_cidr_blocks = var.default_cidr
}

data "yandex_compute_image" "image_src" {
  family = var.vms_common_options.image_family
}


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

data "template_file" "cloudinit" {
  template = file("./cloud-init.yml")
  vars = {
    username        = var.vms_ssh_user
    ssh_public_key  = local.vms_ssh_root_key

  }
}

output "ansible_hosts" {
  value = {
      for v in range(0,length(var.vm_names)): var.vm_names[v] => yandex_compute_instance.test[v].network_interface[0].nat_ip_address
  }
}