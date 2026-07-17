# Accounts without Customers
SELECT 
a. Account_ID,
a. Customer_ID

FROM accounts a
LEFT JOIN customers c
ON a. Customer_ID = c. Customer_ID
WHERE c. Customer_ID IS NULL;

# Transactions without Accounts
SELECT
t. Transaction_ID,
t. Account_ID

FROM transactions t
LEFT JOIN accounts a
ON t. Account_ID = a. Account_ID
WHERE a. Account_ID IS NULL;

# Loans without Customers
SELECT 
l. Loan_ID,
l. Customer_ID

FROM Loans l
LEFT JOIN customers c
ON l. Customer_ID = c. Customer_ID
WHERE c. Customer_ID IS NULL;

# Customers without Accounts
SELECT
COUNT(*) AS Customers_Without_Accounts

FROM Customers c
LEFT JOIN Accounts a
ON c.Customer_ID = a.Customer_ID
WHERE a.Account_ID IS NULL;

# Accounts without Transactions
SELECT
COUNT(*) AS Inactive_Accounts

FROM Accounts a
LEFT JOIN Transactions t
ON a.Account_ID = t.Account_ID
WHERE t.Transaction_ID IS NULL;