# Branch Deposit Performance
SELECT 
b. Branch_Name,

SUM(a. Balance)

AS Total_Deposits

FROM Branches b
JOIN Accounts a

ON b. Branch_ID = a. Branch_ID

GROUP BY b. Branch_Name

ORDER BY Total_Deposits DESC;