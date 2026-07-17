# View 7: Customer Status View
CREATE VIEW Customer_Status_Analysis AS

SELECT
c. Customer_ID,
c. Name,

CASE
WHEN 
a. Account_ID IS NULL
THEN 'Inactive Customer'
ELSE 'Active Customer'

END AS Customer_Status
FROM Customers c
LEFT JOIN Accounts a 
ON c. Customer_ID = a. Customer_ID
;