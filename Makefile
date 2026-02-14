# 🟢🟡 Mechama PDV - Makefile
# Comandos úteis para desenvolvimento e deploy

.PHONY: help install dev build up down logs shell test clean

# Default target
.DEFAULT_GOAL := help

help: ## Mostra esta ajuda
	@echo "🟢🟡 Mechama PDV - Comandos disponíveis:"
	@grep -E '^[a-zA-Z_-]+:.*?## .*$$' $(MAKEFILE_LIST) | sort | awk 'BEGIN {FS = ":.*?## "}; {printf "  \033[36m%-20s\033[0m %s\n", $$1, $$2}'

# ============================================
# Desenvolvimento
# ============================================

install: ## Instala dependências do frontend
	cd frontend && npm install

dev: ## Inicia ambiente de desenvolvimento
	docker-compose up -d db redis
	@echo "⏳ Aguardando banco de dados..."
	@sleep 5
	cd backend && python -m venv venv && source venv/bin/activate && pip install -r requirements.txt
	@echo "✅ Backend pronto!"
	@echo "Inicie o backend: cd backend && uvicorn app.main:app --reload"
	@echo "Inicie o frontend: cd frontend && npm run dev"

# ============================================
# Docker
# ============================================

up: ## Inicia todos os serviços
	docker-compose up -d

up-complete: ## Inicia com WhatsApp
	docker-compose --profile completo up -d

up-prod: ## Inicia em modo produção
	docker-compose --profile producao up -d

down: ## Para todos os serviços
	docker-compose down

down-volumes: ## Para e remove volumes (CUIDADO: apaga dados!)
	docker-compose down -v

logs: ## Mostra logs de todos os serviços
	docker-compose logs -f

logs-backend: ## Logs do backend
	docker-compose logs -f backend

logs-frontend: ## Logs do frontend
	docker-compose logs -f frontend

logs-db: ## Logs do banco de dados
	docker-compose logs -f db

# ============================================
# Banco de Dados
# ============================================

db-shell: ## Acessa shell do PostgreSQL
	docker-compose exec db psql -U mechama -d mechama_pdv

db-backup: ## Faz backup do banco
	@mkdir -p backups
	docker-compose exec db pg_dump -U mechama mechama_pdv > backups/mechama_pdv_$$(date +%Y%m%d_%H%M%S).sql
	@echo "✅ Backup criado em backups/"

db-restore: ## Restaura backup (use: make db-restore FILE=backups/arquivo.sql)
	@if [ -z "$(FILE)" ]; then echo "❌ Especifique o arquivo: make db-restore FILE=backups/arquivo.sql"; exit 1; fi
	docker-compose exec -T db psql -U mechama -d mechama_pdv < $(FILE)
	@echo "✅ Backup restaurado!"

# ============================================
# Backend
# ============================================

backend-shell: ## Acessa shell do backend
	docker-compose exec backend sh

backend-logs: ## Logs do backend
	docker-compose logs -f backend

backend-restart: ## Reinicia o backend
	docker-compose restart backend

# ============================================
# Frontend
# ============================================

frontend-build: ## Build do frontend para produção
	cd frontend && npm run build

frontend-shell: ## Acessa shell do frontend
	docker-compose exec frontend sh

# ============================================
# WhatsApp (Evolution API)
# ============================================

whatsapp-up: ## Inicia serviço de WhatsApp
	docker-compose --profile whatsapp up -d evolution-api

whatsapp-logs: ## Logs do WhatsApp
	docker-compose logs -f evolution-api

whatsapp-status: ## Verifica status da Evolution API
	@curl -s http://localhost:8080 | head -20

# ============================================
# Testes
# ============================================

test: ## Executa testes do backend
	cd backend && pytest -v

test-coverage: ## Executa testes com cobertura
	cd backend && pytest --cov=app --cov-report=html

# ============================================
# Manutenção
# ============================================

clean: ## Limpa containers e imagens não utilizados
	docker system prune -f

clean-all: ## Limpa tudo incluindo volumes (CUIDADO!)
	docker-compose down -v
	docker system prune -af
	docker volume prune -f

update: ## Atualiza imagens Docker
	docker-compose pull
	docker-compose up -d

# ============================================
# Deploy
# ============================================

deploy-prod: ## Deploy em produção
	@echo "🚀 Iniciando deploy em produção..."
	docker-compose --profile producao up -d --build
	@echo "✅ Deploy concluído!"

# ============================================
# Utilitários
# ============================================

status: ## Status dos serviços
	@docker-compose ps

ports: ## Mostra portas em uso
	@echo "Portas do Mechama PDV:"
	@echo "  Frontend: http://localhost:5173"
	@echo "  Backend API: http://localhost:8000"
	@echo "  API Docs: http://localhost:8000/docs"
	@echo "  PostgreSQL: localhost:5432"
	@echo "  Redis: localhost:6379"
	@echo "  Evolution API: http://localhost:8080"

version: ## Mostra versões
	@echo "Mechama PDV"
	@docker --version
	@docker-compose --version
