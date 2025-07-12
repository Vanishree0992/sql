CREATE DATABASE Retail_ETL;
USE Retail_ETL;

CREATE TABLE Customers (
  customer_id INT PRIMARY KEY,
  first_name VARCHAR(50),
  last_name VARCHAR(50),
  email VARCHAR(100),
  status VARCHAR(20)
);

CREATE TABLE Orders (
  order_id INT PRIMARY KEY,
  customer_id INT,
  order_date DATE,
  total_amount DECIMAL(12,2),
  FOREIGN KEY (customer_id) REFERENCES Customers(customer_id)
);

CREATE TABLE Products (
  product_id INT PRIMARY KEY,
  product_name VARCHAR(50),
  category VARCHAR(50)
);

INSERT INTO Customers VALUES
  (1, 'Alice', 'Smith', 'alice@mail.com', 'Active'),
  (2, 'Bob', 'Johnson', NULL, 'Inactive'),
  (3, 'Charlie', 'Brown', 'charlie@mail.com', 'Active'),
  (4, 'David', 'Williams', NULL, 'Active'),
  (5, 'Emma', 'Jones', 'emma@mail.com', 'Inactive');

INSERT INTO Orders VALUES
  (1, 1, '2025-04-01', 15000.00),
  (2, 1, '2025-06-15', 10000.00),
  (3, 3, '2025-03-20', 25000.00),
  (4, 4, '2025-07-01', 8000.00),
  (5, 5, '2024-12-10', 5000.00);

INSERT INTO Products VALUES
  (1, 'Shirt', 'APPAREL'),
  (2, 'TV', 'ELECTRONICS'),
  (3, 'Shoes', 'FOOTWEAR');


-- 26 Extract active customer data
SELECT *
FROM Customers
WHERE status = 'Active';

-- 27 Extract orders made in the last 6 months
SELECT *
FROM Orders
WHERE order_date >= DATE_SUB(CURDATE(), INTERVAL 6 MONTH);

-- 28 Export to CSV
mysql -u your_user -p -e "SELECT * FROM Orders WHERE order_date >= DATE_SUB(CURDATE(), INTERVAL 6 MONTH)" > orders_last_6_months.csv

-- 29 Extract high-value customers (spent > ₹20,000)
SELECT 
  c.customer_id,
  CONCAT(c.first_name, ' ', c.last_name) AS full_name,
  SUM(o.total_amount) AS total_spent
FROM 
  Customers c
  JOIN Orders o ON c.customer_id = o.customer_id
GROUP BY 
  c.customer_id, full_name
HAVING 
  SUM(o.total_amount) > 20000;

-- 30 Transform all customer names to UPPERCASE
UPDATE Customers
SET first_name = UPPER(first_name),
    last_name = UPPER(last_name)
WHERE customer_id > 0; 

-- 31 Replace NULL email with default
UPDATE Customers
SET email = IFNULL(email, CONCAT(LOWER(first_name), '@defaultmail.com'))
WHERE customer_id > 0;

-- 32 Derived column: full name
SELECT 
  customer_id, 
  CONCAT(first_name, ' ', last_name) AS full_name 
FROM Customers;

-- 33 Standardize product categories to lowercase
UPDATE Products
SET category = LOWER(category)
WHERE product_id > 0;
-- 34 Calculate tax column (18% of total_amount)
SELECT 
  order_id,
  total_amount,
  total_amount * 0.18 AS tax_amount
FROM Orders;

-- 35 Create dw_sales_summary for storing aggregated data
CREATE TABLE dw_sales_summary (
  customer_id INT,
  total_purchases DECIMAL(12,2)
);

-- 36 Load total purchases per customer
INSERT INTO dw_sales_summary (customer_id, total_purchases)
SELECT 
  customer_id,
  SUM(total_amount)
FROM Orders
GROUP BY customer_id;

-- 37 Load product-level monthly summary into dw_monthly_product_sales
CREATE TABLE dw_monthly_product_sales (
  month INT,
  year INT,
  product_id INT,
  total_sales DECIMAL(12,2)
);

INSERT INTO dw_monthly_product_sales (month, year, product_id, total_sales)
SELECT 
  MONTH(order_date) AS month,
  YEAR(order_date) AS year,
  1 AS product_id,  -- Example: assign all to one product for demo
  SUM(total_amount)
FROM Orders
GROUP BY YEAR(order_date), MONTH(order_date), product_id;

-- 38 Full ETL simulation script (EXTRACT → TRANSFORM → LOAD)
SELECT * FROM Customers WHERE status = 'Active';
SELECT * FROM Orders WHERE order_date >= DATE_SUB(CURDATE(), INTERVAL 6 MONTH);

UPDATE Customers
SET first_name = UPPER(first_name),
    last_name = UPPER(last_name)
WHERE customer_id > 0;
UPDATE Customers SET email = IFNULL(email, CONCAT(LOWER(first_name), '@defaultmail.com'));
UPDATE Products SET category = LOWER(category);

INSERT INTO dw_sales_summary (customer_id, total_purchases)
SELECT customer_id, SUM(total_amount) FROM Orders GROUP BY customer_id;

-- 39 Create ETL log table and log success/failure

CREATE TABLE etl_transaction_log (
  log_id INT AUTO_INCREMENT PRIMARY KEY,
  etl_step VARCHAR(50),
  status VARCHAR(20),
  log_timestamp DATETIME DEFAULT CURRENT_TIMESTAMP
);

INSERT INTO etl_transaction_log (etl_step, status) VALUES ('EXTRACT', 'SUCCESS');
INSERT INTO etl_transaction_log (etl_step, status) VALUES ('TRANSFORM', 'SUCCESS');
INSERT INTO etl_transaction_log (etl_step, status) VALUES ('LOAD', 'SUCCESS');
