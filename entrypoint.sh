#!/bin/sh
set -e

# Espera pelo Postgres
while ! nc -z "$POSTGRES_HOST" "$POSTGRES_PORT"; do
  echo "🟡 Waiting for Postgres Database Startup ($POSTGRES_HOST:$POSTGRES_PORT) ..."
  sleep 2
done

echo "✅ Postgres Database Started Successfully ($POSTGRES_HOST:$POSTGRES_PORT)"

# Django tasks
python manage.py makemigrations
python manage.py migrate --noinput
python manage.py collectstatic --noinput

# Gunicorn server
exec gunicorn djangoapp.wsgi:application \
    --bind 0.0.0.0:8000 \
    --workers 4 \
    --threads 2 \
    --timeout 120
