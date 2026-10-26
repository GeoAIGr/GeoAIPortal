#!/bin/bash
# Bundled setup only. Runs once, when the database volume is created:
# gives Keycloak its own user and database on the same PostgreSQL server.
# The portal's own tables are not created here; the API creates them on first start.
set -euo pipefail

psql -v ON_ERROR_STOP=1 --username "$POSTGRES_USER" --dbname "$POSTGRES_DB" \
     -v kc_password="$KEYCLOAK_DB_PASSWORD" <<'SQL'
CREATE ROLE keycloak LOGIN PASSWORD :'kc_password';
CREATE DATABASE keycloak OWNER keycloak;
SQL
