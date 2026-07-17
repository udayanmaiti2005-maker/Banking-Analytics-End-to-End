CREATE VIEW vw_approved_loan_portfolio AS

SELECT
l. Loan_ID,
l. Customer_ID,

c. Name,
c. City,
c. Occupation,
c. Annual_Income,

l. Loan_Type,
l. Loan_Amount,
l. Interest_Rate,
l. Loan_Status,

ROUND(
l. Loan_Amount / c. Annual_Income,
2
) AS Loan_to_Income_Ratio,

CASE

WHEN l. Loan_Amount / c. Annual_Income >= 10
THEN 'Critical Risk'

WHEN l. Loan_Amount / c. Annual_Income BETWEEN 5 AND 10
THEN 'High Risk'

WHEN l. Loan_Amount / c. Annual_Income BETWEEN 2 AND 5
THEN 'Medium Risk'

ELSE 'Low Risk'

END AS Loan_Risk_Category

FROM approved_loan_portfolio l
JOIN customers c
ON l. Customer_ID = c. Customer_ID;

SELECT *
FROM vw_approved_loan_portfolio
ORDER BY Loan_to_Income_Ratio DESC;

-- Validation Tests ----

-- loan counts--
SELECT COUNT(*)
FROM vw_approved_loan_portfolio;
SELECT COUNT(*)
FROM approved_loan_portfolio;

-- Loan amount validation --
SELECT SUM(Loan_Amount)
FROM vw_approved_loan_portfolio;
SELECT SUM(Loan_Amount)
FROM approved_loan_portfolio;

-- Status Distribution --
SELECT
Loan_Status,
COUNT(*) AS Number_of_Loans
FROM vw_approved_loan_portfolio
GROUP BY Loan_Status;

-- Risk Category Distribution ---
SELECT 
Loan_Risk_Category,
COUNT(*) AS Number_of_Customers
from vw_approved_loan_portfolio
GROUP BY Loan_Risk_Category;