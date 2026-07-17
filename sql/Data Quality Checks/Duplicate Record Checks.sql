# Duplicate Customers
SELECT Customer_ID,
COUNT(*) AS Duplicate_Count
FROM customers
GROUP BY Customer_ID
HAVING COUNT(*) > 1;

# Duplicate Accounts
SELECT Account_ID,
COUNT(*) AS Duplicate_Count
FROM accounts
GROUP BY Account_ID
HAVING COUNT(*) > 1;

# Duplicate Transactions
SELECT 
Account_ID,
Transaction_Date,
Amount,
Transaction_Type,
COUNT(*) AS Duplicate_Count

FROM transactions
GROUP BY 

Account_ID,
Transaction_Date,
Amount,
Transaction_Type

HAVING COUNT(*) > 1;

# Duplicate Loans
SELECT Loan_ID,
COUNT(*) AS Duplicate_Count

FROM loans
GROUP BY Loan_ID
HAVING COUNT(*) > 1;