CREATE VIEW Approved_Loan_Portfolio AS

SELECT *
FROM Loans
WHERE Loan_Status='Approved';