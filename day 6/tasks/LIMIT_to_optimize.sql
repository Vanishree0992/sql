USE sql_24DB;

CREATE TABLE Customers (
  customer_id INT PRIMARY KEY AUTO_INCREMENT,
  customer_name VARCHAR(50)
);

-- Insert 10 sample customers
INSERT INTO Customers (customer_name)
VALUES ('Alice'), ('Bob'), ('Charlie'), ('David'), ('Eve'),
       ('Frank'), ('Grace'), ('Heidi'), ('Ivan'), ('Judy');

-- 26.	Write a query to retrieve the first 5 customers from a Customers table using LIMIT.
SELECT * FROM Customers LIMIT 5;

-- 27.	Retrieve top 10 products sorted by price DESC using ORDER BY and LIMIT.
CREATE TABLE IF NOT EXISTS Products (
  product_id INT PRIMARY KEY AUTO_INCREMENT,
  product_name VARCHAR(50),
  price DECIMAL(10,2)
);

INSERT INTO Products (product_name, price)
SELECT 
  CONCAT('Product', t.n), 
  FLOOR(100 + (RAND() * 900))
FROM (
  SELECT 1 n UNION SELECT 2 UNION SELECT 3 UNION SELECT 4 UNION SELECT 5
  UNION SELECT 6 UNION SELECT 7 UNION SELECT 8 UNION SELECT 9 UNION SELECT 10
  UNION SELECT 11 UNION SELECT 12 UNION SELECT 13 UNION SELECT 14 UNION SELECT 15
  UNION SELECT 16 UNION SELECT 17 UNION SELECT 18 UNION SELECT 19 UNION SELECT 20
) t;

SELECT * FROM Products
ORDER BY price DESC
LIMIT 10;

-- 28.	Combine WHERE, ORDER BY, and LIMIT in one optimized query.
SELECT emp_id, emp_name, salary
FROM Employees
WHERE dept_id = 1
ORDER BY salary DESC
LIMIT 5;

-- 29.	Test performance of SELECT * FROM large_table LIMIT 5 vs full query.
EXPLAIN SELECT * FROM Employees LIMIT 5;

-- Compare to full table
EXPLAIN SELECT * FROM Employees;
-- 30.	Use LIMIT with OFFSET to implement pagination (e.g., records 11–20).
SELECT emp_id, emp_name
FROM Employees
ORDER BY emp_id
LIMIT 10 OFFSET 10;