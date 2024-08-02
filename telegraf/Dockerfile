# Telegraf Dockerfile
FROM telegraf:latest

# Install cron
RUN apt-get update && apt-get install -y cron smartmontools

# Create a directory for the cron PID file
RUN mkdir -p /var/run/crond && chown root:root /var/run/crond

# Add the crontab file
COPY crontab /etc/cron.d/smart_cron

# Give execution rights on the cron job
RUN chmod 0644 /etc/cron.d/smart_cron

# Create the log file to be able to run tail
RUN touch /var/log/cron.log /var/log/smart_test.log

# Add the script to the image
COPY smart_test.sh /usr/local/bin/smart_test.sh

# Give execution rights on the script
RUN chmod +x /usr/local/bin/smart_test.sh

# Apply cron job
RUN crontab /etc/cron.d/smart_cron

# Add the Telegraf configuration file
COPY telegraf.conf /etc/telegraf/telegraf.conf

# Expose the necessary ports (if needed for plugins)
EXPOSE 8125/udp
EXPOSE 8092/udp
EXPOSE 8094

# Add an entrypoint script
COPY entrypoint.sh /usr/local/bin/entrypoint.sh

# Give execution rights on the entrypoint script
RUN chmod +x /usr/local/bin/entrypoint.sh

# Use the entrypoint script to start both cron and Telegraf
ENTRYPOINT ["/usr/local/bin/entrypoint.sh"]