-- Customer Lifetime Value Analysis --

# CLV Base
WITH Customer_Value_Base AS
(
SELECT 
c. Customer_ID,
c. Name,

COALESCE(SUM(DISTINCT a. Balance), 0)
AS Total_Balance,

COUNT(DISTINCT t. Transaction_ID)
AS Total_Transactions,

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
c. Name
),

# CLV Scoring
CLV_Scoring AS
(
SELECT *,

CASE # Deposit Score
WHEN Total_Balance >= 1000000 THEN 40
WHEN Total_Balance >= 200000 THEN 25
ELSE 10
END AS Deposit_Score,

CASE # Transaction Score
WHEN Total_Transactions >= 30 THEN 30
WHEN Total_Transactions >= 10 THEN 20
ELSE 10
END AS Transaction_Score,

CASE # Loan Score
WHEN Total_Loan_Amount >= 5000000 THEN 30
WHEN Total_Loan_Amount >= 1000000 THEN 20
WHEN Total_Loan_Amount > 0 THEN 10
ELSE 0
END AS Loan_Score

FROM Customer_Value_Base
),

Customer_CLV AS
(
SELECT
Customer_ID,
Name,
Total_Balance,
Total_Transactions,
Total_Loan_Amount,

Deposit_Score + Transaction_Score + Loan_Score

AS CLV_Score

FROM CLV_Scoring
)

# CLV Ranking
SELECT

ROW_NUMBER() OVER(
ORDER BY CLV_Score DESC
)
AS Customer_Rank,

Customer_ID,
Name,
Total_Balance,
Total_Transactions,
Total_Loan_Amount,
CLV_Score

FROM Customer_CLV
ORDER BY Customer_Rank;

# CLV Classification
WITH Customer_Value_Base AS
(
SELECT 
c. Customer_ID,
c. Name,

COALESCE(SUM(DISTINCT a. Balance), 0)
AS Total_Balance,

COUNT(DISTINCT t. Transaction_ID)
AS Total_Transactions,

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
c. Name
),

# CLV Scoring
CLV_Scoring AS
(
SELECT *,

CASE # Deposit Score
WHEN Total_Balance >= 1000000 THEN 40
WHEN Total_Balance >= 200000 THEN 25
ELSE 10
END AS Deposit_Score,

CASE # Transaction Score
WHEN Total_Transactions >= 30 THEN 30
WHEN Total_Transactions >= 10 THEN 20
ELSE 10
END AS Transaction_Score,

CASE # Loan Score
WHEN Total_Loan_Amount >= 5000000 THEN 30
WHEN Total_Loan_Amount >= 1000000 THEN 20
WHEN Total_Loan_Amount > 0 THEN 10
ELSE 0
END AS Loan_Score

FROM Customer_Value_Base
),

Customer_CLV AS
(
SELECT
Customer_ID,
Name,
Total_Balance,
Total_Transactions,
Total_Loan_Amount,

Deposit_Score + Transaction_Score + Loan_Score

AS CLV_Score

FROM CLV_Scoring
)

SELECT

CASE
WHEN CLV_Score >= 80
THEN 'High Value Customer'

WHEN CLV_Score BETWEEN 50 AND 79
THEN 'Medium Value Customer'

ELSE 'Low Value Customer'

END AS CLV_Tier,

COUNT(*) AS Number_of_Customers,

ROUND(
COUNT(*) * 100.0 /
(SELECT COUNT(*) FROM Customer_CLV),
2
)
AS Percentage_of_Customers

FROM Customer_CLV
GROUP BY CLV_Tier;