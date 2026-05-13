#!/bin/sh
set -e

# Espera pelo Postgres estar realmente pronto
until pg_isready -h "$POSTGRES_HOST" -p "$POSTGRES_PORT" -U "$POSTGRES_USER"; do
  echo "🟡 Waiting for Postgres Database Startup ($POSTGRES_HOST:$POSTGRES_PORT) ..."
  sleep 2
done

echo "✅ Postgres Database Started Successfully ($POSTGRES_HOST:$POSTGRES_PORT)"

# Pequeno delay extra para garantir estabilidade
sleep 5

# Django tasks (em produção não é recomendado rodar makemigrations)
python manage.py makemigrations
python manage.py migrate --noinput
python manage.py collectstatic --noinput

# Gunicorn server
exec gunicorn dossie_caixa.wsgi:application \
    --bind 0.0.0.0:8000 \
    --workers 4 \
    --threads 2 \
    --timeout 120
