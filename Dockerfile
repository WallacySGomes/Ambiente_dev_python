FROM python:3.12-alpine3.23
LABEL maintainer="dev.wallacy@gmail.com"

ENV PYTHONDONTWRITEBYTECODE=1
ENV PYTHONUNBUFFERED=1

# Copia a pasta djangoapp e o entrypoint
COPY djangoapp /djangoapp
COPY entrypoint.sh /entrypoint.sh

WORKDIR /djangoapp
EXPOSE 8000

# Instala cliente Postgres para usar pg_isready
RUN apk add --no-cache postgresql-client && \
    python -m venv /venv && \
    /venv/bin/pip install --upgrade pip && \
    /venv/bin/pip install -r /djangoapp/requirements.txt && \
    adduser --disabled-password --no-create-home duser && \
    mkdir -p /data/web/static && \
    mkdir -p /data/web/media && \
    chown -R duser:duser /venv && \
    chown -R duser:duser /data/web/static && \
    chown -R duser:duser /data/web/media && \
    chmod -R 755 /data/web/static && \
    chmod -R 755 /data/web/media && \
    chmod +x /entrypoint.sh

ENV PATH="/venv/bin:$PATH"

USER duser

ENTRYPOINT ["/entrypoint.sh"]
