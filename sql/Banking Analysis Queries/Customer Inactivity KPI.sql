# Customer Inactivity KPI 
SELECT

COUNT(*) AS Total_Inactive_Customers,

ROUND(
COUNT(*) * 100.0 /
(SELECT COUNT(*) FROM Customers),
2
)
AS Inactive_Percentage

FROM Inactive_Customers;