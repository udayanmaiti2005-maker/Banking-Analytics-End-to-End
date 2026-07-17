# WF 2: Branch Deposit Ranking

WITH Branch_Deposits AS

(
SELECT
b. Branch_ID,
b. Branch_Name,
SUM(a. Balance) AS Total_Deposits

FROM branches b
JOIN accounts a 
ON b. Branch_ID = a. Branch_ID

GROUP BY
b. Branch_ID,
b. Branch_Name
)

SELECT
*,

RANK()
OVER(
ORDER BY Total_Deposits DESC
)
AS Branch_Rank
FROM Branch_Deposits;