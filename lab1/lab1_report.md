University: [ITMO University](https://itmo.ru/ru/) \
Faculty: [FICT](https://fict.itmo.ru) \
Course: [Introduction to distributed technologies](https://github.com/itmo-ict-faculty/introduction-to-distributed-technologies) \
Year: 2024/2025 \
Group: K4112c \
Author: Grigoriev Maxim Alexeyevich \
Lab: Lab1 \
Date of create: 17.12.2024 \
Date of finished: //TODO

## Лабораторная 1

### Описание

Это первая лабораторная работа в которой вы сможете протестировать Docker, установить Minikube и развернуть свой первый "под".

### Цель работы

Ознакомиться с инструментами Minikube и Docker, развернуть свой первый "под".

### Ход выполнения
1. Установлен Docker
2. Установлен Minikube
3. Развернут Minikube кластер
4. По пути `lab/vault.yaml` написан манифест с образом HashiCorp Vault
5. Манифест применен с помощью команды команды  `kubectl apply -f vault.yaml`
6. С помощью команды `minikube kubectl -- expose pod vault --type=NodePort --port=8200`
- Service будет связывать входящий трафик с портом 8200 узла Minikube и перенаправлять его на соответствующий порт Pod.
7. C помощью команды `minikube kubectl -- port-forward service/vault 8200:8200`
- Команда создаёт туннель между локальной машиной и сервисом vault. Т.е локальный порт 8200 становится прокси для доступа к сервису, слушающему порт 8200 внутри Minikube.
8. Для удобства взаимодействия написан Makefile