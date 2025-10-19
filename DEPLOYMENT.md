# Руководство по развертыванию

## Локальная разработка

### Предварительные требования
- Docker Desktop
- Docker Compose
- Git

### Быстрый старт

1. **Клонировать репозиторий:**
```bash
git clone <repo-url>
cd django_platform_plus_rest_api
```

2. **Создать .env файл:**
```bash
cp .env.dev .env
```

3. **Собрать и запустить контейнеры:**
```bash
make build
make up
```

Или используя docker-compose напрямую:
```bash
docker-compose build
docker-compose up -d
```

4. **Применить миграции:**
```bash
make migrate
```

5. **Создать суперпользователя:**
```bash
make createsuperuser
```

6. **Открыть в браузере:**
- Приложение: http://localhost:8000
- Admin панель: http://localhost:8000/admin

### Полезные команды

```bash
# Просмотр логов
make logs

# Вход в shell Django
make shell

# Вход в bash контейнера
make bash

# Создание миграций
make makemigrations

# Применение миграций
make migrate

# Запуск тестов
make test

# Остановка контейнеров
make down

# Полная очистка
make clean
```

## Production развертывание

### Подготовка сервера

1. **Установить Docker и Docker Compose на сервере:**
```bash
# Ubuntu/Debian
sudo apt update
sudo apt install docker.io docker-compose
sudo systemctl enable docker
sudo systemctl start docker

# Добавить пользователя в группу docker
sudo usermod -aG docker $USER
```

2. **Клонировать репозиторий:**
```bash
cd /opt
sudo git clone <repo-url> django-app
cd django-app
```

3. **Создать .env.prod файл:**
```bash
cp .env.prod.example .env.prod
# Отредактировать файл с реальными настройками
nano .env.prod
```

**Важно:** Обязательно измените:
- `SECRET_KEY` - используйте криптографически стойкий ключ
- `DB_PASSWORD` и `POSTGRES_PASSWORD` - используйте надежные пароли
- `ALLOWED_HOSTS` - укажите ваш домен
- Все другие чувствительные данные

4. **Настроить SSL сертификаты:**
```bash
# Если используете Let's Encrypt
sudo apt install certbot
sudo certbot certonly --standalone -d yourdomain.com -d www.yourdomain.com

# Скопировать сертификаты в проект
sudo mkdir -p /opt/django-app/nginx/ssl
sudo cp /etc/letsencrypt/live/yourdomain.com/fullchain.pem /opt/django-app/nginx/ssl/cert.pem
sudo cp /etc/letsencrypt/live/yourdomain.com/privkey.pem /opt/django-app/nginx/ssl/key.pem
```

5. **Раскомментировать SSL настройки в nginx/nginx.prod.conf:**
```nginx
ssl_certificate /etc/nginx/ssl/cert.pem;
ssl_certificate_key /etc/nginx/ssl/key.pem;
```

6. **Запустить production контейнеры:**
```bash
docker-compose -f docker-compose.prod.yml build
docker-compose -f docker-compose.prod.yml up -d
```

7. **Применить миграции:**
```bash
docker-compose -f docker-compose.prod.yml exec web python manage.py migrate
```

8. **Создать суперпользователя:**
```bash
docker-compose -f docker-compose.prod.yml exec web python manage.py createsuperuser
```

## CI/CD с GitHub Actions

### Настройка GitHub Secrets

Перейдите в Settings → Secrets and variables → Actions и добавьте:

#### Для Development окружения:
- `DEV_HOST` - IP адрес или домен dev сервера
- `DEV_USERNAME` - имя пользователя SSH
- `DEV_SSH_KEY` - приватный SSH ключ для доступа

#### Для Production окружения:
- `PROD_HOST` - IP адрес или домен production сервера
- `PROD_USERNAME` - имя пользователя SSH
- `PROD_SSH_KEY` - приватный SSH ключ для доступа

#### Опционально:
- `SLACK_WEBHOOK` - webhook URL для уведомлений в Slack

### Настройка GitHub Environments

1. Перейдите в Settings → Environments
2. Создайте два окружения: `development` и `production`
3. Для production настройте:
   - Required reviewers (кто должен одобрять деплой)
   - Deployment branches (только main)

### Процесс развертывания

#### Development:
1. Push в ветку `develop` триггерит:
   - Запуск тестов
   - Сборку Docker образа
   - Автоматический деплой на dev сервер

#### Production:
1. Push в ветку `main` триггерит:
   - Запуск тестов
   - Сборку Docker образа
   - Деплой на production (может требовать одобрения)
   - Health check
   - Уведомление в Slack

### Workflow структура

```
Push → Tests → Build Image → Push to Registry → Deploy → Health Check
```

## Мониторинг и логи

### Просмотр логов:
```bash
# Все сервисы
docker-compose -f docker-compose.prod.yml logs -f

# Только Django
docker-compose -f docker-compose.prod.yml logs -f web

# Только Nginx
docker-compose -f docker-compose.prod.yml logs -f nginx

# Только База данных
docker-compose -f docker-compose.prod.yml logs -f db
```

### Проверка статуса:
```bash
docker-compose -f docker-compose.prod.yml ps
```

## Резервное копирование

### Backup базы данных:
```bash
docker-compose -f docker-compose.prod.yml exec db pg_dump -U django_prod_user django_prod_db > backup_$(date +%Y%m%d_%H%M%S).sql
```

### Restore базы данных:
```bash
cat backup_20240101_120000.sql | docker-compose -f docker-compose.prod.yml exec -T db psql -U django_prod_user django_prod_db
```

## Обновление приложения

### Ручное обновление:
```bash
cd /opt/django-app
git pull origin main
docker-compose -f docker-compose.prod.yml pull
docker-compose -f docker-compose.prod.yml up -d
docker-compose -f docker-compose.prod.yml exec web python manage.py migrate
docker-compose -f docker-compose.prod.yml exec web python manage.py collectstatic --noinput
```

### Автоматическое через CI/CD:
Просто push в нужную ветку (main/develop)

## Troubleshooting

### Контейнер не запускается:
```bash
docker-compose logs web
docker-compose ps
```

### Проблемы с правами доступа:
```bash
sudo chown -R 1000:1000 /opt/django-app
```

### Очистка старых образов:
```bash
docker image prune -a
docker system prune -a
```

### Перезапуск без даунтайма:
```bash
docker-compose -f docker-compose.prod.yml up -d --no-deps --build web
```

## Безопасность

1. **Всегда используйте сильные пароли**
2. **Храните .env файлы в безопасности** (не коммитьте в git)
3. **Регулярно обновляйте зависимости**
4. **Настройте firewall:**
```bash
sudo ufw allow 22/tcp
sudo ufw allow 80/tcp
sudo ufw allow 443/tcp
sudo ufw enable
```
5. **Настройте автоматическое обновление SSL сертификатов:**
```bash
sudo crontab -e
# Добавить:
0 0 1 * * certbot renew --quiet
```

## Масштабирование

### Увеличение числа workers:
В `docker-compose.prod.yml`:
```yaml
web:
  deploy:
    replicas: 3
```

### Использование внешней базы данных:
Измените `DB_HOST` в `.env.prod` на внешний хост БД

## Контакты и поддержка

При возникновении проблем создайте issue в GitHub репозитории.

