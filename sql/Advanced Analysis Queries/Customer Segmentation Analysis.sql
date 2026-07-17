-- 1. Customer Segmentation Analysis --

# Temporary Summary Table containing Customer, Income, Balance, Transactions, Loans
WITH Customer_Summary AS
(
SELECT
c. Customer_ID, 
c. Name,
c. Annual_Income,

COALESCE(SUM(DISTINCT a. Balance), 0)
AS Total_Balance,

COUNT(DISTINCT t. Transaction_ID)
AS Total_Transactions,

COUNT(DISTINCT l. Loan_ID)
AS Total_Loans,

COALESCE(SUM(DISTINCT l. Loan_Amount), 0)
AS Total_Loan_Amount

FROM customers c
LEFT JOIN accounts a
ON c. Customer_ID = a. Customer_ID

LEFT JOIN transactions t
ON a. Account_ID = t. Account_ID

LEFT JOIN loans l
ON c. Customer_ID = l. Customer_ID

GROUP BY 
c. Customer_ID,
c. Name,
c. Annual_Income
)

SELECT *
FROM Customer_Summary;

# Scoring System: 7-9 = PREMIUM; 5-6 = REGULAR; 3-4 = LOW ENGAGEMENT
WITH Customer_Summary AS
(
SELECT
c. Customer_ID, 
c. Name,
c. Annual_Income,

COALESCE(SUM(DISTINCT a. Balance), 0)
AS Total_Balance,

COUNT(DISTINCT t. Transaction_ID)
AS Total_Transactions,

COUNT(DISTINCT l. Loan_ID)
AS Total_Loans,

COALESCE(SUM(DISTINCT l. Loan_Amount), 0)
AS Total_Loan_Amount

FROM customers c
LEFT JOIN accounts a
ON c. Customer_ID = a. Customer_ID

LEFT JOIN transactions t
ON a. Account_ID = t. Account_ID

LEFT JOIN loans l
ON c. Customer_ID = l. Customer_ID

GROUP BY 
c. Customer_ID,
c. Name,
c. Annual_Income
),

Customer_Score AS
(
SELECT *,

CASE # Income Score

WHEN Annual_Income >= 2000000 THEN 3
WHEN Annual_Income >= 800000 THEN 2
ELSE 1
END AS Income_Score,

CASE # Balance Score

WHEN Total_Balance >= 1000000 THEN 3
WHEN Total_Balance >= 200000 THEN 2
ELSE 1
END AS Balance_Score,

CASE # Activity Score

WHEN Total_Transactions >= 50 THEN 3
WHEN Total_Transactions >= 15 THEN 2
ELSE 1
END AS Activity_Score

FROM Customer_Summary
)

SELECT # Adding Segmentation Labels
Customer_ID,
Name,
Annual_Income, 
Total_Balance, 
Total_Transactions,

(Income_Score + Balance_Score + Activity_Score) AS Customer_Value_Score,

CASE
WHEN (Income_Score + Balance_Score + Activity_Score) >= 7
THEN 'Premium Customer'

WHEN (Income_Score + Balance_Score + Activity_Score) BETWEEN 5 AND 6
THEN 'Regular Customer'

ELSE 'Low Engagement Customer'
END AS Customer_Segment
FROM Customer_Score
; 

-- 2. Segment Distribution Analysis --
WITH Customer_Summary AS
(
SELECT
c. Customer_ID, 
c. Name,
c. Annual_Income,

COALESCE(SUM(DISTINCT a. Balance), 0)
AS Total_Balance,

COUNT(DISTINCT t. Transaction_ID)
AS Total_Transactions,

COUNT(DISTINCT l. Loan_ID)
AS Total_Loans,

COALESCE(SUM(DISTINCT l. Loan_Amount), 0)
AS Total_Loan_Amount

FROM customers c
LEFT JOIN accounts a
ON c. Customer_ID = a. Customer_ID

LEFT JOIN transactions t
ON a. Account_ID = t. Account_ID

LEFT JOIN loans l
ON c. Customer_ID = l. Customer_ID

GROUP BY 
c. Customer_ID,
c. Name,
c. Annual_Income
),

Customer_Score AS
(
SELECT *,

CASE # Income Score

WHEN Annual_Income >= 2000000 THEN 3
WHEN Annual_Income >= 800000 THEN 2
ELSE 1
END AS Income_Score,

CASE # Balance Score

WHEN Total_Balance >= 1000000 THEN 3
WHEN Total_Balance >= 200000 THEN 2
ELSE 1
END AS Balance_Score,

CASE # Activity Score

WHEN Total_Transactions >= 30 THEN 3
WHEN Total_Transactions >= 10 THEN 2
ELSE 1
END AS Activity_Score

FROM Customer_Summary
),

Customer_Segment AS
(
SELECT *,

CASE
WHEN (Income_Score + Balance_Score + Activity_Score) >= 7
THEN 'Premium Customer'

WHEN (Income_Score + Balance_Score + Activity_Score) BETWEEN 5 AND 6
THEN 'Regular Customer'

ELSE 'Low Engagement Customer'
END AS Customer_Segment

FROM Customer_Score
)

SELECT
Customer_Segment,

COUNT(*) AS Number_of_Customers, # Counting Number of Customers

ROUND(
COUNT(*) * 100.0 /               # Calculating Percentage Value of Segments
(SELECT COUNT(*) FROM Customer_Segment), 
2
)
AS Percentage_of_Customers

FROM Customer_Segment
GROUP BY Customer_Segment;