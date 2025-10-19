#!/bin/bash
set -e

echo "Waiting for database..."
sleep 2

echo "Running migrations..."
python manage.py migrate --noinput

echo "Collecting static files..."
python manage.py collectstatic --noinput --clear

echo "Starting application..."
exec "$@"

