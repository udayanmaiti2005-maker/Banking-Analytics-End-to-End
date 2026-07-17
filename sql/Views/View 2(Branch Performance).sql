# Branch Performance
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