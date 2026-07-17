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