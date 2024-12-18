.PHONY: help
help:
	@echo "Общие команды:"
	@echo "<start>     - разворачивает minikube кластер"
	@echo "<stop>      - останавливает minikube кластер"
	@echo "<lab1-help> - команды для лабораторной 1"
	@echo "<lab2-help> - команды для лабораторной 2"

.PHONY: start
start:
	minikube start

.PHONY: stop
stop:
	minikube stop

.PHONY: lab1-help
lab1-help:
	@echo "Команды для lab1:"
	@echo "<lab1-start> - разворачивает pod в Minikube, проверяет наличие сервиса, настраивает порт-форвардинг"
	@echo "<lab1-logs> - показывает логи пода vault"

.PHONY: lab1-start
lab1-start: ensure-lab1-service
	minikube kubectl -- port-forward service/vault 8200:8200

.PHONY: ensure-lab1-service
ensure-lab1-service:
	kubectl apply -f lab1/vault.yaml
	@minikube kubectl -- get service vault >/dev/null 2>&1 || \
	minikube kubectl -- expose pod vault --type=NodePort --port=8200

.PHONY: lab1-logs
lab1-logs:
	kubectl logs pods/vault

.PHONY: lab2-help
lab2-help:
	@echo "Команды для lab2:"
	@echo "<lab2-start> - разворачивает деплоймент в Minikube, проверяет наличие сервиса, настраивает порт-форвардинг"
	@echo "<lab2-logs>  - показывает логи подов"

.PHONY: lab2-start
lab2-start: ensure-lab2-service
	minikube kubectl -- port-forward service/lab2-react-service 3000:3000

.PHONY: ensure-lab2-service
ensure-lab2-service:
	kubectl apply -f lab2/lab2service.yaml
	@minikube kubectl -- get service lab2-react-service >/dev/null 2>&1 || \
	minikube kubectl -- expose deployment lab2service --port=3000 --target-port=3000 --name=lab2-react-service --type=LoadBalancer

.PHONY: lab2-logs
lab2-logs:
	@pods=$$(kubectl get pods -l app=lab2service -o jsonpath='{.items[*].metadata.name}') && \
	for pod in $$pods; do \
		echo "\nLogs for pod: $$pod"; \
		kubectl logs $$pod; \
	done
