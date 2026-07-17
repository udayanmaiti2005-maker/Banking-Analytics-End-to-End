### Customer Segmentation by Income
SELECT 
    CASE
        WHEN Annual_Income < 500000 THEN 'Low Income'
        WHEN Annual_Income BETWEEN 500000 AND 1000000 THEN 'Middle Income'
        ELSE 'High Income'
    END AS Income_Category,
    COUNT(*) AS Customers
FROM
    Customers
GROUP BY Income_Category;