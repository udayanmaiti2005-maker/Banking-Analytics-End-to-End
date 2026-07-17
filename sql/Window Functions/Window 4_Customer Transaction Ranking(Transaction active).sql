# WF 4: Customer Transaction Ranking (Transaction-active customers)

WITH Customer_Transactions AS
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

SELECT 
c. Name,
ct. Total_Transaction_Value,

RANK()
OVER(
ORDER BY ct. Total_Transaction_Value DESC
)
AS Customer_Rank
FROM Customers c
JOIN Customer_Transactions ct
ON c. Customer_ID = ct. Customer_ID
;