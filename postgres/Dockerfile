FROM postgres:15-alpine

RUN apt-get update && \
    apt-get install -y postgresql-15-cron && \
    rm -rf /var/lib/apt/lists/*

# Enable pg_cron in the default config
RUN echo "shared_preload_libraries='pg_cron'" >> /usr/share/postgresql/postgresql.conf.sample
RUN echo "cron.database_name='telegraf'" >> /usr/share/postgresql/postgresql.conf.sample 