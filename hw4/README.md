## Kubernetes. Создание pods.
### Задание: создать и запустить pods с помощью kubectl.
В данном задании я использовал кластер minicube, выполнив команду:
minicube start

Я использовал docker-образ httpd.

### Запуск производить с помощью команды:
kubectl apply -f minipoda.yaml

### После запуска сделайте перенаправление порта с помощью команды:
kubectl port-forward webserver 8000:80

### Наглядную проверку выполните в браузере, открыв страницу с адресом:
http://localhost:8000