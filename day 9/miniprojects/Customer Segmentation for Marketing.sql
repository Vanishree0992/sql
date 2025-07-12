CREATE DATABASE MarketingDB;
USE MarketingDB;

-- Customers table
CREATE TABLE IF NOT EXISTS Customers (
  customer_id INT PRIMARY KEY,
  first_name VARCHAR(50),
  last_name VARCHAR(50),
  email VARCHAR(100)
);

-- Orders table
CREATE TABLE IF NOT EXISTS Orders (
  order_id INT PRIMARY KEY,
  customer_id INT,
  order_date DATE,
  total_amount DECIMAL(12,2),
  FOREIGN KEY (customer_id) REFERENCES Customers(customer_id)
);


-- Customers
INSERT INTO Customers VALUES
 (1, 'John', 'Doe', 'john@example.com'),
 (2, 'Jane', 'Smith', 'jane@example.com'),
 (3, 'Bob', 'Brown', 'bob@example.com');

-- Orders
INSERT INTO Orders VALUES
 (1, 1, '2025-01-10', 10000.00),
 (2, 1, '2025-02-15', 15000.00),
 (3, 2, '2025-03-05', 20000.00),
 (4, 2, '2025-03-20', 15000.00),
 (5, 3, '2025-04-01', 5000.00);


-- Create the Customer_Segments table
CREATE TABLE IF NOT EXISTS Customer_Segments (
  customer_id INT PRIMARY KEY,
  total_purchase DECIMAL(12,2),
  segment VARCHAR(20),
  FOREIGN KEY (customer_id) REFERENCES Customers(customer_id)
);

-- Run ETL to calculate total spend & assign segments
-- Truncate before reload (safe ETL pattern)
TRUNCATE TABLE Customer_Segments;

-- Insert updated segments
INSERT INTO Customer_Segments (customer_id, total_purchase, segment)
SELECT 
  c.customer_id,
  IFNULL(SUM(o.total_amount), 0) AS total_purchase,
  CASE
    WHEN IFNULL(SUM(o.total_amount), 0) > 30000 THEN 'Gold'
    WHEN IFNULL(SUM(o.total_amount), 0) BETWEEN 15000 AND 30000 THEN 'Silver'
    ELSE 'Bronze'
  END AS segment
FROM 
  Customers c
  LEFT JOIN Orders o ON c.customer_id = o.customer_id
GROUP BY 
  c.customer_id;

--  Check the segments
SELECT 
  c.customer_id,
  CONCAT(c.first_name, ' ', c.last_name) AS customer_name,
  cs.total_purchase,
  cs.segment
FROM 
  Customer_Segments cs
  JOIN Customers c ON cs.customer_id = c.customer_id;
