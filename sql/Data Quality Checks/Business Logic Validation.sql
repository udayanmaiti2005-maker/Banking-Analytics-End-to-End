# Negative Account Balances
SELECT
Account_ID,
Customer_ID,
Balance

FROM accounts
WHERE Balance < 0;

# Negative Transaction Amount
SELECT
Transaction_ID,
Account_ID,
Amount,
Transaction_Type

FROM transactions
WHERE Amount <= 0;

# Invalid Customer Age
SELECT
Customer_ID,
Name,
Age

FROM customers
WHERE Age <= 18
OR Age >=100;

# Invalid Annual Income
SELECT 
Customer_ID,
Name,
Annual_Income

FROM customers
WHERE Annual_Income <= 0;

# Unrealistic Loan Amounts
SELECT 
MIN(Loan_Amount) AS Minimum_Loan, #Inspection of Loan Range
MAX(Loan_Amount) AS Maximum_Loan,
AVG(Loan_Amount) AS Average_Loan

FROM Loans;

SELECT *
FROM loans
WHERE Loan_Amount > 10000000; # A loan above 1 crore would be a home, business or corporate loan.

# Invalid Interest Rates
SELECT
Loan_ID,
Loan_Type,
Interest_Rate

FROM loans
WHERE Interest_Rate <= 0
OR Interest_Rate >= 30;

# Transaction Date Validation
SELECT 
Transaction_ID,
Transaction_Date

FROM transactions
WHERE Transaction_Date > CURDATE();