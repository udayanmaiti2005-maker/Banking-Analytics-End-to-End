CREATE VIEW vw_transaction_kpis AS

SELECT
COUNT(DISTINCT t.Account_ID) AS Active_Accounts,
COUNT(DISTINCT a.Customer_ID) AS Active_Customers,
COUNT(t.Transaction_ID) AS Total_Transactions,
SUM(t.Amount) AS Total_Transaction_Value,
AVG(t.Amount) AS Average_Transaction_Value

FROM transactions t

JOIN accounts a
ON t.Account_ID = a.Account_ID;

SELECT *
FROM vw_transaction_kpis;