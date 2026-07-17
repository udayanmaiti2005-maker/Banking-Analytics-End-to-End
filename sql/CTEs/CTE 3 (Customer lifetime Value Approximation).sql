# CTE 3 (Customer Lifetime Value Approximation)

WITH Customer_Transaction_Value AS
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
c. Customer_ID,
c. Name,
c. City,
ct. Total_Transaction_Value

FROM Customers c
JOIN Customer_Transaction_Value ct
ON c. Customer_ID = ct. Customer_ID

ORDER BY Total_Transaction_Value DESC
LIMIT 20;