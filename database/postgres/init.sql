-- Création de la table products
CREATE TABLE products (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    name VARCHAR(255) NOT NULL,
    price DECIMAL(10,2) NOT NULL,
    category VARCHAR(100),
    stock INTEGER DEFAULT 0,
    description TEXT,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Créer un index pour améliorer les performances
CREATE INDEX idx_products_category ON products(category);
CREATE INDEX idx_products_updated_at ON products(updated_at);

-- Insérer des données de test
INSERT INTO products (id, name, price, category, stock, description) VALUES
    ('550e8400-e29b-41d4-a716-446655440001', 'Laptop Dell XPS 15', 1299.99, 'Electronics', 50, 'High-performance laptop'),
    ('550e8400-e29b-41d4-a716-446655440002', 'iPhone 15 Pro', 999.99, 'Electronics', 100, 'Latest smartphone'),
    ('550e8400-e29b-41d4-a716-446655440003', 'Nike Air Max', 149.99, 'Fashion', 200, 'Running shoes');

-- Fonction pour mettre à jour automatiquement updated_at
CREATE OR REPLACE FUNCTION update_updated_at_column()
RETURNS TRIGGER AS $$
BEGIN
    NEW.updated_at = CURRENT_TIMESTAMP;
    RETURN NEW;
END;
$$ language 'plpgsql';

-- Trigger pour updated_at
CREATE TRIGGER update_products_updated_at
    BEFORE UPDATE ON products
    FOR EACH ROW
    EXECUTE FUNCTION update_updated_at_column();

-- Afficher les données insérées
SELECT * FROM products;