# Многоэтапная сборка для оптимизации размера образа
FROM python:3.13-slim as builder

# Устанавливаем зависимости для сборки
RUN apt-get update && apt-get install -y --no-install-recommends \
    gcc \
    && rm -rf /var/lib/apt/lists/*

# Копируем Pipfile для установки зависимостей
WORKDIR /app
COPY Pipfile Pipfile.lock ./

# Устанавливаем pipenv и зависимости
RUN pip install --no-cache-dir pipenv && \
    pipenv requirements > requirements.txt

# Финальный образ
FROM python:3.13-slim

# Создаем пользователя для запуска приложения (безопасность)
RUN useradd -m -u 1000 django && \
    mkdir -p /app /app/staticfiles /app/mediafiles && \
    chown -R django:django /app

WORKDIR /app

# Копируем requirements.txt из builder
COPY --from=builder /app/requirements.txt .

# Устанавливаем зависимости и gunicorn для production
RUN pip install --no-cache-dir -r requirements.txt gunicorn && \
    pip install --no-cache-dir psycopg2-binary python-decouple

# Копируем весь проект
COPY --chown=django:django . .

# Переключаемся на непривилегированного пользователя
USER django

# Собираем статические файлы
RUN python manage.py collectstatic --noinput --clear || true

# Порт для приложения
EXPOSE 8000

# Healthcheck
HEALTHCHECK --interval=30s --timeout=10s --start-period=40s --retries=3 \
    CMD python -c "import urllib.request; urllib.request.urlopen('http://localhost:8000')" || exit 1

# Entrypoint скрипт
COPY --chown=django:django docker-entrypoint.sh /usr/local/bin/
RUN chmod +x /usr/local/bin/docker-entrypoint.sh

ENTRYPOINT ["docker-entrypoint.sh"]
CMD ["gunicorn", "--bind", "0.0.0.0:8000", "--workers", "4", "--timeout", "60", "base.wsgi:application"]

