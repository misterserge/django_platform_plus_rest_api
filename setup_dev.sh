#!/bin/bash
# Скрипт для настройки окружения разработки

set -e

echo "🚀 Настройка окружения разработки..."

# Проверка Python
if ! command -v python3 &> /dev/null; then
    echo "❌ Python 3 не установлен!"
    exit 1
fi

echo "✅ Python $(python3 --version) найден"

# Установка pipenv если нужно
if ! command -v pipenv &> /dev/null; then
    echo "📦 Установка pipenv..."
    pip install --user pipenv
fi

# Установка зависимостей
echo "📦 Установка зависимостей проекта..."
pipenv install --dev

# Установка pre-commit
echo "🔧 Установка pre-commit hooks..."
pipenv run pip install pre-commit
pipenv run pre-commit install

# Создание .env файла если не существует
if [ ! -f .env ]; then
    echo "📝 Создание .env файла..."
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
    echo "✅ .env файл создан"
else
    echo "✅ .env файл уже существует"
fi

# Применение миграций
echo "🗄️  Применение миграций..."
pipenv run python manage.py migrate

# Проверка Django
echo "🔍 Проверка Django..."
pipenv run python manage.py check

echo ""
echo "✨ Готово! Окружение разработки настроено."
echo ""
echo "Следующие шаги:"
echo "  1. Активируйте окружение: pipenv shell"
echo "  2. Создайте суперпользователя: python manage.py createsuperuser"
echo "  3. Запустите сервер: python manage.py runserver"
echo ""
echo "Или используйте Docker:"
echo "  make build && make up"
echo ""

