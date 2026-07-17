# Missing Customer Information
SELECT *
FROM Customers 
WHERE Customer_ID IS NULL
OR Name IS NULL
OR City IS NULL
OR Occupation IS NULL;

# Missing Account Information
SELECT *
FROM accounts
WHERE Account_ID IS NULL
OR Customer_ID IS NULL
OR Account_Type IS NULL
OR Balance IS NULL;

# Missing Transaction Information
SELECT *
FROM transactions
WHERE Transaction_ID IS NULL
OR Account_ID IS NULL
OR Transaction_Date IS NULL
OR Amount IS NULL;

# Missing Loan Information
SELECT *
FROM loans
WHERE Loan_ID IS NULL
OR Customer_ID IS NULL
OR Loan_Amount IS NULL
OR Loan_Status IS NULL;