# Loan type Popularity
SELECT

Loan_Type,

COUNT(*) AS Number_of_Transactions

FROM Loans

GROUP BY Loan_Type;