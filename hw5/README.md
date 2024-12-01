## Kubernetes. Deployment, Autoscaling, Service.
### Задание: Настроить Deployment, Autoscaling, Service.
В данном задании я написал в одном файле k8s-bvhw.yaml манифесты для:
- Deployment
  Запускаются три контейнера (nginx, redis, tomcat).
  Настроена реплика на 2 копии.
  
- Autoscaling
  Происходит масштабирование деплоймента с 1 до 3 копий в случае загрузки процессора или памяти.
  
- Service
  Настроен сервис типа NodePort, в котором присвоены порты: 
  nginx - 30030
  redis - 30031
  tomcat - 30032

### Запуск производить с помощью команды:
kubectl apply -f k8s-bvhw.yaml

### После запуска узнайте ip-адрес кластера миникуба с помощью команды:
kubectl describe svc |grep Endpoints

Выведется что-то вроде этого:
Endpoints:                192.168.49.2:8443
Endpoints:                10.244.0.44:80,10.244.0.45:80
Endpoints:                10.244.0.44:6379,10.244.0.45:6379
Endpoints:                10.244.0.44:8080,10.244.0.45:8080

Первый ip-адрес - это и есть адрес кластера миникуба.
Откройте браузер и в адресной строке напишите http://<ip-адрес миникуба>:<порт сервиса>
Например, в приведённом выше примере адрес миникуба 192.168.49.2, а порт сервиса tomcat - 30032.
Значит, адрес будет следующим: http://192.168.49.2:30032

### Созданные pods, deployment и autoscaling можно посмотреть с помощью команд:
Посмотреть pods:
kubectl get pods
kubectl describe pods

Посмотреть deployments:
kubectl get deployments
kubectl describe deployments

Посмотреть autoscaling:
kubectl get hpa
kubectl describe hpa
