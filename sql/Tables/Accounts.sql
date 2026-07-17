CREATE TABLE Accounts (
    Account_ID INT PRIMARY KEY,
    Customer_ID INT,
    Branch_ID INT,
    Account_Type VARCHAR(20),
    Balance DECIMAL(12 , 2 ),
    Opening_Date DATE,
    FOREIGN KEY (Customer_ID)
        REFERENCES Customers (Customer_ID),
    FOREIGN KEY (Branch_ID)
        REFERENCES Branches (Branch_ID)
);