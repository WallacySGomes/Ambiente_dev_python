#!/bin/sh

set -e

# Espera pelo Postgres
until pg_isready -h "$POSTGRES_HOST" -p "$POSTGRES_PORT" -U "$POSTGRES_USER"; do
  echo "🟡 Waiting for Postgres Database Startup ($POSTGRES_HOST:$POSTGRES_PORT) ..."
  sleep 2
done

echo "✅ Postgres Database Started Successfully ($POSTGRES_HOST:$POSTGRES_PORT)"

# Executa comandos do Django
python manage.py makemigrations
python manage.py migrate --noinput
python manage.py collectstatic --noinput

# Inicia o Gunicorn em produção
exec gunicorn djangoapp.wsgi:application \
    --bind 0.0.0.0:8000 \
    --workers 4 \
    --threads 2 \
    --timeout 120
