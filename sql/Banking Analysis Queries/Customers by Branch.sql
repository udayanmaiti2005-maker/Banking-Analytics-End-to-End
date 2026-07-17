# Customers by Branch

SELECT

b. Branch_Name,

COUNT(a. Customer_ID)

AS Customers

FROM Branches b
JOIN Accounts a

ON b. Branch_ID = a. Branch_ID

GROUP BY b. Branch_Name
ORDER BY Customers DESC;