# ⚡ Быстрый старт за 5 минут

## 🚀 Локальная разработка (с Docker)

```bash
# 1. Клонируем репозиторий
git clone <repo-url>
cd django_platform_plus_rest_api

# 2. Создаем .env файл (для SQLite - простейший вариант)
cat > .env << 'EOF'
SECRET_KEY=django-insecure-dev-key-for-local-only
DEBUG=True
DJANGO_ENV=development
ALLOWED_HOSTS=localhost,127.0.0.1
DB_ENGINE=django.db.backends.sqlite3
DB_NAME=db.sqlite3
STATIC_URL=/static/
STATIC_ROOT=/app/staticfiles
MEDIA_URL=/media/
MEDIA_ROOT=/app/mediafiles
EOF

# 3. Запускаем Docker
make build
make up

# 4. Применяем миграции
make migrate

# 5. Создаем суперпользователя
make createsuperuser

# 6. Готово! 🎉
# Открываем http://localhost:8000
```

## 🐳 Альтернатива без Makefile

```bash
docker-compose build
docker-compose up -d
docker-compose exec web python manage.py migrate
docker-compose exec web python manage.py createsuperuser
```

## 💻 Локальная разработка (без Docker)

```bash
# 1. Создаем виртуальное окружение
python -m venv venv
source venv/bin/activate  # на Windows: venv\Scripts\activate

# 2. Устанавливаем зависимости
pip install pipenv
pipenv install

# 3. Создаем .env файл
cat > .env << 'EOF'
SECRET_KEY=django-insecure-dev-key-for-local-only
DEBUG=True
DJANGO_ENV=development
ALLOWED_HOSTS=localhost,127.0.0.1
DB_ENGINE=django.db.backends.sqlite3
DB_NAME=db.sqlite3
EOF

# 4. Применяем миграции
python manage.py migrate

# 5. Создаем суперпользователя
python manage.py createsuperuser

# 6. Запускаем сервер
python manage.py runserver

# 7. Открываем http://localhost:8000
```

## 📦 С PostgreSQL (рекомендуется)

```bash
# 1. Создаем .env файл с PostgreSQL
cat > .env << 'EOF'
SECRET_KEY=django-insecure-dev-key-for-local-only
DEBUG=True
DJANGO_ENV=development
ALLOWED_HOSTS=localhost,127.0.0.1
DB_ENGINE=django.db.backends.postgresql
DB_NAME=django_db
DB_USER=django_user
DB_PASSWORD=django_password
DB_HOST=db
DB_PORT=5432
STATIC_URL=/static/
STATIC_ROOT=/app/staticfiles
MEDIA_URL=/media/
MEDIA_ROOT=/app/mediafiles
EOF

# 2. Запускаем все через docker-compose
make build
make up
make migrate
make createsuperuser
```

## 🔥 Production (самый простой способ)

```bash
# На production сервере

# 1. Клонируем репозиторий
cd /opt
sudo git clone <repo-url> django-app
cd django-app

# 2. Генерируем SECRET_KEY
python generate_secret_key.py

# 3. Создаем .env.prod с реальными данными
sudo nano .env.prod
# Вставляем настройки из ENV_SETUP.md

# 4. Запускаем
docker-compose -f docker-compose.prod.yml build
docker-compose -f docker-compose.prod.yml up -d
docker-compose -f docker-compose.prod.yml exec web python manage.py migrate
docker-compose -f docker-compose.prod.yml exec web python manage.py createsuperuser

# 5. Готово! 🎉
```

## 📋 Полезные команды

```bash
# Логи
make logs

# Django shell
make shell

# Bash в контейнере
make bash

# Остановить
make down

# Перезапустить
make restart

# Очистить все
make clean

# Тесты
make test
```

## ❓ Проблемы?

### Порт 8000 занят
```bash
# Найти и убить процесс
lsof -ti:8000 | xargs kill -9
```

### Контейнер не запускается
```bash
make logs
docker-compose ps
```

### Нужен другой порт
Измените в `docker-compose.yml`:
```yaml
ports:
  - "3000:8000"  # локальный:контейнер
```

### База данных не доступна
```bash
make down
make build
make up
```

## 📚 Подробнее

- **Полная документация:** [README.md](README.md)
- **Развертывание:** [DEPLOYMENT.md](DEPLOYMENT.md)
- **Настройка .env:** [ENV_SETUP.md](ENV_SETUP.md)

## 🎯 Следующие шаги

1. ✅ Создайте свое Django приложение: `make bash` → `python manage.py startapp myapp`
2. ✅ Добавьте его в `INSTALLED_APPS` в `base/settings.py`
3. ✅ Создайте модели, views, urls
4. ✅ `make makemigrations` и `make migrate`
5. ✅ Разрабатывайте! 🚀

---

**Готово за 5 минут? Теперь можно начинать разработку! 🎉**

