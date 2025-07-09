CREATE DATABASE Banking_transactionDB;
USE Banking_transactionDB;

CREATE TABLE Customers (
  customer_id INT AUTO_INCREMENT PRIMARY KEY,
  customer_name VARCHAR(100) NOT NULL,
  email VARCHAR(100),
  phone VARCHAR(20)
);

CREATE TABLE Accounts (
  account_id INT AUTO_INCREMENT PRIMARY KEY,
  customer_id INT NOT NULL,
  account_number VARCHAR(20) UNIQUE NOT NULL,
  account_type ENUM('Savings', 'Checking') NOT NULL,
  balance DECIMAL(15,2) DEFAULT 0.00,
  FOREIGN KEY (customer_id) REFERENCES Customers(customer_id)
);


CREATE TABLE Transactions (
  transaction_id INT AUTO_INCREMENT PRIMARY KEY,
  account_id INT NOT NULL,
  transaction_date DATE NOT NULL,
  amount DECIMAL(12,2) NOT NULL,
  transaction_type ENUM('Credit', 'Debit') NOT NULL,
  description VARCHAR(255),
  FOREIGN KEY (account_id) REFERENCES Accounts(account_id)
);


CREATE INDEX idx_account_id ON Transactions(account_id);
CREATE INDEX idx_transaction_date ON Transactions(transaction_date);
CREATE INDEX idx_amount ON Transactions(amount);



INSERT INTO Customers (customer_name, email, phone) VALUES
('Alice Johnson', 'alice@example.com', '555-1111'),
('Bob Smith', 'bob@example.com', '555-2222'),
('Carol White', 'carol@example.com', '555-3333');


INSERT INTO Accounts (customer_id, account_number, account_type, balance) VALUES
(1, 'ACC1001', 'Savings', 5000.00),
(1, 'ACC1002', 'Checking', 1200.00),
(2, 'ACC2001', 'Savings', 7500.00),
(3, 'ACC3001', 'Checking', 2000.00);


INSERT INTO Transactions (account_id, transaction_date, amount, transaction_type, description) VALUES
(1, '2025-07-01', 1000.00, 'Credit', 'Salary deposit'),
(1, '2025-07-02', 150.00, 'Debit', 'Groceries'),
(1, '2025-07-03', 200.00, 'Debit', 'Utilities'),
(1, '2025-07-04', 500.00, 'Debit', 'Rent payment'),
(1, '2025-07-05', 50.00, 'Debit', 'Coffee shop'),
(2, '2025-07-01', 1200.00, 'Credit', 'Transfer from savings'),
(2, '2025-07-02', 100.00, 'Debit', 'Online shopping'),
(2, '2025-07-03', 150.00, 'Debit', 'Restaurant'),
(2, '2025-07-04', 300.00, 'Debit', 'Travel booking'),
(2, '2025-07-05', 80.00, 'Debit', 'Taxi'),
(3, '2025-07-01', 7500.00, 'Credit', 'Bonus'),
(3, '2025-07-02', 1000.00, 'Debit', 'New phone'),
(3, '2025-07-03', 500.00, 'Debit', 'Dining out'),
(3, '2025-07-04', 2000.00, 'Debit', 'Electronics'),
(3, '2025-07-05', 300.00, 'Debit', 'Gift'),
(4, '2025-07-01', 2000.00, 'Credit', 'Freelance work'),
(4, '2025-07-02', 250.00, 'Debit', 'Bills'),
(4, '2025-07-03', 400.00, 'Debit', 'Fuel'),
(4, '2025-07-04', 300.00, 'Debit', 'Dinner'),
(4, '2025-07-05', 100.00, 'Debit', 'Snacks'),
(1, '2025-07-06', 1200.00, 'Credit', 'Project payment'),
(1, '2025-07-07', 4000.00, 'Debit', 'Car purchase'),
(2, '2025-07-06', 1500.00, 'Credit', 'Refund'),
(2, '2025-07-07', 100.00, 'Debit', 'Grocery'),
(3, '2025-07-06', 5000.00, 'Debit', 'Travel'),
(4, '2025-07-06', 2500.00, 'Credit', 'Loan disbursement'),
(4, '2025-07-07', 2500.00, 'Debit', 'Large purchase');


EXPLAIN
SELECT 
  t.transaction_id,
  a.account_number,
  c.customer_name,
  t.amount,
  t.transaction_date,
  t.transaction_type,
  t.description
FROM Transactions t
JOIN Accounts a ON t.account_id = a.account_id
JOIN Customers c ON a.customer_id = c.customer_id
WHERE t.amount > 4000
ORDER BY t.amount DESC;


CREATE OR REPLACE VIEW AccountStatement AS
SELECT 
  c.customer_id,
  c.customer_name,
  a.account_number,
  a.account_type,
  t.transaction_id,
  t.transaction_date,
  t.amount,
  t.transaction_type,
  t.description
FROM Customers c
JOIN Accounts a ON c.customer_id = a.customer_id
JOIN Transactions t ON a.account_id = t.account_id
ORDER BY t.transaction_date DESC;

SELECT *
FROM AccountStatement
WHERE account_number = 'ACC1001'
ORDER BY transaction_date DESC
LIMIT 5;
