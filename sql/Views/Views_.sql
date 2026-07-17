USE banking_analytics_db;

# View 1 (High Value Customers)
CREATE VIEW High_Value_Customer AS
    SELECT 
        c.Customer_ID, c.Name, c.City, a.Account_ID, a.Balance
    FROM
        Customers c
            JOIN
        Accounts a ON c.Customer_ID = a.Customer_ID
    WHERE
        Balance > 1000000;

SELECT 
    *
FROM
    High_Value_Customer
ORDER BY Balance DESC;

# View 2 (Branch Performance)
CREATE VIEW Branch_Performance AS
    SELECT 
        b.Branch_ID,
        b.Branch_Name,
        b.City,
        COUNT(a.Account_ID) AS Total_Accounts,
        SUM(a.Balance) AS Total_Deposits,
        AVG(a.Balance) AS Average_Balance
    FROM
        Branches b
            JOIN
        Accounts a ON b.Branch_ID = a.Branch_ID
    GROUP BY b.Branch_ID , b.Branch_Name , b.City;

SELECT 
    *
FROM
    Branch_Performance
ORDER BY Total_Deposits DESC;

# View 3 (Customer Account Summary)
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

# View 4 (Loan Portfolio Summary)
CREATE VIEW Loan_Portfolio_Summary AS

SELECT

l. Loan_ID,
c. Name,
c. City,
l. Loan_Type,
l. Loan_Amount,
l. Loan_Status

FROM Loans l
JOIN Customers c
ON l. Customer_ID = c. Customer_ID;

# View 5 (Customer Risk View)
CREATE VIEW Customer_Risk_View AS

SELECT
c. Customer_ID,
c. Name,
c. Annual_Income,
l. Loan_Amount,

ROUND(
l. Loan_Amount / c. Annual_Income,
2 ### 2 decimal Places
)
AS Loan_Income_Ratio

FROM customers c
JOIN loans l

ON c. Customer_ID = l.Customer_ID;

SELECT *
FROM Customer_Risk_View
ORDER BY Loan_Income_Ratio DESC
LIMIT 20;

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

# View 7: Customer Status View
CREATE VIEW Customer_Status_Analysis AS

SELECT
c. Customer_ID,
c. Name,

CASE
WHEN 
a. Account_ID IS NULL
THEN 'Inactive Customer'
ELSE 'Active Customer'

END AS Customer_Status
FROM Customers c
LEFT JOIN Accounts a 
ON c. Customer_ID = a. Customer_ID
;

# Testing Views
SHOW FULL TABLES
WHERE Table_Type = 'VIEW';