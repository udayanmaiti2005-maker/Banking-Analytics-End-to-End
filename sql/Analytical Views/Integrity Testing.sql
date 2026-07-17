## Transaction --> Account integrity ##
SELECT COUNT(*) AS Missing_Accounts
FROM transactions t
LEFT JOIN accounts a
ON t. Account_ID = a. Account_ID
WHERE a. Account_ID IS NULL;

## Account --> Customer integrity ##
SELECT COUNT(*) AS Missing_Customers
FROM accounts a
LEFT JOIN customers c
ON a. Customer_ID = c. Customer_ID
WHERE c. Customer_ID IS NULL;

## Loan --> Customer integrity ##
SELECT COUNT(*) AS Missing_Loan_Customers
FROM approved_loan_portfolio l
LEFT JOIN customers c
ON l. Customer_ID = c. Customer_ID
WHERE c. Customer_ID IS NULL;