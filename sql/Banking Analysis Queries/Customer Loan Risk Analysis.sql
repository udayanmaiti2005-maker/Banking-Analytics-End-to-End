# Customer Loan Risk Analysis
SELECT 

	c. Name,
	c. Annual_Income,
	l. Loan_Amount,

ROUND(
	l.Loan_Amount / c.Annual_Income,
	2
    
)
AS Loan_Income_Ratio

FROM Customers c

JOIN Loans l

ON c.Customer_ID=l.Customer_ID

ORDER BY Loan_Income_Ratio DESC

LIMIT 20;