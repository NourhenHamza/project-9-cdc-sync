# Mapping PostgreSQL → MongoDB (via Kafka CDC)

## Topic Kafka : `cdc.public.products`

## Transformations nécessaires

| Kafka Field | MongoDB Field | Transformation |
|-------------|---------------|----------------|
| `id` | `_id` | Direct (string) |
| `name` | `name` | Direct (string) |
| `price` | `price` | **Base64 → Number** |
| `category` | `category` | Direct (string ou null) |
| `stock` | `stock` | Direct (number) |
| `description` | `description` | Direct (string ou null) |
| `created_at` | `created_at` | **Microseconds → ISODate** |
| `updated_at` | `updated_at` | **Microseconds → ISODate** |
| - | `synced_at` | Add current timestamp |

## Code de transformation (Node.js)
```javascript
function decodePrice(base64Price) {
  const buffer = Buffer.from(base64Price, 'base64');
  const cents = buffer.readInt32BE(0);
  return cents / 100;
}

function microsecondsToDate(microseconds) {
  return new Date(microseconds / 1000);
}

function transformMessage(kafkaMessage) {
  const msg = JSON.parse(kafkaMessage);
  
  // Si c'est un DELETE
  if (msg.__deleted === "true") {
    return {
      operation: 'DELETE',
      id: msg.id
    };
  }
  
  // Si c'est un INSERT/UPDATE
  return {
    operation: 'UPSERT',
    document: {
      _id: msg.id,
      name: msg.name,
      price: decodePrice(msg.price),
      category: msg.category,
      stock: msg.stock,
      description: msg.description,
      created_at: microsecondsToDate(msg.created_at),
      updated_at: microsecondsToDate(msg.updated_at),
      synced_at: new Date()
    }
  };
}
```

## Opérations MongoDB

### INSERT / UPDATE (upsert)
```javascript
if (msg.__deleted !== "true") {
  await db.collection('products').updateOne(
    { _id: msg.id },
    { $set: transformedDocument },
    { upsert: true }
  );
}
```

### DELETE
```javascript
if (msg.__deleted === "true") {
  await db.collection('products').deleteOne({ _id: msg.id });
}
```