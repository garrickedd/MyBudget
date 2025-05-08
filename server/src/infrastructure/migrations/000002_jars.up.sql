CREATE TABLE jars (
    id SERIAL PRIMARY KEY,
    user_id uuid NOT NULL REFERENCES users(id_user) ON DELETE CASCADE,
    name VARCHAR(50) NOT NULL,
    percentage DECIMAL(5,2) NOT NULL CHECK (percentage >= 0 AND percentage <= 100),
    balance DECIMAL(15,2) NOT NULL DEFAULT 0.00,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Insert default jars for each existing user
INSERT INTO jars (user_id, name, percentage)
SELECT id_user, 'Necessities', 55.00 FROM users
UNION ALL
SELECT id_user, 'Long-Term Savings', 10.00 FROM users
UNION ALL
SELECT id_user, 'Education', 10.00 FROM users
UNION ALL
SELECT id_user, 'Play', 10.00 FROM users
UNION ALL
SELECT id_user, 'Financial Freedom', 10.00 FROM users
UNION ALL
SELECT id_user, 'Give', 5.00 FROM users;