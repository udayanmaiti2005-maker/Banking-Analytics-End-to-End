# WF 1: Rank Customers by Balance

SELECT
c. Customer_ID,
c. Name,
c. City,
a. Balance,

RANK()
OVER(
ORDER BY a. Balance DESC
)
AS Customer_Rank

FROM customers c
JOIN accounts a
ON c. Customer_ID = a. Customer_ID;