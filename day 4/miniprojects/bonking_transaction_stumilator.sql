CREATE DATABASE Banking_DB;
USE Banking_DB;

CREATE TABLE Customers (
  customer_id INT PRIMARY KEY AUTO_INCREMENT,
  customer_name VARCHAR(100) NOT NULL,
  email VARCHAR(100) UNIQUE NOT NULL
);

CREATE TABLE Accounts (
  account_id INT PRIMARY KEY AUTO_INCREMENT,
  customer_id INT NOT NULL,
  account_type ENUM('Checking', 'Savings') NOT NULL,
  balance DECIMAL(12, 2) NOT NULL DEFAULT 0.00 CHECK (balance >= 0),
  status ENUM('Active', 'Closed') NOT NULL DEFAULT 'Active',
  FOREIGN KEY (customer_id) REFERENCES Customers(customer_id) ON DELETE CASCADE
);

CREATE TABLE Transactions (
  transaction_id INT PRIMARY KEY AUTO_INCREMENT,
  account_id INT NOT NULL,
  transaction_type ENUM('Debit', 'Credit', 'Transfer') NOT NULL,
  amount DECIMAL(12, 2) NOT NULL CHECK (amount > 0),
  transaction_date DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
  FOREIGN KEY (account_id) REFERENCES Accounts(account_id) ON DELETE CASCADE
);

INSERT INTO Customers (customer_name, email)
VALUES
  ('Alice Smith', 'alice@example.com'),
  ('Bob Johnson', 'bob@example.com');


INSERT INTO Accounts (customer_id, account_type, balance)
VALUES
  (1, 'Checking', 1000.00),
  (1, 'Savings', 5000.00),
  (2, 'Checking', 2000.00);

-- •	Update balances on debit/credit.
START TRANSACTION;

INSERT INTO Transactions (account_id, transaction_type, amount)
VALUES (1, 'Debit', 200.00);

UPDATE Accounts
SET balance = balance - 200.00
WHERE account_id = 1;

COMMIT;


START TRANSACTION;

INSERT INTO Transactions (account_id, transaction_type, amount)
VALUES (3, 'Credit', 500.00);

UPDATE Accounts
SET balance = balance + 500.00
WHERE account_id = 3;

COMMIT;
-- •	Delete closed accounts.
UPDATE Accounts
SET status = 'Closed'
WHERE account_id = 2;

DELETE FROM Accounts
WHERE status = 'Closed' AND account_id > 0;

-- •	Use transactions to perform transfers and rollback on errors.
START TRANSACTION;

UPDATE Accounts
SET balance = balance - 300.00
WHERE account_id = 1;

INSERT INTO Transactions (account_id, transaction_type, amount)
VALUES (1, 'Transfer', 300.00);

UPDATE Accounts
SET balance = balance + 300.00
WHERE account_id = 2;

INSERT INTO Transactions (account_id, transaction_type, amount)
VALUES (2, 'Transfer', 300.00);