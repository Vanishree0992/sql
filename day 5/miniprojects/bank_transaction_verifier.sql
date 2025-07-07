CREATE DATABASE Bank_verifierDB;
USE Bank_verifierDB;

CREATE TABLE Accounts (
  AccountID INT PRIMARY KEY AUTO_INCREMENT,
  AccountHolder VARCHAR(100) NOT NULL,
  Balance DECIMAL(12, 2) NOT NULL DEFAULT 0 CHECK (Balance >= 0)
);

CREATE TABLE Transactions (
  TransactionID INT PRIMARY KEY AUTO_INCREMENT,
  AccountID INT NOT NULL,
  TransactionType ENUM('DEBIT', 'CREDIT') NOT NULL,
  Amount DECIMAL(12, 2) NOT NULL CHECK (Amount > 0),
  TransactionDate TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  FOREIGN KEY (AccountID) REFERENCES Accounts(AccountID)
);

INSERT INTO Accounts (AccountHolder, Balance)
VALUES 
('Alice Johnson', 5000.00),
('Bob Smith', 3000.00);

INSERT INTO Transactions (AccountID, TransactionType, Amount)
VALUES
(1, 'DEBIT', 500.00),
(1, 'CREDIT', 1000.00),
(2, 'DEBIT', 200.00),
(2, 'CREDIT', 800.00);

--	Use JOIN, SUM() to get total debits/credits per account.
SELECT 
  a.AccountID,
  a.AccountHolder,
  SUM(CASE WHEN t.TransactionType = 'DEBIT' THEN t.Amount ELSE 0 END) AS TotalDebits,
  SUM(CASE WHEN t.TransactionType = 'CREDIT' THEN t.Amount ELSE 0 END) AS TotalCredits
FROM Accounts a
LEFT JOIN Transactions t ON a.AccountID = t.AccountID
GROUP BY a.AccountID, a.AccountHolder;

--	Use transactions (SAVEPOINT, ROLLBACK) to simulate a transfer.
START TRANSACTION;

SELECT Balance FROM Accounts WHERE AccountID = 1;

SAVEPOINT BeforeTransfer;

UPDATE Accounts SET Balance = Balance - 1000 WHERE AccountID = 1;

UPDATE Accounts SET Balance = Balance + 1000 WHERE AccountID = 2;

INSERT INTO Transactions (AccountID, TransactionType, Amount)
VALUES 
(1, 'DEBIT', 1000.00),
(2, 'CREDIT', 1000.00);

SELECT Balance FROM Accounts WHERE AccountID = 1;

ROLLBACK TO BeforeTransfer;

-- COMMIT;

COMMIT;
