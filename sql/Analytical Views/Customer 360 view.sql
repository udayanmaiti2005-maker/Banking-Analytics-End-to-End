## Customer360 View ##

CREATE VIEW vw_customer_360 AS

SELECT
c.Customer_ID,
c.Name,
c.City,
c.Occupation,
c.Annual_Income,

-- Account Metrics
COALESCE(a.Number_of_Accounts,0) AS Number_of_Accounts,
COALESCE(a.Total_Balance,0) AS Total_Balance,


-- Transaction Metrics
COALESCE(t.Total_Transactions,0) AS Total_Transactions,
COALESCE(t.Total_Transaction_Value,0) AS Total_Transaction_Value,

-- Loan Metrics
COALESCE(l.Total_Approved_Loans,0) AS Total_Approved_Loans,
COALESCE(l.Total_Loan_Exposure,0) AS Total_Loan_Exposure

FROM customers c

-- Account Summary
LEFT JOIN
(
    SELECT
    Customer_ID,
    COUNT(Account_ID) AS Number_of_Accounts,
    SUM(Balance) AS Total_Balance
    
    FROM accounts
    GROUP BY Customer_ID
) a
ON c.Customer_ID = a.Customer_ID

-- Transaction Summary
LEFT JOIN
(
    SELECT
    ac.Customer_ID,
    COUNT(t.Transaction_ID) AS Total_Transactions,
    SUM(t.Amount) AS Total_Transaction_Value

    FROM transactions t
    JOIN accounts ac
    ON t.Account_ID = ac.Account_ID
    GROUP BY ac.Customer_ID
) t
ON c.Customer_ID = t.Customer_ID

-- Loan Summary
LEFT JOIN
(
    SELECT
    Customer_ID,
    COUNT(Loan_ID) AS Total_Approved_Loans,
    SUM(Loan_Amount) AS Total_Loan_Exposure

    FROM approved_loan_portfolio
    GROUP BY Customer_ID
) l
ON c.Customer_ID = l.Customer_ID;


-- Validation Tests --
SELECT COUNT(*)
FROM vw_customer_360;

SELECT *
FROM vw_customer_360
WHERE Customer_ID IS NULL;

-- Balance Validation
SELECT SUM(Total_Balance)
FROM vw_customer_360;

SELECT SUM(Balance)
FROM accounts;

-- Transaction Validation
SELECT SUM(Total_Transactions)
FROM vw_customer_360;

SELECT COUNT(*)
FROM transactions;

-- Loan Validation --
SELECT SUM(Total_Loan_Exposure)
FROM vw_customer_360;

SELECT SUM(Loan_Amount)
FROM approved_loan_portfolio;