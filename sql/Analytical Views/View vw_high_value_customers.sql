CREATE VIEW vw_high_value_customers AS

SELECT
Customer_ID,
Name,
CIty, 
Occupation,
Annual_Income,
Total_Balance,
Total_Transactions,
Total_Transaction_Value,
Total_Approved_Loans,
Total_Loan_Exposure,
Customer_Value_Score

FROM vw_customer_value_segment
WHERE Customer_Segment = 'Premium Customer'
;