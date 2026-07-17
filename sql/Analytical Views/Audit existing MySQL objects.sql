# List existing views #
SHOW FULL TABLES
WHERE Table_type = 'VIEW';

# List Stored Procedures for Documentation 
SHOW PROCEDURE STATUS;

# List Tables #
SHOW TABLES;

# Existing Analytical Objects #
SELECT
TABLE_NAME,
TABLE_TYPE
FROM INFORMATION_SCHEMA. TABLES
WHERE TABLE_SCHEMA = DATABASE();

SHOW CREATE VIEW approved_loan_portfolio;
SHOW CREATE VIEW branch_performance;
SHOW CREATE VIEW customer_account_summary;
SHOW CREATE VIEW customer_risk_view;
SHOW CREATE VIEW loan_portfolio_summary;