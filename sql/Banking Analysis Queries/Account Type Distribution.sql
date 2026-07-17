# Account Type Distribution

SELECT 
    Account_Type, COUNT(*) AS Number_of_Accounts
FROM
    Accounts
GROUP BY Account_Type;