USE banking_analytics_db;

SELECT 
    c.Customer_ID, c.City, a.Account_ID, a.Branch_ID
FROM
    Customers c
        JOIN
    Accounts a ON c.Customer_ID = a.Customer_ID
LIMIT 20;

SELECT 
    *
FROM
    Branches;

UPDATE Accounts a
        JOIN
    Customers c ON a.Customer_ID = c.Customer_ID 
SET 
    Branch_ID = CASE
        WHEN c.City = 'Kolkata' THEN 100
        WHEN c.City = 'Delhi' THEN 101
        WHEN c.City = 'Mumbai' THEN 102
        WHEN c.City = 'Bangalore' THEN 103
        WHEN c.City = 'Chennai' THEN 104
        WHEN c.City = 'Pune' THEN 105
        WHEN c.City = 'Hyderabad' THEN 106
        WHEN c.City = 'Ahmedabad' THEN 107
    END;

SELECT 
    c.City, b.Branch_Name, COUNT(a.Account_ID) AS Accounts
FROM
    Customers c
        JOIN
    Accounts a ON c.Customer_ID = a.Customer_ID
        JOIN
    Branches b ON a.Branch_ID = b.Branch_ID
GROUP BY c.City , b.Branch_Name;

SELECT 
    COUNT(*)
FROM
    Accounts;

SELECT 
    COUNT(DISTINCT Branch_ID)
FROM
    Accounts;

SELECT 
    c.City AS Customer_City,
    b.City AS Branch_City,
    COUNT(a.Account_ID) AS Number_of_Accounts
FROM
    Customers c
        JOIN
    Accounts a ON c.Customer_ID = a.Customer_ID
        JOIN
    Branches b ON a.Branch_ID = b.Branch_ID
GROUP BY c.City , b.City;

SELECT 
    COUNT(*) AS Incorrect_Matches
FROM
    Customers c
        JOIN
    Accounts a ON c.Customer_ID = a.Customer_ID
        JOIN
    Branches b ON a.Branch_ID = b.Branch_ID
WHERE
    c.City <> b.City;