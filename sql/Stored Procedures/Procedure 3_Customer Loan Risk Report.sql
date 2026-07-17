# SP 3: Customer Loan Risk Report
DELIMITER //

CREATE PROCEDURE sp_Get_Customer_Loan_Risk
(
IN cust_id_input INT
)

BEGIN

SELECT
c.Customer_ID,
c.Name,
c.Annual_Income,

COUNT(l.Loan_ID) 
AS Total_Loans,

COALESCE(SUM(l.Loan_Amount),0)
AS Total_Loan_Amount,

COALESCE(AVG(l.Loan_Amount),0)
AS Average_Loan_Amount,

CASE

WHEN COUNT(l.Loan_ID)=0
THEN 'No Loan'

WHEN SUM(l.Loan_Amount) / c.Annual_Income >=10
THEN 'Critical Risk'

WHEN SUM(l.Loan_Amount) / c.Annual_Income BETWEEN 5 AND 10
THEN 'High Risk'

WHEN SUM(l.Loan_Amount) / c.Annual_Income BETWEEN 2 AND 5
THEN 'Medium Risk'

ELSE 'Low Risk'

END AS Risk_Category

FROM Customers c
LEFT JOIN Loans l
ON c.Customer_ID = l.Customer_ID

WHERE c.Customer_ID = cust_id_input

GROUP BY
c.Customer_ID,
c.Name,
c.Annual_Income;

END //