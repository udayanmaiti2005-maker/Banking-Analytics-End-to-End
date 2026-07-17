describe branches;

CREATE VIEW vw_branch_performance AS

SELECT

b.Branch_ID,
b.Branch_Name,
b.City,
b.Manager_Name,

COALESCE(a.Number_of_Accounts,0) AS Number_of_Accounts,
COALESCE(a.Number_of_Customers,0) AS Number_of_Customers,
COALESCE(a.Total_Deposits,0) AS Total_Deposits,

COALESCE(t.Total_Transactions,0) AS Total_Transactions,
COALESCE(t.Total_Transaction_Value,0) AS Total_Transaction_Value,

COALESCE(l.Total_Approved_Loans,0) AS Total_Approved_Loans,
COALESCE(l.Total_Loan_Exposure,0) AS Total_Loan_Exposure


FROM branches b


LEFT JOIN
(
    SELECT

    Branch_ID,
    COUNT(Account_ID) AS Number_of_Accounts,
    COUNT(DISTINCT Customer_ID) AS Number_of_Customers,
    SUM(Balance) AS Total_Deposits

    FROM accounts

    GROUP BY Branch_ID

) a

ON b.Branch_ID = a.Branch_ID



LEFT JOIN
(
    SELECT

    ac.Branch_ID,
    COUNT(t.Transaction_ID) AS Total_Transactions,
    SUM(t.Amount) AS Total_Transaction_Value

    FROM transactions t

    JOIN accounts ac
    ON t.Account_ID = ac.Account_ID

    GROUP BY ac.Branch_ID

) t

ON b.Branch_ID = t.Branch_ID



LEFT JOIN
(
    SELECT

    cpb.Branch_ID,
    COUNT(l.Loan_ID) AS Total_Approved_Loans,
    SUM(l.Loan_Amount) AS Total_Loan_Exposure

    FROM approved_loan_portfolio l

    JOIN vw_customer_primary_branch cpb

    ON l.Customer_ID = cpb.Customer_ID

    GROUP BY cpb.Branch_ID

) l

ON b.Branch_ID = l.Branch_ID;

-- Validation Tests --------

-- Branch Count --
SELECT COUNT(*)
FROM vw_branch_performance;
SELECT COUNT(*)
FROM branches;

-- Deposit Validation --
SELECT SUM(Total_Deposits)
FROM vw_branch_performance;
SELECT SUM(Balance)
FROM accounts;

-- Transaction Validation --
SELECT SUM(Total_Transactions)
FROM vw_branch_performance;
SELECT COUNT(*)
FROM transactions;

-- Inspection of Inactive Branches --
SELECT *
FROM vw_branch_performance
WHERE Number_of_Customers = 0;

-- Loan Validation --
SELECT
SUM(Total_Approved_Loans) AS No_of_Loans,
SUM(Total_Loan_Exposure) AS Total_Loan_Exposure
FROM vw_branch_performance
WHERE Number_of_Customers > 0;

SELECT *
FROM vw_branch_performance;

SELECT

SUM(Total_Approved_Loans),
SUM(Total_Loan_Exposure)

FROM vw_branch_performance;

DROP VIEW IF EXISTS vw_branch_performance;

SELECT
SUM(Number_of_Customers),
SUM(Total_Deposits),
SUM(Total_Transactions),
SUM(Total_Loan_Exposure)
FROM vw_branch_performance
WHERE Number_of_Customers > 0;

SELECT
Branch_Name,
Number_of_Customers,
Manager_Name,
Total_Deposits,
Total_Transactions,
Total_Approved_Loans,
Total_Loan_Exposure

FROM vw_branch_performance

ORDER BY Total_Deposits DESC;


select *
from vw_loan_risk_analysis;
SELECT 
MIN(Loan_Amount)
FROM vw_approved_loan_portfolio;

SELECT 
COUNT(*) Account_ID
from accounts
GROUP BY Account_Type;