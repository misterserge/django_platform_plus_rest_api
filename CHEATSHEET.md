# 📝 Шпаргалка команд

Быстрый справочник всех команд проекта.

---

## 🐳 Docker команды

### Основные
```bash
make build              # Собрать Docker образ
make up                 # Запустить все контейнеры
make down               # Остановить все контейнеры
make restart            # Перезапустить контейнеры
make logs               # Показать логи (follow mode)
make clean              # Очистить контейнеры и volumes
make rebuild            # Полная пересборка
```

### Production
```bash
make up-prod                                      # Запустить prod окружение
docker-compose -f docker-compose.prod.yml up -d   # То же самое вручную
docker-compose -f docker-compose.prod.yml down    # Остановить prod
docker-compose -f docker-compose.prod.yml logs -f # Логи prod
```

### Без Makefile
```bash
docker-compose build                    # Собрать
docker-compose up -d                    # Запустить в фоне
docker-compose down                     # Остановить
docker-compose logs -f                  # Логи
docker-compose ps                       # Статус контейнеров
docker-compose restart                  # Перезапустить
docker-compose down -v                  # Остановить + удалить volumes
```

---

## 🔧 Django команды

### В Docker
```bash
make migrate                # Применить миграции
make makemigrations         # Создать миграции
make shell                  # Django shell
make bash                   # Bash в контейнере
make createsuperuser        # Создать суперпользователя
make collectstatic          # Собрать статику
make test                   # Запустить тесты
```

### Напрямую (в контейнере)
```bash
docker-compose exec web python manage.py migrate
docker-compose exec web python manage.py makemigrations
docker-compose exec web python manage.py shell
docker-compose exec web python manage.py createsuperuser
docker-compose exec web python manage.py test
docker-compose exec web python manage.py collectstatic --noinput
```

### Локально (без Docker)
```bash
python manage.py runserver              # Запустить dev сервер
python manage.py migrate                # Миграции
python manage.py makemigrations         # Создать миграции
python manage.py shell                  # Django shell
python manage.py createsuperuser        # Создать админа
python manage.py test                   # Тесты
python manage.py collectstatic          # Собрать статику
python manage.py check                  # Проверка проекта
python manage.py showmigrations         # Показать миграции
```

---

## 🎨 Качество кода

### Форматирование
```bash
black .                         # Форматировать весь код
black path/to/file.py           # Форматировать файл
black --check .                 # Проверить без изменений
```

### Импорты
```bash
isort .                         # Отсортировать импорты
isort path/to/file.py           # Отсортировать в файле
isort --check-only .            # Проверить без изменений
```

### Линтинг
```bash
flake8 .                        # Проверить весь код
flake8 path/to/file.py          # Проверить файл
```

### Типы
```bash
mypy .                          # Проверить типы
mypy path/to/file.py            # Проверить файл
```

### Безопасность
```bash
bandit -r .                     # Security scan
pipenv check                    # Проверка зависимостей
safety check                    # Проверка уязвимостей
```

### Pre-commit
```bash
pre-commit install              # Установить hooks
pre-commit run --all-files      # Запустить все проверки
pre-commit run black            # Запустить конкретный hook
pre-commit uninstall            # Удалить hooks
```

---

## 📦 Pipenv команды

### Основные
```bash
pipenv install                  # Установить зависимости
pipenv install --dev            # Установить с dev зависимостями
pipenv install package_name     # Установить пакет
pipenv uninstall package_name   # Удалить пакет
pipenv shell                    # Активировать окружение
pipenv run python script.py     # Запустить скрипт
pipenv lock                     # Обновить Pipfile.lock
pipenv update                   # Обновить все пакеты
pipenv clean                    # Удалить неиспользуемые пакеты
```

### Информация
```bash
pipenv --venv                   # Показать путь к venv
pipenv --where                  # Показать путь к проекту
pipenv graph                    # Показать дерево зависимостей
pipenv check                    # Проверить безопасность
```

---

## 🗄️ База данных

### PostgreSQL в Docker
```bash
# Войти в psql
docker-compose exec db psql -U django_user -d django_db

# Backup
docker-compose exec db pg_dump -U django_user django_db > backup.sql

# Restore
cat backup.sql | docker-compose exec -T db psql -U django_user django_db

# Список баз
docker-compose exec db psql -U django_user -l

# Подключиться к БД
docker-compose exec db psql -U django_user -d django_db
```

### SQLite
```bash
# Открыть БД
sqlite3 db.sqlite3

# Дамп
sqlite3 db.sqlite3 .dump > backup.sql

# Восстановление
sqlite3 db.sqlite3 < backup.sql
```

---

## 🔐 Секреты и конфигурация

### Создать .env файлы
```bash
# Development
cp .env.dev .env

# Production
cp .env.prod.example .env.prod
# Затем отредактировать файл
```

### Генерация SECRET_KEY
```bash
# С помощью скрипта
python generate_secret_key.py

# Прямо в терминале
python -c 'from django.core.management.utils import get_random_secret_key; print(get_random_secret_key())'

# С openssl
openssl rand -base64 64
```

---

## 🚀 Развертывание

### Локально
```bash
./setup_dev.sh                  # Автоматическая настройка dev
make build && make up           # Запустить Docker
```

### Production (на сервере)
```bash
# Первый раз
git clone <repo-url> django-app
cd django-app
# Создать .env.prod
docker-compose -f docker-compose.prod.yml build
docker-compose -f docker-compose.prod.yml up -d

# Обновление
git pull
docker-compose -f docker-compose.prod.yml pull
docker-compose -f docker-compose.prod.yml up -d
```

---

## 🔍 Отладка и логи

### Docker логи
```bash
docker-compose logs                     # Все логи
docker-compose logs -f                  # Follow mode
docker-compose logs -f web              # Только Django
docker-compose logs -f nginx            # Только Nginx
docker-compose logs -f db               # Только БД
docker-compose logs --tail=100 web      # Последние 100 строк
```

### Статус
```bash
docker-compose ps                       # Статус контейнеров
docker ps                               # Все Docker контейнеры
docker images                           # Все образы
docker volume ls                        # Все volumes
docker network ls                       # Все сети
```

### Очистка
```bash
docker system prune                     # Очистить все неиспользуемое
docker system prune -a                  # Очистить + образы
docker volume prune                     # Очистить volumes
docker image prune -a                   # Очистить образы
```

---

## 🧪 Тестирование

### Запуск тестов
```bash
# В Docker
make test

# Локально
python manage.py test

# Конкретное приложение
python manage.py test myapp

# Конкретный тест
python manage.py test myapp.tests.MyTestCase.test_something

# С verbose
python manage.py test --verbosity=2

# Быстрые тесты (без миграций БД)
python manage.py test --keepdb
```

### Coverage
```bash
# Запустить с coverage
coverage run manage.py test

# Показать отчет
coverage report

# HTML отчет
coverage html
# Откроется в htmlcov/index.html

# XML отчет (для CI)
coverage xml
```

---

## 📡 Nginx

### Проверка конфигурации
```bash
docker-compose exec nginx nginx -t              # Проверить конфиг
docker-compose exec nginx nginx -s reload       # Перезагрузить
docker-compose exec nginx cat /var/log/nginx/error.log   # Error log
docker-compose exec nginx cat /var/log/nginx/access.log  # Access log
```

---

## 🔗 Git команды

### Ветки
```bash
git checkout -b feature/my-feature      # Создать feature ветку
git checkout -b hotfix/my-fix           # Создать hotfix ветку
git checkout develop                    # Переключиться на develop
git checkout main                       # Переключиться на main
```

### Синхронизация
```bash
git fetch upstream                      # Получить изменения
git merge upstream/develop              # Слить с upstream
git pull origin develop                 # Получить и слить
git push origin feature/my-feature      # Push ветки
```

### Коммиты
```bash
git add .                               # Добавить все
git commit -m "feat: новая фича"        # Коммит
git commit -m "fix: исправление бага"   # Коммит fix
git push origin branch-name             # Push
```

---

## 🎯 Быстрые сценарии

### Новый проект (с нуля)
```bash
git clone <repo-url>
cd django_platform_plus_rest_api
cp .env.dev .env
make build
make up
make migrate
make createsuperuser
# Открыть http://localhost:8000
```

### Добавить новое Django app
```bash
make bash
python manage.py startapp myapp
exit
# Добавить 'myapp' в INSTALLED_APPS
make restart
```

### Полный сброс
```bash
make down
make clean
rm db.sqlite3
make build
make up
make migrate
make createsuperuser
```

### Обновление зависимостей
```bash
pipenv update
pipenv lock
make rebuild
```

---

## 🆘 Решение проблем

### Порт занят
```bash
lsof -ti:8000 | xargs kill -9           # Убить процесс на порту 8000
lsof -ti:5432 | xargs kill -9           # Убить процесс на порту 5432
```

### Проблемы с правами
```bash
sudo chown -R $USER:$USER .             # Изменить владельца
sudo chmod +x docker-entrypoint.sh      # Добавить права на выполнение
sudo chmod +x setup_dev.sh              # Добавить права на выполнение
```

### Docker проблемы
```bash
docker system prune -a                  # Очистить все
docker-compose down -v                  # Удалить volumes
make rebuild                            # Полная пересборка
```

### База данных проблемы
```bash
# Удалить БД и начать заново
make down
rm db.sqlite3
make up
make migrate
```

---

## 📱 Полезные URL

- **Dev сервер:** http://localhost:8000
- **Admin панель:** http://localhost:8000/admin
- **API (если установлен DRF):** http://localhost:8000/api/
- **Swagger (если установлен):** http://localhost:8000/swagger/

---

## 💡 Советы

### VS Code
- Установите рекомендуемые расширения: `Cmd+Shift+P` → "Show Recommended Extensions"
- Используйте встроенный дебаггер: `F5`

### Performance
```bash
# Уменьшить размер образа
docker image prune -a

# Быстрый rebuild
docker-compose build --parallel

# Использовать build cache
docker-compose build --build-arg BUILDKIT_INLINE_CACHE=1
```

---

**Сохраните эту шпаргалку! 📌**

Больше информации в [README.md](README.md) и [DEPLOYMENT.md](DEPLOYMENT.md)

