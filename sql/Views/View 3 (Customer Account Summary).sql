# Customer Account Summary

CREATE VIEW Customer_Account_Summary AS
SELECT

c. Customer_ID,
c. Name,
c. City,
c. Occupation,
c. Annual_Income,

a. Account_ID,
a. Account_Type,
a. Balance

FROM Customers c
JOIN Accounts a
ON c. Customer_ID = a. Customer_ID;

SELECT * 
FROM Customer_Account_Summary
LIMIT 10;	