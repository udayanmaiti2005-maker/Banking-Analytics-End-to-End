--------------- ### CUSTOMER ACTIVITY ANALYSIS ### -------------

-- 1. Customer Transaction Frequency -------
SELECT 
c. Customer_ID,
c. Name,

COUNT(t. Transaction_ID) AS Total_Transactions,
SUM(t. Amount) AS Total_Transaction_Value,

ROUND(
AVG(t. Amount),
2
) AS Average_Transaction_Size

FROM customers c
JOIN accounts a
ON c. Customer_ID = a. Customer_ID

JOIN transactions t
ON a. Account_ID = t. Account_ID

GROUP BY 
c. Customer_ID,
c. Name
ORDER BY Total_Transactions DESC
LIMIT 20;

-- 2. Customer Deposit Behaviour ------
SELECT 
c. Customer_ID,
c. Name,

COUNT(a. Account_ID) AS Number_of_Accounts,
SUM( a. Balance) AS Total_Deposit_Balance,

ROUND(
AVG(a. Balance),
2
) AS Average_Account_Balance

FROM customers c
JOIN accounts a
ON c. Customer_ID = a. Customer_ID

GROUP BY 
c. Customer_ID,
c. Name

ORDER BY Total_Deposit_Balance DESC
LIMit 20;

-- 3. Customer Transaction Behaviour Segmentation ----------
WITH Customer_Activity AS
(

SELECT 
c. Customer_ID,
c. Name,

COUNT(t. Transaction_ID) AS Total_Transactions,
SUM(t. Amount) AS Total_Transaction_Value

FROM customers c
JOIN accounts a
ON c. Customer_ID = a. Customer_ID

JOIN transactions t
ON a. Account_ID = t. Account_ID

GROUP BY 
c. Customer_ID,
c. Name
)

SELECT
Customer_ID,
Name,
Total_Transactions,
Total_Transaction_Value,

CASE
WHEN Total_Transactions >= 40
THEN 'High Activity'

WHEN Total_Transactions BETWEEN 15 AND 39
THEN 'Moderate Activity'

ELSE 'Low Activity'

END AS Transaction_Activity_Category

FROM Customer_Activity

ORDER BY Total_Transactions DESC;

-- 4. Customer Engagement Score and Category -------
WITH Customer_Metrics AS
(
SELECT 
c. Customer_ID,
c. Name,

COUNT(DISTINCT a. Account_ID) AS Number_of_Accounts,
COALESCE(SUM(a. Balance),0) AS Total_Deposit_Balance,
COUNT(t. Transaction_ID) AS Total_Transactions

FROM customers c
LEFT JOIN accounts a
ON c. Customer_ID = a. Customer_ID

LEFT JOIN transactions t
ON a. Account_ID = t. Account_ID

GROUP BY
c. Customer_ID,
c. Name
),


Engagement_Score AS
(

SELECT 
Customer_ID,
Name,
Number_of_Accounts,
Total_Deposit_Balance,
Total_Transactions,

(
CASE 
WHEN Total_Transactions >= 30 THEN 3
WHEN Total_Transactions >= 10 THEN 2
ELSE 1
END

+

CASE
WHEN Total_Deposit_Balance >= 1000000 THEN 3
WHEN Total_Deposit_Balance >= 200000 THEN 2
ELSE 1
END

+

CASE 
WHEN Number_of_Accounts >= 3 THEN 3
WHEN Number_of_Accounts = 2 THEN 2
ELSE 1
END 

)
AS Engagement_Score

FROM Customer_Metrics
)

SELECT
Customer_ID,
Name,
Number_of_Accounts,
Total_Deposit_Balance,
Total_Transactions,
Engagement_Score,

CASE

WHEN Engagement_Score >= 8
THEN 'High Engagement'

WHEN Engagement_Score BETWEEN 5 AND 7
THEN 'Moderate Engagement'

ELSE 'Low Engagement'

END AS Engagement_Category
FROM Engagement_Score
ORDER BY Total_Transactions DESC;