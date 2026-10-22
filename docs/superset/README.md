# Superset Setup with Docker Compose

This project sets up Apache Superset along with TimescaleDB and Redis using Docker Compose.

## Prerequisites

- Docker
- Docker Compose

## Files

### docker-compose.yml

This file defines the services required to run Apache Superset, TimescaleDB, and Redis.

#### Services

1. **superset**:

   - **Image**: `apache/superset`
   - **Container Name**: `superset`
   - **Command**: Initializes the admin user and starts the Superset server.
   - **Ports**: Maps port `8088` on the host to port `8088` on the container.
   - **Volumes**: Mounts `superset_config.py` to `/app/superset_config.py` in the container.
   - **Environment Variables**:
     - `POSTGRES_USER`: User for PostgreSQL
     - `POSTGRES_PASSWORD`: Password for PostgreSQL
     - `POSTGRES_DB`: Database name for PostgreSQL
     - `REDIS_URL`: URL for Redis
     - `SUPERSET_CONFIG_PATH`: Path to the Superset configuration file
   - **Depends On**: `timescaledb`, `redis`

2. **timescaledb**:

   - **Image**: `timescale/timescaledb:latest-pg12`
   - **Container Name**: `timescaledb`
   - **Environment Variables**:
     - `POSTGRES_USER`: User for PostgreSQL
     - `POSTGRES_PASSWORD`: Password for PostgreSQL
     - `POSTGRES_DB`: Database name for PostgreSQL
   - **Volumes**: Persists data in the `timescaledb_data` volume.

3. **redis**:
   - **Image**: `redis:5.0.5`sud
   - **Container Name**: `redis`

#### Volumes

- **timescaledb_data**: Persistent storage for TimescaleDB.

### superset_config.py

This file contains the configuration settings for Apache Superset. It is mounted into the Superset container at `/app/superset_config.py`.

## Usage

1. Clone this repository.
2. Navigate to the project directory.
3. Run the following command to start the services:
   ```sh
   docker-compose up -d
   ```
4. Open your browser and go to `http://localhost:8088` to access the Superset web interface.

## Initial Setup

Upon first run, an admin user is created with the following credentials:

- **Username**: `admin`
- **Password**: `admin`
- **Email**: `admin@fab.org`

You can change these credentials by modifying the `command` section in the `docker-compose.yml` file.

## Stopping the Services

To stop the services, run:

```sh
docker-compose down
```

## Contributing

Feel free to submit issues and pull requests to contribute to this project.

## License

This project is licensed under the MIT License.
