CREATE TABLE Loans (
    Loan_ID INT PRIMARY KEY,
    Customer_ID INT,
    Loan_Type VARCHAR(30),
    Loan_Amount DECIMAL(12 , 2 ),
    Interest_Rate DECIMAL(5 , 2 ),
    Loan_Status VARCHAR(20),
    FOREIGN KEY (Customer_ID)
        REFERENCES Customers (Customer_ID)
);