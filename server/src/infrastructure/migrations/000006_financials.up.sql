-- Create financial_summaries table
CREATE TABLE financial_summaries (
    user_id VARCHAR(255) PRIMARY KEY,
    income DECIMAL(15, 2) DEFAULT 0.0,
    expense DECIMAL(15, 2) DEFAULT 0.0,
    total_balance DECIMAL(15, 2) GENERATED ALWAYS AS (income - expense) STORED
);

-- Insert initial data for existing users based on transactions
INSERT INTO financial_summaries (user_id, income, expense)
SELECT 
    user_id,
    COALESCE(SUM(CASE WHEN type = 'income' THEN amount ELSE 0 END), 0) AS income,
    COALESCE(SUM(CASE WHEN type = 'expense' THEN amount ELSE 0 END), 0) AS expense
FROM transactions
GROUP BY user_id
ON CONFLICT (user_id) DO NOTHING;

-- Create function to update financial_summaries
CREATE OR REPLACE FUNCTION update_financial_summary()
RETURNS TRIGGER AS $$
BEGIN
    -- Handle INSERT
    IF (TG_OP = 'INSERT') THEN
        INSERT INTO financial_summaries (user_id, income, expense)
        VALUES (
            NEW.user_id,
            COALESCE((SELECT SUM(amount) FROM transactions WHERE user_id = NEW.user_id AND type = 'income'), 0),
            COALESCE((SELECT SUM(amount) FROM transactions WHERE user_id = NEW.user_id AND type = 'expense'), 0)
        )
        ON CONFLICT (user_id)
        DO UPDATE SET
            income = COALESCE((SELECT SUM(amount) FROM transactions WHERE user_id = NEW.user_id AND type = 'income'), 0),
            expense = COALESCE((SELECT SUM(amount) FROM transactions WHERE user_id = NEW.user_id AND type = 'expense'), 0);
        RETURN NEW;

    -- Handle UPDATE
    ELSIF (TG_OP = 'UPDATE') THEN
        INSERT INTO financial_summaries (user_id, income, expense)
        VALUES (
            NEW.user_id,
            COALESCE((SELECT SUM(amount) FROM transactions WHERE user_id = NEW.user_id AND type = 'income'), 0),
            COALESCE((SELECT SUM(amount) FROM transactions WHERE user_id = NEW.user_id AND type = 'expense'), 0)
        )
        ON CONFLICT (user_id)
        DO UPDATE SET
            income = COALESCE((SELECT SUM(amount) FROM transactions WHERE user_id = NEW.user_id AND type = 'income'), 0),
            expense = COALESCE((SELECT SUM(amount) FROM transactions WHERE user_id = NEW.user_id AND type = 'expense'), 0);

        -- Also update for OLD.user_id if user_id changes
        IF (OLD.user_id != NEW.user_id) THEN
            INSERT INTO financial_summaries (user_id, income, expense)
            VALUES (
                OLD.user_id,
                COALESCE((SELECT SUM(amount) FROM transactions WHERE user_id = OLD.user_id AND type = 'income'), 0),
                COALESCE((SELECT SUM(amount) FROM transactions WHERE user_id = OLD.user_id AND type = 'expense'), 0)
            )
            ON CONFLICT (user_id)
            DO UPDATE SET
                income = COALESCE((SELECT SUM(amount) FROM transactions WHERE user_id = OLD.user_id AND type = 'income'), 0),
                expense = COALESCE((SELECT SUM(amount) FROM transactions WHERE user_id = OLD.user_id AND type = 'expense'), 0);
        END IF;
        RETURN NEW;

    -- Handle DELETE
    ELSIF (TG_OP = 'DELETE') THEN
        INSERT INTO financial_summaries (user_id, income, expense)
        VALUES (
            OLD.user_id,
            COALESCE((SELECT SUM(amount) FROM transactions WHERE user_id = OLD.user_id AND type = 'income'), 0),
            COALESCE((SELECT SUM(amount) FROM transactions WHERE user_id = OLD.user_id AND type = 'expense'), 0)
        )
        ON CONFLICT (user_id)
        DO UPDATE SET
            income = COALESCE((SELECT SUM(amount) FROM transactions WHERE user_id = OLD.user_id AND type = 'income'), 0),
            expense = COALESCE((SELECT SUM(amount) FROM transactions WHERE user_id = OLD.user_id AND type = 'expense'), 0);
        RETURN OLD;
    END IF;
    RETURN NULL;
END;
$$ LANGUAGE plpgsql;

-- Create trigger for INSERT on transactions table
CREATE TRIGGER after_transaction_insert
AFTER INSERT ON transactions
FOR EACH ROW
EXECUTE FUNCTION update_financial_summary();

-- Create trigger for UPDATE on transactions table
CREATE TRIGGER after_transaction_update
AFTER UPDATE ON transactions
FOR EACH ROW
EXECUTE FUNCTION update_financial_summary();

-- Create trigger for DELETE on transactions table
CREATE TRIGGER after_transaction_delete
AFTER DELETE ON transactions
FOR EACH ROW
EXECUTE FUNCTION update_financial_summary();