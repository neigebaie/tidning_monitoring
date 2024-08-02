# Telegraf Dockerfile
FROM telegraf:latest

# Add the Telegraf configuration file
COPY telegraf.conf /etc/telegraf/telegraf.conf

# Expose the necessary ports (if needed for plugins)
EXPOSE 8125/udp
EXPOSE 8092/udp
EXPOSE 8094

CMD telegraf