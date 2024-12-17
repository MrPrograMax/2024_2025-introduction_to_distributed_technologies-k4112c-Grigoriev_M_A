.PHONY: lab1-help
lab1-help:
	@echo "Команды для lab1:"
	@echo "<minikube-start> - разворачивает minikube кластер"
	@echo "<minikube-stop>  - остонавливает minikube кластер"
	@echo "<init-vault-pod> - разворачивает pod в Minikube, проверяет наличие сервиса, настраивает порт-форвардинг"
	@echo "<vault-logs>     - показывает логи пода vault"

.PHONY: minikube-start
minikube-start:
	minikube start

.PHONY: minikube-stop
minikube-stop:
	minikube stop

.PHONY: init-vault-pod
init-vault-pod: ensure-vault-service
	minikube kubectl -- port-forward service/vault 8200:8200

.PHONY: ensure-vault-service
ensure-vault-service:
	kubectl apply -f lab1/vault.yaml
	@minikube kubectl -- get service vault >/dev/null 2>&1 || \
	minikube kubectl -- expose pod vault --type=NodePort --port=8200

.PHONY: vault-logs
vault-logs:
	kubectl logs pods/vault
