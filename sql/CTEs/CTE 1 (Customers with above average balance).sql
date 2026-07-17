# CTE 1 (Customers with above average account balances)

WITH Average_Balance AS
(
SELECT
AVG(Balance) AS Avg_Balance ### Temporary Table

FROM Accounts
) 


SELECT ### Main Query using the Temporary Table for comparision
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