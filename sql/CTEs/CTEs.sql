# CTE 1 (Customers with above average account balances)
WITH Average_Balance AS
(
SELECT
AVG(Balance) AS Avg_Balance

FROM Accounts
)

SELECT

c. Customer_ID,
c. Name,
c. City,
a. Balance,

ROUND(
a.Balance - ab.Avg_Balance,
2
)
AS Difference_From_Average

FROM customers c
JOIN accounts a
ON c. Customer_ID = a. Customer_ID

CROSS JOIN Average_Balance ab
WHERE a. Balance > ab. Avg_Balance
ORDER BY a. Balance DESC;

# CTE 2 (Monthly Transaction Analysis)
WITH Monthly_Transactions AS
(
SELECT 
MONTH(Transaction_Date) AS Transaction_Month,

COUNT(Transaction_ID)
AS Total_transactions,

SUM(Amount)
AS Total_Amount

FROM transactions

GROUP BY MONTH(Transaction_Date)
)

SELECT *
FROM Monthly_Transactions
ORDER BY Total_Transactions DESC;

# CTE 3 (Customer Lifetime Value Approximation)
WITH Customer_Transaction_Value AS  ### Temporary Table Creation
(
SELECT
a. Customer_ID,

SUM(t. Amount)
AS Total_Transaction_Value

FROM Accounts a
JOIN Transactions t
ON a. Account_ID = t. Account_ID

GROUP BY a. Customer_ID
)

SELECT  ### Joining with customer information
c. Name,
c. City,
ct. Total_Transaction_Value

FROM Customers c
JOIN Customer_Transaction_Value ct
ON c. Customer_ID = ct. Customer_ID

ORDER BY Total_Transaction_Value DESC
LIMIT 20;

# CTE 4 (Loan Risk Categorization)
WITH Loan_Risk AS
(
SELECT
c. Customer_ID,
c. Name,
c. Annual_Income,
l. Loan_Amount,

### Calculation of Loan Risk
ROUND(
l. Loan_Amount / c. Annual_Income, 
2
)
AS Loan_Income_Ratio

FROM Customers c
JOIN loans l
ON c. Customer_ID = l. Customer_ID
)

SELECT
*,

### Classification of Loan Risk
CASE
WHEN Loan_Income_Ratio > 5
THEN 'High_Risk'

WHEN Loan_Income_Ratio BETWEEN 2 AND 5
THEN 'Medium_Risk'

ELSE 'Low_Risk'

END AS Risk_Category
FROM Loan_Risk
;

# CTE 5 (Branch Deposit Ranking)
WITH Branch_Deposits AS
(
SELECT 
b. Branch_Name,

SUM(a. Balance)
AS Total_Deposits

FROM Branches b
JOIN Accounts a
ON b. Branch_ID = a. Branch_ID

GROUP BY b. Branch_Name
)

SELECT * 
FROM Branch_Deposits
ORDER BY Total_Deposits DESC
;