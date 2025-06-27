FROM alpine:3.22

# Install packages
RUN apk add --no-cache \
    grafana \
    postgresql15 \
    postgresql15-client \
    postgresql15-contrib \
    pg_cron \
    curl \
    supervisor \
    tzdata

# Copy configs and scripts
COPY start.sh /start.sh

# Supervisor config
RUN mkdir -p /etc/supervisor.d
RUN printf '[program:grafana]\ncommand=/usr/sbin/grafana-server --homepath=/usr/share/grafana\n' > /etc/supervisor.d/grafana.conf
RUN printf '[program:postgres]\ncommand=/usr/bin/postgres -D /var/lib/postgresql/data\nuser=postgres\nautostart=true\nautorestart=true\n' > /etc/supervisor.d/postgres.conf

# Set up PostgreSQL data directory
RUN mkdir -p /var/lib/postgresql/data && chown -R postgres:postgres /var/lib/postgresql

# Initialize database if not already initialized
RUN su postgres -c 'initdb -D /var/lib/postgresql/data'

ENV PGDATA=/var/lib/postgresql/data

# Entrypoint
RUN chmod +x /start.sh
RUN printf '[supervisord]\nnodaemon=true\n\n[include]\nfiles = /etc/supervisor.d/*.conf\n' > /etc/supervisord.conf

RUN mkdir -p /run/postgresql && chown -R postgres:postgres /run/postgresql

CMD ["/start.sh"]