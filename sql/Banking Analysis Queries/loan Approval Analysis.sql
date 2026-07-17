# Loan Approval Analysis

SELECT

Loan_Status,

COUNT(*) AS Applications

FROM Loans

GROUP BY Loan_Status;