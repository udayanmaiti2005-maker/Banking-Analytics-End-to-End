# Transaction index
CREATE INDEX idx_transactions_date
ON transactions(Transaction_Date);

# Verification

SHOW INDEX FROM Transactions;

# Performance Testing
EXPLAIN
SELECT *
FROM Transactions
WHERE Transaction_Date = '2023-06-16'