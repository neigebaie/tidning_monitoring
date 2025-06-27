FROM postgres:15-alpine

# Install build dependencies
RUN apk add --no-cache --virtual .build-deps \
    git build-base postgresql15-dev curl

# Clone and build pg_cron
RUN git clone --branch v1.5.2 https://github.com/citusdata/pg_cron.git /pg_cron && \
    cd /pg_cron && \
    make && \
    make install

# Remove build dependencies and source
RUN apk del .build-deps && \
    rm -rf /pg_cron

# Enable pg_cron in the default config
RUN echo "shared_preload_libraries='pg_cron'" >> /usr/share/postgresql/postgresql.conf.sample
RUN echo "cron.database_name='telegraf'" >> /usr/share/postgresql/postgresql.conf.sample 