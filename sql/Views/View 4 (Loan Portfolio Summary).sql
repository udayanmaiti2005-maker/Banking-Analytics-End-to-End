# Loan Portfolio Summary

CREATE VIEW Loan_Portfolio_Summary AS

SELECT

l. Loan_ID,
c. Name,
c. City,
l. Loan_Type,
l. Loan_Amount,
l. Loan_Status

FROM Loans l
JOIN Customers c
ON l. Customer_ID = c. Customer_ID;

SELECT *
FROM loan_portfolio_summary
LIMIT 10;