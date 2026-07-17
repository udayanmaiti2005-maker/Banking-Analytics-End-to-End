# SP 1: Customer Profile Generation
DELIMITER //
CREATE PROCEDURE sp_Get_Customer_Profile
(
IN cust_id INT
)

BEGIN

SELECT
c. Customer_ID,
c. Name,
c. City,
c. Occupation,
c. Annual_Income,

COUNT(DISTINCT a. Account_ID)
AS Total_Accounts,

COALESCE(SUM(a. Balance), 0)
AS Total_Balance,

COUNT(DISTINCT l. Loan_ID)
AS Total_Loans,

COALESCE(SUM(l. Loan_Amount),0)
AS Total_Loan_Amount,

CASE 
WHEN COUNT(DISTINCT a. Account_ID)= 0
AND COUNT(DISTINCT l. Loan_ID)= 0
THEN 'Registered but Inactive'

WHEN COUNT(DISTINCT a.Account_ID)>0
THEN 'Active Banking Customer'

WHEN COUNT(DISTINCT l.Loan_ID)>0
THEN 'Loan Customer'

END AS Customer_Status

FROM Customers c
LEFT JOIN Accounts a
ON c. Customer_ID = a. Customer_ID

LEFT JOIN Loans l
ON c. Customer_ID = l. Customer_ID

WHERE c. Customer_ID = cust_id

GROUP BY
c. Customer_ID,
c. Name,
c. City,
c. Occupation,
c. Annual_Income;

END //

SELECT Customer_ID
FROM Customers
LIMIT 10;

CALL sp_Get_Customer_Profile(10002) 

# SP 2: Branch Performance Report
DELIMITER //

CREATE PROCEDURE sp_Get_Branch_Performance
(
IN branch_id_input INT
)

BEGIN

SELECT
b. Branch_ID,
b. Branch_Name,
b. City,

COUNT(a. Account_ID)
AS Total_Accounts,

SUM(a. Balance)
AS Total_Deposits,

AVG(a. Balance)
AS Average_Balance

FROM Branches b
JOIN Accounts a
ON b. Branch_ID = a. Branch_ID
WHERE b. Branch_ID = branch_id_input

GROUP BY
b. Branch_ID,
b. Branch_Name,
b. City;

END //

SELECT *
FROM branches;

CALL sp_Get_Branch_Performance(105);

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

WHEN SUM(l.Loan_Amount) / c.Annual_Income > 5
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

# SP 4: Customer Transaction Summary
DELIMITER //

CREATE PROCEDURE sp_Get_Customer_Transaction_Summary
(
IN cust_id_input INT
)

BEGIN

SELECT
c. Customer_ID,
c. Name,

COUNT(t. Transaction_ID)
AS Total_Transactions,

COALESCE(
SUM(t. Amount),
0
)
AS Total_Transaction_Value,

COALESCE(
AVG(t. Amount),
0
)
AS Average_Transaction_Value

FROM customers c
LEFT JOIN accounts a 
ON c. Customer_ID = a. Customer_ID

LEFT JOIN transactions t
ON a. Account_ID = t. Account_ID
WHERE c. Customer_ID = cust_id_input

GROUP BY
c. Customer_ID,
c. Name;

END //

CALL sp_Get_Customer_Transaction_Summary(10013);