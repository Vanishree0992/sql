CREATE DATABASE bank_statisticsDB;
USE bank_statisticsDB;

CREATE TABLE branches (
    branch_id INT PRIMARY KEY,
    branch_name VARCHAR(100),
    location VARCHAR(100)
);

CREATE TABLE customers (
    customer_id INT PRIMARY KEY,
    name VARCHAR(100),
    branch_id INT,
    FOREIGN KEY (branch_id) REFERENCES branches(branch_id)
);

CREATE TABLE accounts (
    account_id INT PRIMARY KEY,
    customer_id INT,
    balance DECIMAL(15,2),
    FOREIGN KEY (customer_id) REFERENCES customers(customer_id)
);

CREATE TABLE transactions (
    transaction_id INT PRIMARY KEY,
    account_id INT,
    transaction_date DATE,
    amount DECIMAL(15,2),
    FOREIGN KEY (account_id) REFERENCES accounts(account_id)
);


INSERT INTO branches 
VALUES
(1, 'Downtown', 'City Center'),
(2, 'Uptown', 'North Side'),
(3, 'Suburb', 'Suburban Area');


INSERT INTO customers 
VALUES
(1, 'Alice', 1),
(2, 'Bob', 1),
(3, 'Charlie', 2),
(4, 'Diana', 3),
(5, 'Eve', 3);


INSERT INTO accounts 
VALUES
(1, 1, 5000.00),
(2, 2, 3000.00),
(3, 3, 7000.00),
(4, 4, 0.00),
(5, 5, 1500.00);


INSERT INTO transactions 
VALUES
(1, 1, '2025-06-01', 1000.00),
(2, 1, '2025-06-10', -500.00),
(3, 2, '2025-06-05', 3000.00),
(4, 3, '2025-06-15', 7000.00);


-- Count accounts and total balance per branch.
SELECT 
    b.branch_id,
    b.branch_name,
    COUNT(a.account_id) AS total_accounts,
    COALESCE(SUM(a.balance), 0) AS total_balance
FROM branches b
LEFT JOIN customers c ON b.branch_id = c.branch_id
LEFT JOIN accounts a ON c.customer_id = a.customer_id
GROUP BY b.branch_id, b.branch_name;

-- List customers with no transactions.
SELECT 
    c.customer_id,
    c.name
FROM customers c
JOIN accounts a ON c.customer_id = a.customer_id
LEFT JOIN transactions t ON a.account_id = t.account_id
GROUP BY c.customer_id, c.name
HAVING COUNT(t.transaction_id) = 0;

-- Find branches with the highest/lowest number of customers.
WITH customer_counts AS (
    SELECT 
        b.branch_id,
        b.branch_name,
        COUNT(c.customer_id) AS num_customers
    FROM branches b
    LEFT JOIN customers c ON b.branch_id = c.branch_id
    GROUP BY b.branch_id, b.branch_name
)
SELECT * FROM customer_counts
WHERE num_customers = (SELECT MAX(num_customers) FROM customer_counts)
   OR num_customers = (SELECT MIN(num_customers) FROM customer_counts);

