describe transactions;

CREATE VIEW vw_customer_activity AS

SELECT
c.Customer_ID,
c.Name,
c.City,
c.Occupation,

COALESCE(a. Number_of_Accounts, 0) AS Number_of_Accounts,
COALESCE(a. Total_Balance, 0) AS Total_Balance,

COALESCE(t. Total_Transactions, 0) AS Total_Transactions,
COALESCE(t. Total_Transaction_Value, 0) AS Total_Transaction_Value,

CASE 

WHEN COALESCE(t.Total_Transactions,0) >= 30
THEN 'High Activity'

WHEN COALESCE(t.Total_Transactions,0) BETWEEN 10 AND 29
THEN 'Medium Activity'

ELSE 'Low Activity'

END AS Activity_Category

FROM customers c

LEFT JOIN
(
SELECT 
	Customer_ID,
	COUNT(Account_ID) AS Number_of_Accounts,
	Sum(Balance) AS Total_Balance

	FROM accounts
	GROUP BY Customer_ID	
) a

ON c. Customer_ID = a. Customer_ID

LEFT JOIN
(
	SELECT
	ac. Customer_ID,
	COUNT(t. Transaction_ID) AS Total_Transactions,
	SUM(t. Amount) AS Total_Transaction_Value

	FROM transactions t
	JOIN accounts ac
	ON t. Account_ID = ac. Account_ID
	GROUP BY ac. Customer_ID
) t

ON c. Customer_ID = t. Customer_ID;

SELECT *
FROM vw_customer_activity
ORDER BY Total_Transactions DESC;

-- Validation Tests -------

-- Customer Count --
SELECT COUNT(*)
FROM vw_customer_activity;

-- Transaction Count Validation --
SELECT SUM(Total_Transactions)
FROM vw_customer_activity;
SELECT COUNT(*)
FROM transactions;

-- Transaction Amount Validation --
SELECT SUM(Total_Transaction_Value)
FROM vw_customer_activity;
SELECT SUM(Amount)
FROM transactions;

-- DEposit Validation --
SELECT SUM(Total_Balance)
FROM vw_customer_activity;
SELECT SUM(Balance)
FROM accounts;

-- Activity Distribution Validation --
SELECT 
Activity_Category,
COUNT(*) AS Customer_Count

FROM vw_customer_activity
GROUP BY Activity_Category;