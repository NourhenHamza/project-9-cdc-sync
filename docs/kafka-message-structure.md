## Event DELETE
- `before` contient l'objet avant suppression
- `after` est `null`
- `op` = "d"

⚠️ **Important pour les consumers** :
Les consumers doivent détecter `op=d` et supprimer le document correspondant dans MongoDB/ElasticSearch.