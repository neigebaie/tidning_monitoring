# Tidning Monitoring with Telegraf, PostgreSQL, and Grafana

This project sets up a monitoring stack using Telegraf, PostgreSQL, and Grafana. It collects system and Docker container metrics, stores them in PostgreSQL, and visualizes the data with Grafana dashboards.

## Prerequisites

- Docker and Docker Compose installed on your system.
- Basic knowledge of Docker and Docker Compose.

## Getting Started

### 1. Clone the Repository

```bash
git clone https://github.com/yourusername/rpi-monitoring-stack.git
cd rpi-monitoring-stack
```

### 2. Modify the environment variables to suit your needs

### 3. Build and Start the Containers

```bash
docker-compose up -d
```

This command will build the Telegraf image and start all services (Telegraf, PostgreSQL, and Grafana) in the background.

### 4. Access Grafana

Open a web browser and navigate to `http://<ip_address>:3025`. Log in with the default username `admin` and the password you set.

### 4. Configure Grafana Data Source

1. In Grafana, go to **Configuration** > **Data Sources** > **Add data source**.
2. Select **PostgreSQL**.
3. Fill in the database connection details:
   - **Host**: `postgres:5432`
   - **Database**: `telegraf`
   - **User**: `telegraf`
   - **Password**: The password from your `.env` file
4. Click **Save & Test** to verify the connection.

### 5. Create Dashboards

Use Grafana's query editor to create custom dashboards and visualize the metrics collected by Telegraf. You can display metrics like CPU usage, memory usage, disk I/O, network traffic, and Docker container stats.

## PostgreSQL Retention Policy with pg_cron

This project uses a custom Postgres image with the pg_cron extension to automatically delete metrics older than 30 days. The retention policy is set up via an init script mounted into the container.

- The Postgres Dockerfile installs pg_cron and enables it.
- The `init-retention.sql` script creates the extension and schedules a daily job to delete old data.
- See `postgres/Dockerfile` and `postgres/init-retention.sql` for details.

## License

This project is licensed under the MIT License. See the `LICENSE` file for more details.