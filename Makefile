.PHONY: help build up down restart logs shell migrate makemigrations createsuperuser test clean

help:
	@echo "Django Docker Commands:"
	@echo "  make build              - Собрать Docker образ"
	@echo "  make up                 - Запустить контейнеры (dev)"
	@echo "  make up-prod            - Запустить контейнеры (production)"
	@echo "  make down               - Остановить контейнеры"
	@echo "  make restart            - Перезапустить контейнеры"
	@echo "  make logs               - Показать логи"
	@echo "  make shell              - Войти в shell Django"
	@echo "  make migrate            - Запустить миграции"
	@echo "  make makemigrations     - Создать миграции"
	@echo "  make createsuperuser    - Создать суперпользователя"
	@echo "  make test               - Запустить тесты"
	@echo "  make clean              - Очистить контейнеры и volumes"

build:
	docker-compose build

up:
	docker-compose up -d
	@echo "Приложение доступно на http://localhost:8000"

up-prod:
	docker-compose -f docker-compose.prod.yml up -d
	@echo "Production приложение запущено"

down:
	docker-compose down

restart:
	docker-compose restart

logs:
	docker-compose logs -f web

shell:
	docker-compose exec web python manage.py shell

bash:
	docker-compose exec web bash

migrate:
	docker-compose exec web python manage.py migrate

makemigrations:
	docker-compose exec web python manage.py makemigrations

createsuperuser:
	docker-compose exec web python manage.py createsuperuser

collectstatic:
	docker-compose exec web python manage.py collectstatic --noinput

test:
	docker-compose exec web python manage.py test

clean:
	docker-compose down -v
	docker system prune -f

rebuild:
	docker-compose down
	docker-compose build --no-cache
	docker-compose up -d

