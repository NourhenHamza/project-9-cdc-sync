#!/bin/bash

echo "Waiting for Kafka Connect to be ready..."
sleep 20

echo "Registering PostgreSQL connector..."
curl -i -X POST -H "Accept:application/json" -H "Content-Type:application/json" \
  http://localhost:8083/connectors/ \
  -d @postgres-connector.json

echo -e "\n\nChecking connector status..."
curl -s http://localhost:8083/connectors/postgres-products-connector/status | jq