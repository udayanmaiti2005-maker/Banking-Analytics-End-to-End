# Most Active accounts

SELECT 
    Account_ID, COUNT(Transaction_ID) AS Number_of_Transactions
FROM
    Transactions
GROUP BY Account_ID
ORDER BY Number_of_Transactions DESC
LIMIT 10;