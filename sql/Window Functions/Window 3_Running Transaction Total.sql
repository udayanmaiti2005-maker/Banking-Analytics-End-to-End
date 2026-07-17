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