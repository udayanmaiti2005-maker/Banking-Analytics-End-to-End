# Deposit vs. Withdrawal Analysis

SELECT 
    Transaction_Type,
    COUNT(*) AS Number_of_Transactions,
    SUM(Amount) AS Total_Amount
FROM
    Transactions
GROUP BY Transaction_Type;