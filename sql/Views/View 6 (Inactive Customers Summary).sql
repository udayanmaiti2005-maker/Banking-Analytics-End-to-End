# View 6: Inactive Customers Summary
CREATE VIEW Inactive_Customers AS

SELECT
c.Customer_ID,
c.Name,
c.City,
c.Occupation,
c.Annual_Income

FROM Customers c
LEFT JOIN Accounts a
ON c.Customer_ID = a.Customer_ID

WHERE a.Account_ID IS NULL;