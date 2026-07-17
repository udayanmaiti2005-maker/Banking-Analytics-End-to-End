## Executive KPI View ##

CREATE VIEW vw_executive_kpis AS

SELECT
(SELECT COUNT(*) FROM Customers) AS Total_Customers,

(SELECT COUNT(*) FROM Accounts) AS Total_Accounts,

(SELECT SUM(Balance) FROM Accounts) AS Total_Deposits,

(SELECT COUNT(*) FROM transactions) AS Total_Transactions,

(SELECT COUNT(*) FROM loans) AS Total_Loan_Applications,

(SELECT SUM(Loan_Amount) FROM approved_loan_portfolio) AS Approved_Loan_Portfolio,

(SELECT ROUND(AVG(Balance), 2) FROM accounts) AS Average_Account_Balance;

SELECT *
FROM vw_executive_kpis;