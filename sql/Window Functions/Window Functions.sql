
# WF 1: Rank Customers by Balance
SELECT
c. Customer_ID,
c. Name,
c. City,
a. Balance,

RANK()
OVER(
ORDER BY a. Balance DESC
)
AS Customer_Rank

FROM customers c
JOIN accounts a
ON c. Customer_ID = a. Customer_ID;

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

# WF 3: Running Transaction Total
SELECT 

Transaction_ID, # Because every transaction has a unique sequence
Transaction_Date,
Amount,

SUM(Amount)
OVER(
ORDER BY Transaction_Date, Transaction_ID
)
AS Running_Total

FROM Transactions
ORDER BY Transaction_Date, Transaction_ID;

# WF 4: Customer Transaction Ranking (Transaction-active customers)
WITH Customer_Transactions AS
(
SELECT
a. Customer_ID,
SUM(t. Amount)

AS Total_Transaction_Value
FROM Accounts a
JOIN Transactions t
ON a. Account_ID = t. Account_ID

GROUP BY a. Customer_ID
)

SELECT 
c. Name,
ct. Total_Transaction_Value,

RANK()
OVER(
ORDER BY ct. Total_Transaction_Value DESC
)
AS Customer_Rank
FROM Customers c
JOIN Customer_Transactions ct
ON c. Customer_ID = ct. Customer_ID
;

# WF 4: Customer Transaction Ranking (Complete customers)
WITH Customer_Transactions AS

(
SELECT
a.Customer_ID,

SUM(t.Amount)
AS Total_Transaction_Value

FROM Accounts a
JOIN Transactions t
ON a.Account_ID=t.Account_ID

GROUP BY a.Customer_ID

)

SELECT
c.Customer_ID,
c.Name,

COALESCE(ct.Total_Transaction_Value,0)
AS Total_Transaction_Value,

RANK()
OVER(
ORDER BY COALESCE(ct.Total_Transaction_Value,0) DESC
)

AS Customer_Rank

FROM Customers c
LEFT JOIN Customer_Transactions ct
ON c.Customer_ID=ct.Customer_ID;

# WF 5: Compare Customer Balance with Average
SELECT
c. Name,
a. Balance,

ROUND(
a. Balance - AVG(a. Balance)
OVER(),
2
)

AS Difference_From_Average

FROM Customers c
JOIN Accounts a
ON c. Customer_ID = a. Customer_ID
;