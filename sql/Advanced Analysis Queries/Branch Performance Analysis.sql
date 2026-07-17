---------------## BRANCH PERFORMANCE ANALYSIS ## -----------------

-- 1. Branch Customer Base Performance -----
SELECT
b. Branch_ID,
b. Branch_Name,
b. City,

COUNT(DISTINCT c. Customer_ID) AS Total_Customers

FROM customers c
JOIN accounts a
ON c. Customer_ID = a. Customer_ID

JOIN branches b
ON a. Branch_ID = b. Branch_ID

GROUP BY 
b. Branch_ID,
b. Branch_Name,
b. City

ORDER BY Total_Customers DESC;

-- 2. Deposit performance by Branch -----
SELECT
b. Branch_ID,
b. Branch_Name,
b. City,

COUNT(DISTINCT a. Account_ID) AS Total_Accounts,
SUM(a. Balance) AS Total_Deposit_Value,

ROUND(
AVG(a. Balance),
2
) AS Average_Account_Balance

FROM accounts a
JOIN branches b
ON a. Branch_ID = b. Branch_ID

GROUP BY
b. Branch_ID,
b. Branch_Name,
b. City

ORDER BY Total_Deposit_Value DESC;

-- 3. Transaction Activity by Branch ------
SELECT
b. Branch_ID,
b. Branch_Name,
b. City,

COUNT(t. Transaction_ID) AS Total_Transactions,
SUM(t. Amount) AS Total_Transaction_Value,

ROUND(
AVG(t. Amount),
2
) AS Average_Transaction_Size

FROM transactions t
JOIN accounts a
ON t. Account_ID = a. Account_ID

JOIN branches b
ON a. Branch_ID = b. Branch_ID

GROUP BY
b. Branch_ID,
b. Branch_Name,
b. City

ORDER BY Total_Transaction_Value DESC;

-- 4. Loan Contribution by Branch --------
WITH Customer_Branch AS

(
SELECT
Customer_ID,
MIN(Branch_ID) AS Branch_ID

FROM Accounts
GROUP BY Customer_ID
)

SELECT
COALESCE(b.Branch_ID,999) AS Branch_ID,
COALESCE(b.Branch_Name,'Unknown Branch') AS Branch_Name,
COALESCE(b.City,'Unknown') AS City,

COUNT(l.Loan_ID) AS Approved_Loans,
SUM(l.Loan_Amount) AS Total_Loan_Contribution,

ROUND(
AVG(l.Loan_Amount),
2
) AS Average_Loan_Size,

ROUND(
SUM(l.Loan_Amount) * 100.0 /
(SELECT SUM(Loan_Amount) FROM Approved_Loan_Portfolio),
3
) AS Portfolio_Contribution_Percentage

FROM Approved_Loan_Portfolio l
LEFT JOIN Customer_Branch cb
ON l.Customer_ID = cb.Customer_ID

LEFT JOIN Branches b
ON cb.Branch_ID = b.Branch_ID

GROUP BY
b.Branch_ID,
b.Branch_Name,
b.City

ORDER BY Total_Loan_Contribution DESC;

-- 5. Overall Branch Performance Ranking --------
WITH Branch_Performance AS
(
SELECT
b.Branch_ID,
b.Branch_Name,
b.City,

COUNT(DISTINCT c. Customer_ID) AS Customers,
SUM(DISTINCT a. Balance) AS Deposits

FROM branches b
LEFT JOIN accounts a
ON b. Branch_ID = a. Branch_ID

LEFT JOIN customers c
ON a. Customer_ID = c. Customer_ID

GROUP BY 
b.Branch_ID,
b.Branch_Name,
b.City
)

SELECT *
FROM Branch_Performance
ORDER BY Deposits DESC;