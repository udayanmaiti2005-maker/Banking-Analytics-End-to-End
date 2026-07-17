describe accounts;

-- ## Account Product Analysis ## --
CREATE VIEW vw_account_product_analysis AS

SELECT 
Account_Type, 
COUNT(Account_ID) AS Number_of_Accounts,
COUNT(DISTINCT Customer_ID) AS Number_of_Customers,
SUM(Balance) AS Total_Deposit_Balance,

ROUND(
AVG(Balance),
2
) AS Average_Account_Balance,

ROUND(
COUNT(Account_ID) * 100.0 /
(
	SELECT COUNT(*) 
	FROM accounts
),
2
) AS Account_Distribution_Percentage

FROM accounts
GROUP BY Account_Type;

-- Validation Tests -------

-- Total Accounts --
SELECT SUM(Number_of_Accounts)
FROM vw_account_product_analysis;
SELECT COUNT(*)
FROM accounts;

-- Total Balance --
SELECT SUM(Total_Deposit_Balance)
FROM vw_account_product_analysis;
SELECT SUM(BalanCe)
FROM accounts;

-- Product Distribution --
SELECT *
FROM vw_account_product_analysis;


-- ## Loan Product Analysis ## --
CREATE VIEW vw_loan_product_analysis AS 

SELECT
Loan_Type,
COUNT(Loan_ID) AS Number_of_Approved_Loans,
SUM(Loan_Amount) AS Total_Loan_Exposure,

ROUND(
AVG(Loan_Amount),
2
) AS Average_Loan_Size,

ROUND(
SUM(Loan_Amount) * 100.0 /
(
	SELECT SUM(Loan_Amount)
	FROM approved_loan_portfolio
),
2
) AS Portfolio_Contribution_Percentage

FROM approved_loan_portfolio
GROUP BY Loan_Type;

-- Validation TEsts ---------

-- Loan Count Validation --
SELECT SUM(Number_of_Approved_Loans)
FROM vw_loan_product_analysis;
SELECT COUNT(*)
FROM approved_loan_portfolio;

-- Loan Exposure Validation --
SELECT SUM(Total_Loan_Exposure)
FROM vw_loan_product_analysis;
SELECT SUM(Loan_Amount)
FROM approved_loan_portfolio;

-- Contribution Percentage --
SELECT SUM(Portfolio_Contribution_Percentage)
FROM vw_loan_product_analysis;