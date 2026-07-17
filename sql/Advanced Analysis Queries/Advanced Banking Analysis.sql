-- Customer Segmentation Analysis --

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

# Segment Distribution Analysis
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
WHEN Total_Transactions >= 50 THEN 30
WHEN Total_Transactions >= 15 THEN 20
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
WHEN Total_Transactions >= 50 THEN 30
WHEN Total_Transactions >= 15 THEN 20
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

---------------## LOAN RISK ANALYSIS ##-----------------------

### Part 1: Loan Application Overview ###

SELECT *
FROM loans
LIMIT 10;

-- a. Loan Distribution by Type ---------
SELECT 
Loan_Type,
COUNT(*) AS Number_of_Loan_Applications
FROM loans
GROUP BY Loan_Type
ORDER BY Number_of_Loan_Applications DESC;

-- b. Loan Status Analysis -------
SELECT
Loan_Status,
COUNT(*) AS Number_of_Loans,
SUM(Loan_Amount) AS Loan_Value
FROM Loans
GROUP BY Loan_Status;

-- c. Loan Status Contibution % ------
SELECT
Loan_Status,
COUNT(*) AS Number_of_Loans,
SUM(Loan_Amount) AS Total_Loan_Value,

ROUND(
COUNT(*) * 100.0 / 
(SELECT COUNT(*) FROM Loans),
2
)
AS Percentage_of_Total_Applications
FROM loans
GROUP BY Loan_Status
ORDER BY Percentage_of_Total_Applications DESC;

-- d. Loan Amount Contribution %
SELECT
Loan_Status,
COUNT(*) AS Number_of_Loans,
SUM(Loan_Amount) AS Loan_Value,

ROUND(
SUM(Loan_Amount)*100.0 /
(SELECT SUM(Loan_Amount) FROM Loans),
2
) AS Amount_Percentage

FROM Loans
GROUP BY Loan_Status
ORDER BY Amount_Percentage DESC;

### Part 2: Loan Type Analysis (Approved Loans) ###

-- a. Approved Loan Portfolio -------
SELECT 
COUNT(*) AS Total_Approved_Loans,
SUM(Loan_Amount) AS Actual_Loan_Portfolio,
ROUND(AVG(Loan_Amount), 2) AS Average_Approved_Loan_Size,
MAX(Loan_Amount) AS Largest_Approved_Loan,
MIN(Loan_Amount) AS Smallest_Approved_Loan
FROM approved_loan_portfolio;

-- b. Approved Loan Amount by Type ----------
SELECT 
Loan_Type,
COUNT(*) AS Approved_Loans,
SUM(Loan_Amount) AS Approved_Loan_Exposure,
ROUND(AVG(Loan_Amount), 2) AS Average_Approved_Loan_Size

FROM approved_loan_portfolio
GROUP BY Loan_Type
ORDER BY Approved_Loan_Exposure DESC;

-- c. Approved Loan Type Contribution (%) ------
SELECT 
Loan_Type,
SUM(Loan_Amount) AS Approved_Loan_Exposure,

ROUND(
SUM(Loan_Amount) * 100.0 /
(SELECT SUM(Loan_Amount) FROM approved_loan_portfolio),
2
)
AS Portfolio_Percentage
FROM approved_loan_portfolio
GROUP BY Loan_Type
ORDER BY Portfolio_Percentage DESC;

-- d. Branch-wise Lending Exposure --------
WITH Customer_Branch AS
(
    SELECT
    Customer_ID,
    MIN(Branch_ID) AS Branch_ID
    FROM Accounts
    GROUP BY Customer_ID
)

SELECT
COALESCE(b.Branch_ID, 999) AS Branch_ID,
COALESCE(b.Branch_Name, 'Unknown Branch') AS Branch_Name,
COALESCE(b.City, 'Unknown') AS City,

COUNT(l.Loan_ID) AS Approved_Loans,
SUM(l.Loan_Amount) AS Total_Exposure

FROM Approved_Loan_Portfolio l

LEFT JOIN Customer_Branch cb
ON l.Customer_ID = cb.Customer_ID

LEFT JOIN Branches b
ON cb.Branch_ID=b.Branch_ID

GROUP BY
b.Branch_ID,
b.Branch_Name,
b.City

ORDER BY Total_Exposure DESC;

### Part 3: Customer Loan Risk Analysis ###

-- a. Customer-Level Loan Exposure
SELECT 
c. Customer_ID,
c. Name,
c. City, 
c. Occupation,

COUNT(l. Loan_ID) AS Number_of_Loans,
SUM(l. Loan_Amount) AS Total_Loan_Exposure,
ROUND(AVG(l. Loan_Amount), 2) AS Average_Loan_Size

FROM approved_loan_portfolio l
JOIN customers c
ON l. Customer_ID = c. Customer_ID

GROUP BY 
c. Customer_ID,
c. Name,
c. City,
c. Occupation

ORDER BY Total_Loan_Exposure DESC
LIMIT 20;

-- b. Customers with Multiple Loans -------
SELECT
c. Customer_ID,
c. Name,

COUNT(l. Loan_ID) AS Number_of_Loans,
SUM(l. Loan_Amount) AS Total_Loan_Exposure

FROM approved_loan_portfolio l
JOIN customers c
ON l. Customer_ID = c. Customer_ID

GROUP BY
c. Customer_ID,
c. Name
HAVING COUNT(l. Loan_ID) > 1
ORDER BY Number_of_Loans DESC; 

-- c. Loan Burden Analysis ------
SELECT
c. Customer_ID,
c. Name,
c. Annual_Income,
SUM(l. Loan_Amount) AS Total_Loan_Amount,

ROUND(
SUM(l. Loan_Amount) / c. Annual_Income,
2
)
AS Loan_to_Income_Ratio

FROM approved_loan_portfolio l
JOIN customers c
ON l. Customer_ID = c. Customer_ID

GROUP BY
c. Customer_ID,
c. Name,
c. Annual_Income

ORDER BY Loan_to_Income_Ratio DESC
LIMIT 20;

-- d. Customer Loan Risk Classification ------
SELECT
c.Customer_ID,
c.Name,
c.Annual_Income,

SUM(l.Loan_Amount) AS Total_Loan_Amount,

ROUND(
SUM(l.Loan_Amount) / c.Annual_Income,
2
) AS Loan_to_Income_Ratio,

CASE

WHEN SUM(l.Loan_Amount) / c.Annual_Income >= 10
THEN 'Critical Risk'

WHEN SUM(l.Loan_Amount) / c.Annual_Income BETWEEN 5 AND 10
THEN 'High Risk'

WHEN SUM(l.Loan_Amount) / c.Annual_Income BETWEEN 2 AND 5
THEN 'Medium Risk'

ELSE 'Low Risk'

END AS Risk_Category

FROM approved_loan_portfolio l
JOIN customers c
ON l.Customer_ID = c.Customer_ID

GROUP BY
c.Customer_ID,
c.Name,
c.Annual_Income

ORDER BY Loan_to_Income_Ratio DESC;

-- e. Customer Risk Portfolio Distribution ------
WITH Customer_Risk AS
(
SELECT 
c. Customer_ID,

CASE
WHEN SUM(l.Loan_Amount) / c.Annual_Income >= 10
THEN 'Critical Risk'

WHEN SUM(l.Loan_Amount) / c.Annual_Income BETWEEN 5 AND 10
THEN 'High Risk'

WHEN SUM(l.Loan_Amount) / c.Annual_Income BETWEEN 2 AND 5
THEN 'Medium Risk'

ELSE 'Low Risk'

END AS Risk_Category

FROM approved_loan_portfolio l
JOIN customers c
ON l. Customer_ID = c. Customer_ID

GROUP BY 
c. Customer_ID,
c. Annual_Income
)

SELECT
Risk_Category,
COUNT(*) AS Number_of_Customers,

ROUND(
COUNT(*) * 100.0 /
(SELECT COUNT(*) FROM Customer_Risk),
3
)
AS Percentage_of_Customers

FROM Customer_Risk
GROUP BY Risk_Category
ORDER BY Number_of_Customers DESC;

### Part 4: Branch Lending Analysis ###

-- a. Branch Loan Portfolio Summary -----
WITH Customer_Branch AS
(
SELECT
Customer_ID,
MIN(Branch_ID) AS Branch_ID
FROM Accounts

GROUP BY Customer_ID
)

SELECT 
COALESCE(b. Branch_ID, 999) AS Branch_ID,
COALESCE(b. Branch_Name, 'Unknown Branch') AS Branch_Name,
COALESCE(b. City, 'Unknown') AS City,

COUNT(l. Loan_ID) AS Number_of_Approved_Loans,
SUM(l. Loan_Amount) AS Total_Loan_Exposure,

ROUND(
AVG (l. Loan_Amount),
2
) AS Average_loan_Size

FROM approved_loan_portfolio l
LEFT JOIN Customer_Branch cb
ON l. Customer_ID = cb. Customer_ID

LEFT JOIN branches b
ON cb. Branch_ID = b. Branch_ID

GROUP BY
b. Branch_ID,
b. Branch_Name,
b. City

ORDER BY Total_loan_Exposure DESC;

-- b. Branch Customer Base Analysis -----
WITH Customer_Branch AS 
(
SELECT
Customer_ID,
MIN(Branch_ID) AS Branch_ID
FROM Accounts
GROUP BY Customer_ID
)

SELECT 
COALESCE(b. Branch_ID, 999) AS Branch_ID,
COALESCE(b. Branch_Name, 'Unknown Branch') AS Branch_Name,
COALESCE(b. City, 'Unknown') AS City,

COUNT(DISTINCT cb. Customer_ID) AS Number_of_Customers

FROM Customer_Branch cb
LEFT JOIN Branches b
ON cb. Branch_ID = b. Branch_ID

GROUP BY
b. Branch_ID,
b. Branch_Name,
b. City

ORDER BY Number_of_Customers DESC;

-- c. Branch Average Loan Size Analysis -----
WITH Customer_Branch AS
(
SELECT
Customer_ID,
MIN(Branch_ID) AS Branch_ID

FROM Accounts
GROUP BY Customer_ID
)

SELECT
COALESCE(b.Branch_ID,999) AS Branch_ID,
COALESCE(b.Branch_Name,'Unknown Branch') AS Branch_Name,
COALESCE(b.City,'Unknown') AS City,

COUNT(l.Loan_ID) AS Approved_Loans,
SUM(l.Loan_Amount) AS Total_Exposure,

ROUND(
AVG(l.Loan_Amount),
2
)
AS Average_Loan_Size

FROM Approved_Loan_Portfolio l
LEFT JOIN Customer_Branch cb
ON l.Customer_ID=cb.Customer_ID

LEFT JOIN Branches b
ON cb.Branch_ID=b.Branch_ID

GROUP BY
b.Branch_ID,
b.Branch_Name,
b.City

ORDER BY Average_Loan_Size DESC;

-- d. Branch Risk Analysis -------
WITH Customer_Branch AS 
(
SELECT 
Customer_ID,
MIN(Branch_ID) AS Branch_ID

FROM Accounts
GROUP BY Customer_ID
),

Customer_Risk AS
(
SELECT 
c. Customer_ID,

CASE
WHEN SUM(l.Loan_Amount) / c.Annual_Income >= 10
THEN 'Critical Risk'

WHEN SUM(l.Loan_Amount) / c.Annual_Income BETWEEN 5 AND 10
THEN 'High Risk'

WHEN SUM(l.Loan_Amount) / c.Annual_Income BETWEEN 2 AND 5
THEN 'Medium Risk'

ELSE 'Low Risk'

END AS Risk_Category

FROM approved_loan_portfolio l
JOIN customers c
ON l. Customer_ID = c. Customer_ID

GROUP BY 
c. Customer_ID,
c. Annual_Income
)

SELECT 
COALESCE(b. Branch_Name, 'Unknown Branch') AS Branch_Name,
cr. Risk_Category,

COUNT(*) AS Number_of_Customers

FROM Customer_Risk cr
LEFT JOIN Customer_Branch cb
ON cr. Customer_ID = cb. Customer_ID

LEFT JOIN branches b
ON cb. Branch_ID = b. Branch_ID

GROUP BY
b. Branch_Name,
cr. Risk_Category

ORDER BY 
b. Branch_Name,
Number_of_Customers DESC;

---------------## BRANCH PERFORMANCE ANALYSIS ## -----------------

-- 1. Branch Customer Base Performance -----
SELECT
b. Branch_ID,
b. Branch_Name,
b. City,

COUNT(DISTINCT c. Customer_ID) AS Total_Customers

FROM customers c
JOIN accounts a
ON c. Customer_ID = a. Customer_ID

JOIN branches b
ON a. Branch_ID = b. Branch_ID

GROUP BY 
b. Branch_ID,
b. Branch_Name,
b. City

ORDER BY Total_Customers DESC;

-- 2. Deposit performance by Branch -----
SELECT
b. Branch_ID,
b. Branch_Name,
b. City,

COUNT(DISTINCT a. Account_ID) AS Total_Accounts,
SUM(a. Balance) AS Total_Deposit_Value,

ROUND(
AVG(a. Balance),
2
) AS Average_Account_Balance

FROM accounts a
JOIN branches b
ON a. Branch_ID = b. Branch_ID

GROUP BY
b. Branch_ID,
b. Branch_Name,
b. City

ORDER BY Total_Deposit_Value DESC;

-- 3. Transaction Activity by Branch ------
SELECT
b. Branch_ID,
b. Branch_Name,
b. City,

COUNT(t. Transaction_ID) AS Total_Transactions,
SUM(t. Amount) AS Total_Transaction_Value,

ROUND(
AVG(t. Amount),
2
) AS Average_Transaction_Size

FROM transactions t
JOIN accounts a
ON t. Account_ID = a. Account_ID

JOIN branches b
ON a. Branch_ID = b. Branch_ID

GROUP BY
b. Branch_ID,
b. Branch_Name,
b. City

ORDER BY Total_Transaction_Value DESC;

-- 4. Loan Contribution by Branch --------
WITH Customer_Branch AS

(
SELECT
Customer_ID,
MIN(Branch_ID) AS Branch_ID

FROM Accounts
GROUP BY Customer_ID
)

SELECT
COALESCE(b.Branch_ID,999) AS Branch_ID,
COALESCE(b.Branch_Name,'Unknown Branch') AS Branch_Name,
COALESCE(b.City,'Unknown') AS City,

COUNT(l.Loan_ID) AS Approved_Loans,
SUM(l.Loan_Amount) AS Total_Loan_Contribution,

ROUND(
AVG(l.Loan_Amount),
2
) AS Average_Loan_Size,

ROUND(
SUM(l.Loan_Amount) * 100.0 /
(SELECT SUM(Loan_Amount) FROM Approved_Loan_Portfolio),
3
) AS Portfolio_Contribution_Percentage

FROM Approved_Loan_Portfolio l
LEFT JOIN Customer_Branch cb
ON l.Customer_ID = cb.Customer_ID

LEFT JOIN Branches b
ON cb.Branch_ID = b.Branch_ID

GROUP BY
b.Branch_ID,
b.Branch_Name,
b.City

ORDER BY Total_Loan_Contribution DESC;

-- 5. Overall Branch Performance Ranking --------
WITH Branch_Performance AS
(
SELECT
b.Branch_ID,
b.Branch_Name,
b.City,

COUNT(DISTINCT c. Customer_ID) AS Customers,
SUM(DISTINCT a. Balance) AS Deposits

FROM branches b
LEFT JOIN accounts a
ON b. Branch_ID = a. Branch_ID

LEFT JOIN customers c
ON a. Customer_ID = c. Customer_ID

GROUP BY 
b.Branch_ID,
b.Branch_Name,
b.City
)

SELECT *
FROM Branch_Performance
ORDER BY Deposits DESC;

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
WHEN Total_Transactions >= 40 THEN 3
WHEN Total_Transactions >= 15 THEN 2
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
ORDER BY Engagement_Score DESC;

-- ### Product Analysis ### --------------

-- 1. Account Product Analysis  -------
SELECT
Account_Type,

COUNT(Account_ID) AS Number_of_Accounts,
COUNT(DISTINCT Customer_ID) AS Number_of_Customers,
SUM(Balance) AS Total_Deposit_Value,

ROUND(
AVG(Balance),
2
) AS Average_Account_Balance

FROM Accounts
GROUP BY Account_Type
ORDER BY Number_of_Accounts DESC;

-- 2. Loan Product Analysis -------
SELECT 
Loan_Type,

COUNT(Loan_ID) AS Number_of_Approved_Loans,
SUM(Loan_Amount) AS Total_Loan_Exposure,

ROUND(
AVG(Loan_Amount),
2
) AS Average_Loan_Size,

ROUND(
SUM(Loan_Amount) * 100.0 /
(
SELECT SUM(Loan_Amount)
FROM Approved_Loan_Portfolio
),
2
) AS Portfolio_Cotribution_Percentage

FROM approved_loan_portfolio
GROUP BY Loan_Type
ORDER BY Total_Loan_Exposure DESC;

-- 3. Customer Product Adoption Analysis ------
WITH Customer_Products AS
(
SELECT
c. Customer_ID,
c. Name,

COUNT(DISTINCT a. Account_ID) AS Number_of_Accounts,
COUNT(DISTINCT l. Loan_ID) AS Number_of_Loans

FROM customers c
LEFT JOIN accounts a
ON c. Customer_ID = a. Customer_ID

LEFT JOIN  approved_loan_portfolio l
ON c. Customer_ID = l. Customer_ID

GROUP BY
c. Customer_ID,
c. Name
)

SELECT 
Customer_ID, 
Name,
Number_of_Accounts,
Number_of_Loans,

(Number_of_Accounts + Number_of_Loans) AS Total_Products
FROM Customer_Products
ORDER BY Total_Products DESC;

-- 4. Product Contribution Ranking --------

-- Account Product Contribution --
SELECT

'Account Product' AS Product_Category,
Account_Type AS Product_Name,
COUNT(Account_ID) AS Product_Count,
SUM(Balance) AS Product_Value

FROM accounts
GROUP BY Account_Type

UNION ALL

-- Loan Product Contribution --
SELECT

'Loan Product' AS Product_Category,
Loan_Type AS Product_Name,
COUNT(Loan_ID) AS Product_Count,
SUM(Loan_Amount) AS Product_Value

FROM approved_loan_portfolio
GROUP BY Loan_Type
ORDER BY Product_Value DESC;