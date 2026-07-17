# SP 4: Customer Transaction Summary
DELIMITER //

CREATE PROCEDURE sp_Get_Customer_Transaction_Summary
(
IN cust_id_input INT
)

BEGIN

SELECT
c. Customer_ID,
c. Name,

COUNT(t. Transaction_ID)
AS Total_Transactions,

COALESCE(
SUM(t. Amount),
0
)
AS Total_Transaction_Value,

COALESCE(
AVG(t. Amount),
0
)
AS Average_Transaction_Value

FROM customers c
LEFT JOIN accounts a 
ON c. Customer_ID = a. Customer_ID

LEFT JOIN transactions t
ON a. Account_ID = t. Account_ID
WHERE c. Customer_ID = cust_id_input

GROUP BY
c. Customer_ID,
c. Name;

END //

CALL sp_Get_Customer_Transaction_Summary(10013);