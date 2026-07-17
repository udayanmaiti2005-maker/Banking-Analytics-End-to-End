CREATE TABLE Transactions (
    Transaction_ID INT PRIMARY KEY,
    Account_ID INT,
    Transaction_Date DATE,
    Transaction_Type VARCHAR(20),
    Amount DECIMAL(12 , 2 ),
    FOREIGN KEY (Account_ID)
        REFERENCES Accounts (Account_ID)
);