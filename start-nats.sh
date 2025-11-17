#!/usr/bin/env bash

CONTAINER_NAME="trip-planner-bff-nats"

# Verifica se o container já existe (parado ou rodando)
if [ "$(docker ps -aq -f name=^${CONTAINER_NAME}$)" ]; then
  echo "Container '${CONTAINER_NAME}' já existe. Iniciando..."
  docker start "${CONTAINER_NAME}"
else
  echo "Container '${CONTAINER_NAME}' não existe. Criando..."
  docker run -d \
    --name "${CONTAINER_NAME}" \
    -p 4222:4222 \
    -p 8222:8222 \
    -p 6222:6222 \
    nats -js -m 8222
fi
