# CTE 4 (Loan Risk Categorization)

WITH Loan_Risk AS
(
SELECT
c. Customer_ID,
c. Name,
c. Annual_Income,
l. Loan_Amount,

ROUND(
l. Loan_Amount / c. Annual_Income,
2
)
AS Loan_Income_Ratio

FROM Customers c
JOIN loans l
ON c. Customer_ID = l. Customer_ID
)

SELECT
*,

CASE
WHEN Loan_Income_Ratio > 5
THEN 'High_Risk'

WHEN Loan_Income_Ratio BETWEEN 2 AND 5
THEN 'Medium_Risk'

ELSE 'Low_Risk'

END AS Risk_Category
FROM Loan_Risk
;