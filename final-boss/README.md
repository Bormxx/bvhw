## Развёртывание проекта Taski в кластер Yandex.Cloud с помощью Kubernetes.

### Составные части проекта.

Проект состоит из двух частей:
- K8s-кластер в облаке Yandex.Cloud.
- Проект [Taski](https://github.com/yandex-praktikum/taski).

### Используемый стек.

В проекте реализован следующий программный стек:
- Docker.
- Kubernetes.
- Terraform.

### Порядок реализации проекта

Необходимо следовать следующему порядку:
1. Создать кластер в облаке Yandex.Cloud.
Для этого предназначен каталог [k8s-terraform](https://github.com/Bormxx/bvhw/tree/main/final-boss/k8s-terraform).

2. Развернуть в кластере k8s docker-контейнеры проекта Taski.
Для этого предназначен каталог [Taski](https://github.com/Bormxx/bvhw/tree/main/final-boss/taski).

В каждом каталоге проекта есть файл README.md с подробной инструкцией.

### Реализован CI/CD для развёрнутой в Yandex.Cloud виртуальной машины Compute Cloud.
В файле deploy.yaml указан внешний динамический адрес, который необходимо менять на актуальный.

Github Actions настроен на реакцию в случае push в директории frontend и backend.
Удаляются существующие контейнеры, всё очищается и создаются новые.
