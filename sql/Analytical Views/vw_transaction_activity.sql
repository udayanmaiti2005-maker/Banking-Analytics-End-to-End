CREATE VIEW vw_transaction_activity AS

SELECT
    DATE_FORMAT(Transaction_Date, '%Y-%m') AS Transaction_Month,
    Transaction_Type,

    COUNT(Transaction_ID) AS Number_of_Transactions,

    SUM(Amount) AS Total_Transaction_Value,

    AVG(Amount) AS Average_Transaction_Value,

    COUNT(DISTINCT Account_ID) AS Active_Accounts,

    COUNT(DISTINCT Customer_ID) AS Active_Customers

FROM
(
    SELECT
        t.Transaction_ID,
        t.Account_ID,
        a.Customer_ID,
        t.Transaction_Date,
        t.Transaction_Type,
        t.Amount
    FROM transactions t
    JOIN accounts a
        ON t.Account_ID = a.Account_ID
) x

GROUP BY
    DATE_FORMAT(Transaction_Date,'%Y-%m'),
    Transaction_Type;
    
SELECT *
FROM vw_transaction_activity;    
    
SELECT
Transaction_Month, 
SUM(Total_Transaction_Value) AS Total_Transaction_Value
FROM vw_transaction_activity
GROUP BY Transaction_Month;    