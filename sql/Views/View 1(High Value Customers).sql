#View 1: High Value Customers

CREATE VIEW High_Value_Customer AS

SELECT

c. Customer_ID,
c. Name,
c. City,
a. Account_ID,
a. Balance

FROM Customers c
JOIN Accounts a 

ON c. Customer_ID = a. Customer_ID

WHERE Balance > 1000000;

SELECT * 
FROM High_Value_Customer
ORDER BY Balance DESC;
