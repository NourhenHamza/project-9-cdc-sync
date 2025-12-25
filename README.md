# Project 9 - CDC Multi-Database Sync

## Architecture
Synchronisation temps réel entre PostgreSQL, MongoDB et ElasticSearch via Debezium CDC et Kafka.

## Services
- PostgreSQL (source)
- Kafka + Zookeeper
- Debezium (Kafka Connect)
- MongoDB (projection)
- ElasticSearch (projection)

## Setup
```bash
docker-compose up -d
```

## Status
- [ ] Infrastructure Docker
- [ ] PostgreSQL configuré
- [ ] Debezium configuré
- [ ] Consumer MongoDB
- [ ] Consumer ElasticSearch