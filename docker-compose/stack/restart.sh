#!/bin/bash

docker compose -f docker-compose.yml -f docker-compose.development.yml down --remove-orphans -v
docker compose -f docker-compose.yml -f docker-compose.development.yml up --build --remove-orphans -d
