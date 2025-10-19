# 🤝 Руководство для разработчиков

Спасибо за интерес к проекту! Это руководство поможет вам начать разработку.

## 📋 Содержание

- [Быстрый старт](#быстрый-старт)
- [Настройка окружения](#настройка-окружения)
- [Стандарты кода](#стандарты-кода)
- [Процесс разработки](#процесс-разработки)
- [Тестирование](#тестирование)
- [Коммиты](#коммиты)
- [Pull Requests](#pull-requests)

## 🚀 Быстрый старт

```bash
# 1. Fork репозитория на GitHub
# 2. Клонируйте ваш fork
git clone https://github.com/YOUR_USERNAME/django_platform_plus_rest_api.git
cd django_platform_plus_rest_api

# 3. Добавьте upstream remote
git remote add upstream https://github.com/ORIGINAL_OWNER/django_platform_plus_rest_api.git

# 4. Запустите скрипт настройки
./setup_dev.sh

# 5. Создайте feature ветку
git checkout -b feature/amazing-feature
```

## 🛠 Настройка окружения

### Автоматическая настройка

```bash
./setup_dev.sh
```

### Ручная настройка

```bash
# Установка зависимостей
pip install pipenv
pipenv install --dev

# Установка pre-commit hooks
pipenv run pip install pre-commit
pipenv run pre-commit install

# Создание .env
cp .env.dev .env

# Применение миграций
pipenv run python manage.py migrate

# Создание суперпользователя
pipenv run python manage.py createsuperuser
```

## 📝 Стандарты кода

### Линтеры и форматтеры

Проект использует:
- **Black** - форматирование кода
- **isort** - сортировка импортов
- **flake8** - проверка стиля
- **mypy** - проверка типов
- **bandit** - проверка безопасности

### Запуск проверок вручную

```bash
# Black (форматирование)
pipenv run black .

# isort (импорты)
pipenv run isort .

# flake8 (линтер)
pipenv run flake8 .

# mypy (типы)
pipenv run mypy .

# bandit (безопасность)
pipenv run bandit -r .

# Все сразу
pipenv run pre-commit run --all-files
```

### Автоматические проверки

Pre-commit hooks автоматически запускаются при коммите:
- Форматирование кода (Black, isort)
- Проверка стиля (flake8)
- Проверка безопасности (bandit)
- Django checks

## 🔄 Процесс разработки

### 1. Синхронизация с upstream

```bash
git fetch upstream
git checkout develop
git merge upstream/develop
```

### 2. Создание feature ветки

```bash
# От develop для новых фич
git checkout -b feature/your-feature-name develop

# От main для hotfixes
git checkout -b hotfix/your-fix-name main
```

### 3. Разработка

```bash
# Активируйте окружение
pipenv shell

# Запустите сервер
python manage.py runserver

# Или используйте Docker
make up
```

### 4. Тестирование

```bash
# Запуск всех тестов
python manage.py test

# С coverage
coverage run manage.py test
coverage report
coverage html  # HTML отчет в htmlcov/

# В Docker
make test
```

### 5. Коммит изменений

```bash
# Pre-commit hooks запустятся автоматически
git add .
git commit -m "feat: добавил новую фичу"
```

## 🧪 Тестирование

### Написание тестов

Тесты должны быть в файлах `tests.py` или `test_*.py`:

```python
from django.test import TestCase

class MyModelTestCase(TestCase):
    def setUp(self):
        # Настройка данных для теста
        pass

    def test_something(self):
        # Ваш тест
        self.assertEqual(1, 1)
```

### Запуск тестов

```bash
# Все тесты
python manage.py test

# Конкретное приложение
python manage.py test myapp

# Конкретный тест
python manage.py test myapp.tests.MyTestCase.test_something

# С verbose
python manage.py test --verbosity=2

# С coverage
coverage run manage.py test
coverage report
```

## 📦 Коммиты

### Формат коммитов

Используйте [Conventional Commits](https://www.conventionalcommits.org/):

```
<type>(<scope>): <subject>

<body>

<footer>
```

### Типы коммитов

- `feat:` - новая функциональность
- `fix:` - исправление бага
- `docs:` - изменения в документации
- `style:` - форматирование, точки с запятой и т.д.
- `refactor:` - рефакторинг кода
- `perf:` - улучшение производительности
- `test:` - добавление тестов
- `chore:` - обновление зависимостей, конфигов и т.д.
- `ci:` - изменения в CI/CD
- `build:` - изменения в сборке

### Примеры

```bash
# Новая фича
git commit -m "feat(auth): добавил двухфакторную аутентификацию"

# Исправление бага
git commit -m "fix(api): исправил ошибку 500 при создании пользователя"

# Документация
git commit -m "docs: обновил README с инструкциями по деплою"

# Рефакторинг
git commit -m "refactor(models): упростил структуру User модели"
```

## 🔀 Pull Requests

### Создание PR

1. Убедитесь что все тесты проходят:
```bash
python manage.py test
pipenv run pre-commit run --all-files
```

2. Push в ваш fork:
```bash
git push origin feature/your-feature-name
```

3. Создайте PR на GitHub:
   - Из `feature/your-feature-name` в `develop`
   - Или из `hotfix/your-fix-name` в `main`

### Шаблон PR

```markdown
## Описание
Краткое описание изменений

## Тип изменений
- [ ] Bug fix
- [ ] New feature
- [ ] Breaking change
- [ ] Documentation update

## Чеклист
- [ ] Код соответствует стандартам проекта
- [ ] Добавлены/обновлены тесты
- [ ] Все тесты проходят
- [ ] Обновлена документация
- [ ] Pre-commit hooks проходят

## Связанные issues
Closes #123
```

### Ревью

- Минимум 1 аппрув для merge
- Все CI/CD проверки должны пройти
- Конфликты должны быть разрешены
- Code style должен соответствовать стандартам

## 🏗 Структура проекта

```
.
├── base/                   # Django настройки проекта
│   ├── settings.py        # Основные настройки
│   ├── urls.py            # Главный URL конфиг
│   ├── wsgi.py            # WSGI конфигурация
│   └── asgi.py            # ASGI конфигурация
├── .github/workflows/     # CI/CD pipeline
├── nginx/                 # Nginx конфигурация
├── .vscode/               # VS Code настройки
├── tests/                 # Глобальные тесты
├── manage.py              # Django CLI
├── Dockerfile             # Docker образ
├── docker-compose.yml     # Dev окружение
├── docker-compose.prod.yml # Prod окружение
├── Makefile               # Полезные команды
├── Pipfile                # Python зависимости
└── README.md              # Документация
```

## 🐛 Отладка

### VS Code

Используйте встроенный дебаггер:
1. Откройте Debug панель (Cmd+Shift+D)
2. Выберите "Python: Django"
3. Нажмите F5

### Django Debug Toolbar

```bash
# Установка
pipenv install django-debug-toolbar --dev

# Добавьте в settings.py (только для DEBUG=True)
INSTALLED_APPS += ['debug_toolbar']
MIDDLEWARE += ['debug_toolbar.middleware.DebugToolbarMiddleware']
INTERNAL_IPS = ['127.0.0.1']
```

## 📚 Дополнительные ресурсы

- [Django документация](https://docs.djangoproject.com/)
- [Docker документация](https://docs.docker.com/)
- [Python Style Guide (PEP 8)](https://pep8.org/)
- [Conventional Commits](https://www.conventionalcommits.org/)

## ❓ Вопросы?

- Создайте issue в GitHub
- Напишите в Discussions
- Свяжитесь с мейнтейнерами

## 📄 Лицензия

Участвуя в проекте, вы соглашаетесь что ваш код будет лицензирован под MIT License.

---

**Спасибо за ваш вклад! 🙏**

