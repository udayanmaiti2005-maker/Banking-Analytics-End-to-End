# View 5 (Customer Risk View)
CREATE VIEW Customer_Risk_View AS

SELECT
c. Customer_ID,
c. Name,
c. Annual_Income,
l. Loan_Amount,

ROUND(
l. Loan_Amount / c. Annual_Income,
2 ### 2 decimal Places
)
AS Loan_Income_Ratio

FROM customers c
JOIN loans l

ON c. Customer_ID = l.Customer_ID;

SELECT *
FROM Customer_Risk_View
ORDER BY Loan_Income_Ratio DESC
LIMIT 20;

