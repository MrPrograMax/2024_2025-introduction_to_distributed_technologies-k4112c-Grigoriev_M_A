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
lab1-start: ensure-lab1-service wait-for-vault-pod-ready
	minikube kubectl -- port-forward service/vault 8200:8200

.PHONY: ensure-lab1-service
ensure-lab1-service:
	kubectl apply -f lab1/vault.yaml
	@minikube kubectl -- get service vault >/dev/null 2>&1 || \
	minikube kubectl -- expose pod vault --type=NodePort --port=8200

.PHONY: wait-for-vault-pod-ready
wait-for-vault-pod-ready:
	@echo "Waiting for Vault pod to be ready..."
	@until minikube kubectl -- get pods --selector=app=vault -o jsonpath='{.items[0].status.phase}' 2>/dev/null | grep -q 'Running'; do \
		echo "Vault pod is not ready yet. Retrying in 2 seconds..."; \



.PHONY: lab1-logs
lab1-logs:
	kubectl logs pods/vault

.PHONY: lab2-help
lab2-help:
	@echo "Команды для lab2:"
	@echo "<lab2-start> - разворачивает деплоймент в Minikube, проверяет наличие сервиса, настраивает порт-форвардинг"
	@echo "<lab2-logs>  - показывает логи подов"

.PHONY: lab2-start
lab2-start: ensure-lab2-service wait-for-pod-ready
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

.PHONY: wait-for-pod-ready
wait-for-pod-ready:
	@echo "Waiting for pod to be ready..."
	@until minikube kubectl -- get pods --selector=app=lab2service -o jsonpath='{.items[0].status.phase}' 2>/dev/null | grep -q 'Running'; do \
		echo "Pod is not ready yet. Retrying in 2 seconds..."; \
		sleep 2; \
	done
	@echo "Pod is ready!"