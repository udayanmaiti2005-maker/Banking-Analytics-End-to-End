# Branch Ranking
SELECT 
b. Branch_Name,

SUM(a. Balance)
AS Deposits,

RANK()
OVER(
ORDER BY SUM(a. Balance) DESC
)

AS Ranking

FROM Branches b
JOIN Accounts a 
ON b. Branch_ID = a. Branch_ID

GROUP BY b. Branch_Name;