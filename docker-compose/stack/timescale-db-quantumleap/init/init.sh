#!/usr/bin/env bash

set -e

echo  "host    replication     backup_user     backup-service          md5" >> /home/postgres/pgdata/data/pg_hba.conf
echo  "host    all             backup_user     backup-service          md5" >> /home/postgres/pgdata/data/pg_hba.conf

psql -v ON_ERROR_STOP=1 --username "$POSTGRES_USER" --dbname "$POSTGRES_DB" <<-EOSQL
  CREATE SCHEMA IF NOT EXISTS mtsmartcity;

  DO
  \$\$
  BEGIN
      IF NOT EXISTS (
          SELECT FROM pg_catalog.pg_roles
          WHERE rolname = '$QUANTUMLEAP_DB_BACKUP_USER') THEN
          CREATE ROLE $QUANTUMLEAP_DB_BACKUP_USER WITH REPLICATION LOGIN PASSWORD '$QUANTUMLEAP_DB_BACKUP_PASSWORD';
      END IF;
  END
  \$\$;

  DO
  \$\$
  BEGIN
      IF NOT EXISTS (
          SELECT FROM pg_catalog.pg_roles
          WHERE rolname = '$GRAFANA_POSTGRES_USER') THEN
          CREATE USER $GRAFANA_POSTGRES_USER WITH PASSWORD '$GRAFANA_POSTGRES_PASSWORD';
      END IF;
  END
  \$\$;

  GRANT USAGE ON SCHEMA mtsmartcity TO $GRAFANA_POSTGRES_USER;
  ALTER DATABASE $POSTGRES_DB SET search_path TO 'mtsmartcity';
  ALTER ROLE $GRAFANA_POSTGRES_USER SET search_path TO 'mtsmartcity';

  ALTER DEFAULT PRIVILEGES IN SCHEMA mtsmartcity
  GRANT SELECT ON TABLES TO $GRAFANA_POSTGRES_USER;

  GRANT ALL PRIVILEGES ON SCHEMA mtsmartcity TO $POSTGRES_DB;

  ALTER DEFAULT PRIVILEGES IN SCHEMA mtsmartcity
  GRANT ALL ON TABLES TO $POSTGRES_DB;

  CREATE EXTENSION IF NOT EXISTS postgis SCHEMA mtsmartcity;
  CREATE EXTENSION IF NOT EXISTS timescaledb SCHEMA mtsmartcity;

EOSQL