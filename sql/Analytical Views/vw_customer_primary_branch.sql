CREATE VIEW vw_customer_primary_branch AS
SELECT
    a.Customer_ID,
    a.Account_ID,
    a.Branch_ID,
    a.Opening_Date
FROM accounts a
WHERE a.Opening_Date =
(
    SELECT MIN(a2.Opening_Date)
    FROM accounts a2
    WHERE a2.Customer_ID = a.Customer_ID
);