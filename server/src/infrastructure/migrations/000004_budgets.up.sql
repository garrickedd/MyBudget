CREATE TABLE budgets (
    id SERIAL PRIMARY KEY,
    user_id uuid NOT NULL REFERENCES users(id_user) ON DELETE CASCADE,
    jar_id INTEGER NOT NULL REFERENCES jars(id) ON DELETE CASCADE,
    amount DECIMAL(15,2) NOT NULL CHECK (amount >= 0),
    month DATE NOT NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    UNIQUE (user_id, jar_id, month)
);