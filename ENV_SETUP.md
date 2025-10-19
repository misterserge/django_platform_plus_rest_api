# Настройка переменных окружения

## Создание .env файлов

### Для локальной разработки

Создайте файл `.env` в корне проекта:

```bash
# Django Settings
SECRET_KEY=django-insecure-dev-key-change-in-production
DEBUG=True
DJANGO_ENV=development
ALLOWED_HOSTS=localhost,127.0.0.1

# Database Settings (SQLite для простоты)
DB_ENGINE=django.db.backends.sqlite3
DB_NAME=db.sqlite3
DB_USER=
DB_PASSWORD=
DB_HOST=
DB_PORT=

# Static and Media Files
STATIC_URL=/static/
STATIC_ROOT=/app/staticfiles
MEDIA_URL=/media/
MEDIA_ROOT=/app/mediafiles

# Security Settings
SECURE_SSL_REDIRECT=False
SESSION_COOKIE_SECURE=False
CSRF_COOKIE_SECURE=False
SECURE_HSTS_SECONDS=0
```

### Для локальной разработки с PostgreSQL

Создайте файл `.env`:

```bash
# Django Settings
SECRET_KEY=django-insecure-dev-key-change-in-production
DEBUG=True
DJANGO_ENV=development
ALLOWED_HOSTS=localhost,127.0.0.1

# Database Settings (PostgreSQL)
DB_ENGINE=django.db.backends.postgresql
DB_NAME=django_db
DB_USER=django_user
DB_PASSWORD=django_password
DB_HOST=db
DB_PORT=5432

# Static and Media Files
STATIC_URL=/static/
STATIC_ROOT=/app/staticfiles
MEDIA_URL=/media/
MEDIA_ROOT=/app/mediafiles

# Security Settings
SECURE_SSL_REDIRECT=False
SESSION_COOKIE_SECURE=False
CSRF_COOKIE_SECURE=False
SECURE_HSTS_SECONDS=0
```

### Для Production

Создайте файл `.env.prod` на production сервере:

```bash
# Django Settings
SECRET_KEY=ГЕНЕРИРУЙТЕ_НАДЕЖНЫЙ_КЛЮЧ_ЗДЕСЬ
DEBUG=False
DJANGO_ENV=production
ALLOWED_HOSTS=yourdomain.com,www.yourdomain.com

# Database Settings (PostgreSQL)
DB_ENGINE=django.db.backends.postgresql
DB_NAME=django_prod_db
DB_USER=django_prod_user
DB_PASSWORD=НАДЕЖНЫЙ_ПАРОЛЬ_БД
DB_HOST=db
DB_PORT=5432

# PostgreSQL Settings (для docker-compose)
POSTGRES_DB=django_prod_db
POSTGRES_USER=django_prod_user
POSTGRES_PASSWORD=НАДЕЖНЫЙ_ПАРОЛЬ_БД

# Static and Media Files
STATIC_URL=/static/
STATIC_ROOT=/app/staticfiles
MEDIA_URL=/media/
MEDIA_ROOT=/app/mediafiles

# Security Settings
SECURE_SSL_REDIRECT=True
SESSION_COOKIE_SECURE=True
CSRF_COOKIE_SECURE=True
SECURE_HSTS_SECONDS=31536000
```

## Генерация SECRET_KEY

### Python способ:
```python
from django.core.management.utils import get_random_secret_key
print(get_random_secret_key())
```

### Командная строка:
```bash
python -c 'from django.core.management.utils import get_random_secret_key; print(get_random_secret_key())'
```

### Онлайн (не для production!):
```bash
openssl rand -base64 64
```

## Важные замечания

1. **Никогда не коммитьте .env файлы в git!** Они уже добавлены в .gitignore

2. **Для production обязательно:**
   - Используйте сильный SECRET_KEY (минимум 50 символов)
   - Установите DEBUG=False
   - Используйте надежные пароли БД
   - Укажите правильные ALLOWED_HOSTS
   - Включите SSL настройки

3. **Проверка настроек:**
```bash
# Проверка Django
python manage.py check --deploy

# Проверка переменных окружения
python manage.py shell
>>> from django.conf import settings
>>> print(settings.DEBUG)
>>> print(settings.SECRET_KEY)
```

## Переменные окружения в Docker

Docker Compose автоматически читает `.env` файл из корня проекта.

Для production используйте:
```bash
docker-compose -f docker-compose.prod.yml --env-file .env.prod up -d
```

## Переменные в GitHub Actions

Для CI/CD настройте GitHub Secrets:

1. Перейдите в Settings → Secrets and variables → Actions
2. Добавьте необходимые secrets:
   - `DEV_HOST`
   - `DEV_USERNAME`
   - `DEV_SSH_KEY`
   - `PROD_HOST`
   - `PROD_USERNAME`
   - `PROD_SSH_KEY`
   - `SLACK_WEBHOOK` (опционально)

## Безопасность

### Рекомендации:
- ✅ Используйте разные SECRET_KEY для dev/prod
- ✅ Используйте разные пароли БД для dev/prod
- ✅ Храните .env файлы только на серверах
- ✅ Ограничьте доступ к .env файлам: `chmod 600 .env`
- ✅ Регулярно ротируйте секреты
- ✅ Используйте vault системы для критичных данных (AWS Secrets Manager, HashiCorp Vault)

### Что НЕ делать:
- ❌ Не коммитьте .env в git
- ❌ Не используйте слабые пароли
- ❌ Не используйте одинаковые секреты для dev/prod
- ❌ Не отправляйте .env файлы по email/slack
- ❌ Не храните .env в публичных местах

## Troubleshooting

### Ошибка "ImproperlyConfigured"
Убедитесь что .env файл существует и правильно настроен:
```bash
ls -la .env
cat .env
```

### Переменные не загружаются
Проверьте что python-decouple установлен:
```bash
pip install python-decouple
```

### Docker не видит .env
Убедитесь что .env файл в корне проекта (рядом с docker-compose.yml):
```bash
pwd
ls -la | grep .env
```

