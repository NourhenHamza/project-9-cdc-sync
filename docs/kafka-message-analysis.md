# Analyse des messages Kafka réels

## Configuration détectée
- **Topic utilisé** : `cdc.public.products`
- **Server name** : `cdc`
- **Format** : JSON simplifié (pas de wrapper Debezium)

## Structure des messages
```json
{
  "id": "uuid",
  "name": "string",
  "price": "base64",  // ⚠️ DECIMAL encodé en Base64
  "category": "string | null",
  "stock": number,
  "description": "string | null",
  "created_at": number,  // microseconds timestamp
  "updated_at": number,  // microseconds timestamp
  "__deleted": "true" | "false"
}
```

## ⚠️ Points critiques pour les consumers

### 1. Décodage du prix (Base64 → DECIMAL)

**Problème** : Le prix est encodé en Base64 (`"AYaf"` au lieu de `15.99`)

**Solution** :
```javascript
// Node.js / JavaScript
function decodePrice(base64Price) {
  const buffer = Buffer.from(base64Price, 'base64');
  const cents = buffer.readInt32BE(0);
  return cents / 100;
}

// Exemple
decodePrice("AYaf") // → 15.99
decodePrice("AV+P") // → 14.39
```

### 2. Conversion des timestamps

Les timestamps sont en **microseconds** (pas milliseconds) :
```javascript
// Convertir microseconds → Date JavaScript
const date = new Date(created_at / 1000);
```

### 3. Détection des DELETE

Les DELETE sont indiqués par :
- `"__deleted": "true"`
- Tous les champs sont à zéro/vides sauf `id`

**Exemple de message DELETE** :
```json
{
  "id": "7befbf24-7491-48a9-a513-9174d0a2c307",
  "name": "",
  "price": "AA==",  // 0
  "category": null,
  "stock": 0,
  "description": null,
  "created_at": 0,
  "updated_at": 0,
  "__deleted": "true"
}
```

## Tests effectués

### ✅ INSERT
```sql
INSERT INTO products (name, price, category, stock)
VALUES ('Samsung', 899.99, 'Electronics', 75);
```

**Message Kafka reçu** : ✅ OK

### ✅ DELETE
```sql
DELETE FROM products WHERE name = 'Samsung';
```

**Message Kafka reçu** : ✅ OK avec `__deleted: "true"`

## Observations

- ❌ Le topic `dbserver1.public.products` est vide
- ✅ Le topic `cdc.public.products` fonctionne correctement
- ⚠️ Format différent du standard Debezium (pas de `before`/`after`/`op`)