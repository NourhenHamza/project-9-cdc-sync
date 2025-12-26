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


 
Pour consommer msg postgres et recevoir dans kafka
# Consommer les messages du topic
 

  -- Dans PostgreSQL (docker exec -it postgres psql -U postgres -d products_db)

-- INSERT
INSERT INTO products (name, price, category, stock) 
VALUES ('Samsung Galaxy S24', 899.99, 'Electronics', 75);

-- UPDATE
UPDATE products SET price = 1199.99 WHERE name = 'Laptop Dell XPS 15';

-- DELETE
DELETE FROM products WHERE name = 'Nike Air Max';

 





 docker exec -it kafka bash

  kafka-topics --bootstrap-server localhost:9092 --list

   kafka-console-consumer --bootstrap-server localhost:9092 \
>   --topic cdc.public.products \
> kafka-console-consumer \
  kafka-console-consumer \
  --bootstrap-server localhost:9092 \
  --topic cdc.public.products \
  --from-beginning