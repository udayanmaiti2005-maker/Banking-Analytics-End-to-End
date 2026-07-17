-- ### Product Analysis ### --------------

-- 1. Account Product Analysis  -------
SELECT
Account_Type,

COUNT(Account_ID) AS Number_of_Accounts,
COUNT(DISTINCT Customer_ID) AS Number_of_Customers,
SUM(Balance) AS Total_Deposit_Value,

ROUND(
AVG(Balance),
2
) AS Average_Account_Balance

FROM Accounts
GROUP BY Account_Type
ORDER BY Number_of_Accounts DESC;

-- 2. Loan Product Analysis -------
SELECT 
Loan_Type,

COUNT(Loan_ID) AS Number_of_Approved_Loans,
SUM(Loan_Amount) AS Total_Loan_Exposure,

ROUND(
AVG(Loan_Amount),
2
) AS Average_Loan_Size,

ROUND(
SUM(Loan_Amount) * 100.0 /
(
SELECT SUM(Loan_Amount)
FROM Approved_Loan_Portfolio
),
2
) AS Portfolio_Cotribution_Percentage

FROM approved_loan_portfolio
GROUP BY Loan_Type
ORDER BY Total_Loan_Exposure DESC;

-- 3. Customer Product Adoption Analysis ------
WITH Customer_Products AS
(
SELECT
c. Customer_ID,
c. Name,

COUNT(DISTINCT a. Account_ID) AS Number_of_Accounts,
COUNT(DISTINCT l. Loan_ID) AS Number_of_Loans

FROM customers c
LEFT JOIN accounts a
ON c. Customer_ID = a. Customer_ID

LEFT JOIN  approved_loan_portfolio l
ON c. Customer_ID = l. Customer_ID

GROUP BY
c. Customer_ID,
c. Name
)

SELECT 
Customer_ID, 
Name,
Number_of_Accounts,
Number_of_Loans,

(Number_of_Accounts + Number_of_Loans) AS Total_Products
FROM Customer_Products
ORDER BY Total_Products DESC;

-- 4. Product Contribution Ranking --------

-- Account Product Contribution --
SELECT

'Account Product' AS Product_Category,
Account_Type AS Product_Name,
COUNT(Account_ID) AS Product_Count,
SUM(Balance) AS Product_Value

FROM accounts
GROUP BY Account_Type

UNION ALL

-- Loan Product Contribution --
SELECT

'Loan Product' AS Product_Category,
Loan_Type AS Product_Name,
COUNT(Loan_ID) AS Product_Count,
SUM(Loan_Amount) AS Product_Value

FROM approved_loan_portfolio
GROUP BY Loan_Type
ORDER BY Product_Value DESC;