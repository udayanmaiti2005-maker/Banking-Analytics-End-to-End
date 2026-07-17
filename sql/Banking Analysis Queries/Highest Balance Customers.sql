# Highest Balance Customers

SELECT 
    c.Name,
    c.City,
    a.Balance
FROM
    Customers c
JOIN
    Accounts a 
ON 
	c.Customer_ID = a.Customer_ID
ORDER BY a.Balance DESC
LIMIT 10;