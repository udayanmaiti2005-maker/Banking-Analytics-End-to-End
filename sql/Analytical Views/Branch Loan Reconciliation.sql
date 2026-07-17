# Branch Loan Reconciliation view

CREATE VIEW vw_branch_loan_reconciliation AS

SELECT
'Assigned Branch Loans' AS Category,
COUNT(l.Loan_ID) AS Number_of_Loans,
SUM(l.Loan_Amount) AS Loan_Exposure

FROM approved_loan_portfolio l

JOIN vw_customer_primary_branch cpb

ON l.Customer_ID = cpb.Customer_ID


UNION ALL


SELECT
'Unassigned Loans' AS Category,
COUNT(l.Loan_ID) AS Number_of_Loans,
SUM(l.Loan_Amount) AS Loan_Exposure

FROM approved_loan_portfolio l

LEFT JOIN vw_customer_primary_branch cpb

ON l.Customer_ID = cpb.Customer_ID

WHERE cpb.Customer_ID IS NULL


UNION ALL


SELECT
'Total Loan Portfolio' AS Category,
COUNT(Loan_ID),
SUM(Loan_Amount)

FROM approved_loan_portfolio;

SELECT *
FROM vw_branch_loan_reconciliation;

DROP VIEW IF EXISTS vw_branch_loan_reconciliation;

SELECT
Customer_ID,
COUNT(DISTINCT Branch_ID) AS Number_of_Branches
FROM accounts
GROUP BY Customer_ID
HAVING COUNT(DISTINCT Branch_ID) > 1;

SELECT
Customer_ID,
COUNT(Loan_ID) AS Number_of_Loans
FROM approved_loan_portfolio
GROUP BY Customer_ID
HAVING COUNT(Loan_ID) > 1;

SELECT
l.Customer_ID,
COUNT(l.Loan_ID) AS Loans,
COUNT(a.Account_ID) AS Accounts
FROM approved_loan_portfolio l
JOIN accounts a
ON l.Customer_ID = a.Customer_ID
GROUP BY l.Customer_ID
HAVING COUNT(a.Account_ID) > 1;

SELECT
COUNT(DISTINCT Customer_ID) AS Loan_Customers,
COUNT(DISTINCT Loan_ID) AS Loans,
SUM(Loan_Amount) AS Exposure
FROM approved_loan_portfolio;

SELECT
Customer_ID,
COUNT(Account_ID)
FROM accounts
GROUP BY Customer_ID
HAVING COUNT(Account_ID)>1;

DESCRIBE accounts;

SELECT
Customer_ID,
Account_ID,
Branch_ID,
Opening_Date
FROM accounts a
WHERE Opening_Date =
(
    SELECT MIN(Opening_Date)
    FROM accounts a2
    WHERE a2.Customer_ID = a.Customer_ID
)
LIMIT 20;