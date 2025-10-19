# Django Platform + REST API

Полноценный Django проект с Docker контейнеризацией и CI/CD pipeline.

## 🚀 Быстрый старт

### Локальная разработка

1. **Клонировать репозиторий:**
```bash
git clone <repo-url>
cd django_platform_plus_rest_api
```

2. **Создать .env файл:**
```bash
cp .env.dev .env
# Или для локальной разработки без Docker:
# cp .env.example .env
```

3. **Запустить с Docker:**
```bash
make build
make up
make migrate
make createsuperuser
```

4. **Открыть:** http://localhost:8000

### Production развертывание

Детальная инструкция в [DEPLOYMENT.md](DEPLOYMENT.md)

```bash
docker-compose -f docker-compose.prod.yml up -d
```

## 📦 Стек технологий

- **Backend:** Django 5.2.7
- **Python:** 3.13
- **Database:** PostgreSQL 16 (SQLite для разработки)
- **Web Server:** Nginx
- **WSGI:** Gunicorn
- **Containerization:** Docker, Docker Compose
- **CI/CD:** GitHub Actions

## 🛠 Структура проекта

```
.
├── base/                   # Django настройки
├── nginx/                  # Nginx конфигурация
├── .github/workflows/      # CI/CD pipeline
├── Dockerfile             # Docker образ
├── docker-compose.yml     # Dev окружение
├── docker-compose.prod.yml # Prod окружение
├── Makefile               # Полезные команды
└── DEPLOYMENT.md          # Руководство по развертыванию
```

## 📝 Полезные команды

```bash
# Docker управление
make build              # Собрать образ
make up                 # Запустить контейнеры
make down               # Остановить контейнеры
make logs               # Просмотр логов
make restart            # Перезапуск

# Django команды
make migrate            # Применить миграции
make makemigrations     # Создать миграции
make shell              # Django shell
make createsuperuser    # Создать суперпользователя
make test               # Запустить тесты

# Утилиты
make clean              # Очистка контейнеров
make rebuild            # Пересборка с нуля
```

## 🔄 CI/CD Pipeline

### Development
- Push в `develop` → автоматический деплой на dev сервер
- Включает: тесты, сборка образа, деплой

### Production  
- Push в `main` → деплой на production
- Включает: тесты, сборка образа, деплой, health check, уведомления

### Настройка GitHub Secrets

Добавьте в Settings → Secrets:
- `DEV_HOST`, `DEV_USERNAME`, `DEV_SSH_KEY`
- `PROD_HOST`, `PROD_USERNAME`, `PROD_SSH_KEY`
- `SLACK_WEBHOOK` (опционально)

## 🔒 Безопасность

- Все sensitive данные в `.env` файлах
- SSL/TLS в production
- Security headers в Nginx
- Django security settings для production
- Контейнеры запускаются от непривилегированного пользователя

## 📚 Документация

- [Руководство по развертыванию](DEPLOYMENT.md)
- [Django документация](https://docs.djangoproject.com/)
- [Docker документация](https://docs.docker.com/)

## 🤝 Разработка

1. Создайте feature ветку
2. Внесите изменения
3. Запустите тесты: `make test`
4. Создайте Pull Request в `develop`

## 📄 Лицензия

MIT License

## ✨ Особенности

- ✅ Multi-stage Docker build для оптимизации размера
- ✅ Separate dev/prod конфигурации
- ✅ Автоматические миграции при старте
- ✅ Health checks
- ✅ Логирование
- ✅ Static/Media files handling
- ✅ PostgreSQL для production
- ✅ Nginx reverse proxy
- ✅ CI/CD с GitHub Actions
- ✅ Удобный Makefile

## 🐛 Troubleshooting

### Контейнер не запускается
```bash
docker-compose logs web
```

### Проблемы с БД
```bash
docker-compose down -v  # Удалит volumes
make rebuild
```

### Права доступа
```bash
sudo chown -R 1000:1000 .
```

Больше информации в [DEPLOYMENT.md](DEPLOYMENT.md)
