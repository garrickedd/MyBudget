-- Drop triggers
DROP TRIGGER IF EXISTS after_transaction_insert ON transactions;
DROP TRIGGER IF EXISTS after_transaction_update ON transactions;
DROP TRIGGER IF EXISTS after_transaction_delete ON transactions;

-- Drop function
DROP FUNCTION IF EXISTS update_financial_summary;

-- Drop financial_summaries table
DROP TABLE IF EXISTS financial_summaries;