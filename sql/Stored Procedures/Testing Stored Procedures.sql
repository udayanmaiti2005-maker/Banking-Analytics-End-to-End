# Testing Stored Procedures

SHOW PROCEDURE STATUS
WHERE Db = 'banking_analytics_db';

## Customer Profile
CALL sp_Get_Customer_Profile(10002);

## Branch Performance
CALL sp_Get_Branch_Performance(100);

## Customer Loan Risk
CALL sp_Get_Customer_Loan_Risk(10005);

## Customer Transaction Summary
CALL sp_Get_Customer_Transaction_Summary(10013);

SELECT *
FROM Loans
WHERE Customer_ID = 10001;


SELECT Customer_ID
FROM Loans
LIMIT 10;

DROP PROCEDURE IF EXISTS sp_Get_Customer_Loan_Risk;