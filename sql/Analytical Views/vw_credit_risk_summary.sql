CREATE VIEW vw_credit_risk_summary AS
    SELECT 
        Loan_Risk_Category,
        COUNT(DISTINCT Loan_ID) AS Total_Loans,
        SUM(Loan_Amount) AS Total_Loan_Exposure,
        AVG(Loan_Amount) AS Average_Loan_Size,
        AVG(Loan_to_Income_Ratio) AS Average_Loan_to_Income_Ratio
    FROM
        vw_loan_risk_analysis
    GROUP BY Loan_Risk_Category;
        
SELECT *
FROM vw_credit_risk_summary;