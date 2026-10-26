# GeoAI Portal

An open-source, self-hosted portal for geographic data, maps and apps.
Content builds on itself: **Data → Services → Layers → Maps → Apps**.

This repository runs the portal with Docker Compose. The portal itself is built in two other repositories and
published as images on Docker Hub:

| Part | Where | Built with |
|---|---|---|
| Running it | `portaldeploy` (this one) | Docker Compose, Keycloak realm, nginx and database settings |
| Web client | [`geoaiportal/client`](https://hub.docker.com/r/geoaiportal/client), from `portalclient` | Angular, served by nginx |
| API | [`geoaiportal/api`](https://hub.docker.com/r/geoaiportal/api), from `portalapi` | .NET 10 |
| Database | `postgis/postgis` | PostgreSQL 17 + PostGIS |
| Sign-in | `quay.io/keycloak/keycloak` | Keycloak 26 |

The images run on `linux/amd64` and `linux/arm64`.

## Getting started

You need [Docker](https://docs.docker.com/get-docker/) with Docker Compose, and this repository. Nothing else:
the images are downloaded.

1. **Get this repository**

   ```bash
   git clone <this repository's address> portaldeploy
   cd portaldeploy
   ```

2. **Create your settings file**

   ```bash
   cp .env.example .env
   ```

   Open `.env` and change the passwords. Is port 8080 already in use on your machine? Change
   `GEOAI_PORT` and the port in `GEOAI_PUBLIC_URL`.

3. **Start everything**

   ```bash
   docker compose up -d
   ```

   The first time this takes a few minutes: the images are downloaded, the database is created,
   and Keycloak prepares itself. The command returns when everything is ready.

4. **Open the portal** at `GEOAI_PUBLIC_URL` (default http://localhost:8080).
   The setup wizard opens: name your organisation and create your administrator account, then sign in.

   Whoever opens a new portal first gets this wizard. On a server that is reachable from the internet,
   finish the setup right after starting it.

## What is in here

| File | What |
|---|---|
| `docker-compose.yml` | Everything on one machine: database, Keycloak, API and web client |
| `docker-compose.external.yml` | Only the API and web client, for your own database and Keycloak |
| `.env.example` | Every setting, with explanations; copy it to `.env` |
| `docker/keycloak/geoai-realm.json` | The Keycloak realm (clients, roles, the API's service account), imported on the first start |
| `docker/nginx/keycloak.conf` | Serves Keycloak under `/auth` through the web client's nginx |
| `docker/postgres/initdb/` | Creates Keycloak's database next to the portal's on the first start |

## Useful addresses

| Address | What |
|---|---|
| `/` | The portal |
| `/health` | Status of the API, database and Keycloak |
| `/auth/admin` | Keycloak admin console (user `KEYCLOAK_ADMIN` from `.env`): users, roles and groups |

## Versions

`GEOAI_VERSION` in `.env` chooses the image version, the same for the API and the web client:

| Value | Runs |
|---|---|
| `latest` | The newest release (default) |
| `1` | The newest 1.x.y: new features and fixes, nothing that needs action from you |
| `1.0` | The newest 1.0.x: fixes only |
| `1.0.4` | Exactly that version |

On a server that should not change on its own, pin `1` or `1.0`.

## Updating

Download the new images and restart. Database changes are applied by the API when it starts:

```bash
git pull
docker compose pull
docker compose up -d
```

`git pull` brings changes to these files, such as a newer Keycloak realm; your `.env` stays as it is.

## Your own database or Keycloak

Already have PostgreSQL/PostGIS or Keycloak on another server? Fill in the last section of `.env`
and start only the portal itself:

```bash
docker compose -f docker-compose.external.yml up -d
```

The README of `portalapi` describes every setting.

## Starting over

This removes the containers, the database, uploaded files and the images. It keeps `.env`:

```bash
docker compose down -v --rmi all
```
