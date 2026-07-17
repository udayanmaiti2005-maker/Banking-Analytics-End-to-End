### Customer distribution by City
SELECT 
    City, COUNT(Customer_ID) AS Number_of_Customers
FROM
    Customers
GROUP BY City
ORDER BY Number_of_Customers DESC;