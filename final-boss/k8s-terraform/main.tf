terraform {
  required_providers {
    yandex   = {
      source = "yandex-cloud/yandex"
    }
  }
  required_version = ">= 0.13"
}

provider "yandex" {
  zone      = var.zone
  token     = var.token
  cloud_id  = var.cloud_id
  folder_id = var.folder_id
}

module "yc-vpc" {
  source              = "github.com/terraform-yc-modules/terraform-yc-vpc.git"
  network_name        = "test-module-network"
  network_description = "Test network created with module"
  private_subnets = [{
    name           = "subnet-1"
    zone           = "ru-central1-a"
    v4_cidr_blocks = ["10.10.0.0/24"]
  },
  {
    name           = "subnet-2"
    zone           = "ru-central1-b"
    v4_cidr_blocks = ["10.11.0.0/24"]
  },
  {
    name           = "subnet-3"
    zone           = "ru-central1-d"
    v4_cidr_blocks = ["10.12.0.0/24"]
  }
  ]
}

resource "yandex_kubernetes_cluster" "k8s-cluster-zonal" {
  name = "k8s-cluster-zonal" # <-- Это имя кластера. Можете его изменить.
  description = "Какое-то описание кластера."
  network_id = "${module.yc-vpc.vpc_id}"
  service_account_id       = var.service_account_id
  node_service_account_id  = var.node_service_account_id
  release_channel          = "REGULAR"
  master {
    public_ip = true
    security_group_ids = [yandex_vpc_security_group.k8s-public-services.id]
    master_location {
      zone      = yandex_vpc_subnet.mysubnet.zone
      subnet_id = yandex_vpc_subnet.mysubnet.id
    }
  }
  kms_provider {
    key_id = yandex_kms_symmetric_key.kms-key.id
  }
  depends_on = [ module.yc-vpc ]
}

resource "yandex_kubernetes_node_group" "k8s-node-group" {
  name        = "k8s-node-group"
  description = "Test node group"
  cluster_id  = yandex_kubernetes_cluster.k8s-cluster-zonal.id
  version     = "1.28"
  instance_template {
    name = "test-{instance.short_id}-{instance_group.id}"
    platform_id = "standard-v3"
    resources {
      cores         = 4
      core_fraction = 50
      memory        = 4
    }
    boot_disk {
      size = 32
      type = "network-hdd"
    }
    network_acceleration_type = "standard"
    network_interface {
      security_group_ids = [yandex_vpc_security_group.k8s-public-services.id]
      subnet_ids         = [yandex_vpc_subnet.mysubnet.id]
      nat                = true
    }
    scheduling_policy {
      preemptible = true
    }
  }
  scale_policy {
    auto_scale {
      min     = 1
      max     = 4
      initial = 1
    }
  }
  deploy_policy {
    max_expansion   = 1
    max_unavailable = 1
  }
  maintenance_policy {
    auto_upgrade = true
    auto_repair  = true
    maintenance_window {
      start_time = "22:00"
      duration   = "10h"
    }
  }
  node_labels = {
    node-label1 = "node-value1"
  }
  # node_taints = ["taint1=taint-value1:NoSchedule"] # Уберём, иначе kubectl не сможет развернуть ноду.
  labels = {
    "template-label1" = "template-value1"
  }
  allowed_unsafe_sysctls = ["kernel.msg*", "net.core.somaxconn"]

  depends_on = [ # Подождём, пока кластер стартанёт.
    yandex_kubernetes_cluster.k8s-cluster-zonal
  ]
}

resource "yandex_vpc_subnet" "mysubnet" {
  name = "mysubnet"
  v4_cidr_blocks = ["10.1.0.0/16"]
  zone           = "ru-central1-a"
  network_id     = "${module.yc-vpc.vpc_id}"
}

resource "yandex_kms_symmetric_key" "kms-key" {
  # Ключ Yandex Key Management Service для шифрования важной информации, такой как пароли, OAuth-токены и SSH-ключи.
  name              = "kms-key"
  default_algorithm = "AES_128"
  rotation_period   = "8760h" # 1 год.
}

resource "yandex_vpc_security_group" "k8s-public-services" {
  name        = "k8s-public-services"
  description = "Правила группы разрешают подключение к сервисам из интернета. Примените правила только для групп узлов."
  network_id  = "${module.yc-vpc.vpc_id}"
  ingress {
    protocol = "ANY"
    v4_cidr_blocks    = ["0.0.0.0/0"]
    from_port = 0
    to_port = 65535
  }

  egress {
    protocol          = "ANY"
    description       = "Правило разрешает весь исходящий трафик. Узлы могут связаться с Yandex Container Registry, Yandex Object Storage, Docker Hub и т. д."
    v4_cidr_blocks    = ["0.0.0.0/0"]
    from_port         = 0
    to_port           = 65535
  }
}
