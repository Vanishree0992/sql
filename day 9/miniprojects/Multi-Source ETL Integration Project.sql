CREATE DATABASE IF NOT EXISTS dw_combined_data;
USE dw_combined_data;

CREATE TABLE dw_customers (
  customer_id INT PRIMARY KEY,
  customer_name VARCHAR(100),
  email VARCHAR(100)
);

CREATE TABLE dw_orders (
  order_id INT PRIMARY KEY,
  customer_id INT,
  order_date DATE,
  total_amount DECIMAL(12,2)
);

CREATE TABLE dw_products (
  product_id INT PRIMARY KEY,
  product_name VARCHAR(100),
  category VARCHAR(50)
);

CREATE TABLE dw_combined_sales (
  order_id INT,
  customer_id INT,
  customer_name VARCHAR(100),
  product_id INT,
  product_name VARCHAR(100),
  category VARCHAR(50),
  order_date DATE,
  total_amount DECIMAL(12,2)
);

--  Sample Data Insert (if no real ETL)
INSERT INTO dw_customers VALUES (1, 'Alice', 'alice@mail.com'), (2, 'Bob', 'bob@mail.com');
INSERT INTO dw_orders VALUES (1, 1, '2025-07-01', 5000.00), (2, 2, '2025-07-02', 8000.00);
INSERT INTO dw_products VALUES (1, 'Laptop', 'Electronics'), (2, 'Shoes', 'Apparel');

--  Transform: standardize
UPDATE dw_products 
SET product_name = LOWER(product_name)
WHERE product_id > 0;

--  Load Combined
INSERT INTO dw_combined_sales
SELECT
  o.order_id,
  o.customer_id,
  c.customer_name,
  p.product_id,
  p.product_name,
  p.category,
  o.order_date,
  o.total_amount
FROM
  dw_orders o
  JOIN dw_customers c ON o.customer_id = c.customer_id
  JOIN dw_products p ON p.product_id = 1; -- example mapping

--  Verify
SELECT * FROM dw_combined_sales;
