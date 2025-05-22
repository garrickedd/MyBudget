CREATE TABLE transactions (
    id SERIAL PRIMARY KEY,
    user_id uuid NOT NULL REFERENCES users(id_user) ON DELETE CASCADE,
    jar_id INTEGER NOT NULL REFERENCES jars(id) ON DELETE CASCADE,
    type VARCHAR(20) NOT NULL CHECK (type IN ('income', 'expense')),
    amount DECIMAL(15,2) NOT NULL CHECK (amount >= 0),
    description VARCHAR(255),
    transaction_date TIMESTAMP NOT NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);