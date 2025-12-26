# Mapping PostgreSQL → ElasticSearch

## Index cible
Index: `products`

## Document structure
{
  "id": "<uuid>",
  "name": {
    "type": "text",
    "analyzer": "standard"
  },
  "price": {
    "type": "scaled_float",
    "scaling_factor": 100
  },
  "updated_at": {
    "type": "date"
  },
  "synced_at": {
    "type": "date"
  }
}

## Transformations nécessaires
- `id` → garder comme keyword
- `name` → indexer pour recherche full-text
- `price` → convertir en scaled_float
- `updated_at` → format ISO 8601