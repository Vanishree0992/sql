CREATE DATABASE ProfitDB;
USE ProfitDB;

-- 2) Tables
CREATE TABLE Products (
  product_id INT PRIMARY KEY,
  product_name VARCHAR(100),
  category VARCHAR(50),
  unit_cost DECIMAL(10,2)
);

CREATE TABLE Orders (
  order_id INT PRIMARY KEY,
  order_date DATE
);

CREATE TABLE Order_Details (
  order_detail_id INT PRIMARY KEY,
  order_id INT,
  product_id INT,
  quantity INT,
  unit_price DECIMAL(10,2),
  line_total DECIMAL(12,2),
  FOREIGN KEY (order_id) REFERENCES Orders(order_id),
  FOREIGN KEY (product_id) REFERENCES Products(product_id)
);

-- 3) Sample Data
INSERT INTO Products VALUES
 (1, 'Shirt', 'Apparel', 200.00),
 (2, 'Jeans', 'Apparel', 500.00),
 (3, 'TV', 'Electronics', 10000.00),
 (4, 'Phone', 'Electronics', 8000.00),
 (5, 'Shoes', 'Footwear', 600.00);

INSERT INTO Orders VALUES
 (1, '2025-06-01'),
 (2, '2025-06-10'),
 (3, '2025-07-01');

INSERT INTO Order_Details VALUES
 (1, 1, 1, 5, 500.00, 2500.00),
 (2, 1, 2, 2, 1000.00, 2000.00),
 (3, 2, 3, 1, 20000.00, 20000.00),
 (4, 3, 4, 1, 15000.00, 15000.00),
 (5, 3, 5, 3, 1000.00, 3000.00);

-- 4) Profit Report Table
CREATE TABLE profit_report (
  category VARCHAR(50),
  total_revenue DECIMAL(12,2),
  total_cost DECIMAL(12,2),
  profit DECIMAL(12,2),
  report_date DATETIME DEFAULT CURRENT_TIMESTAMP
);

-- 5) ETL Insert
INSERT INTO profit_report (category, total_revenue, total_cost, profit)
SELECT 
  p.category,
  SUM(od.line_total) AS total_revenue,
  SUM(od.quantity * p.unit_cost) AS total_cost,
  SUM(od.line_total) - SUM(od.quantity * p.unit_cost) AS profit
FROM 
  Order_Details od
  JOIN Products p ON od.product_id = p.product_id
GROUP BY 
  p.category
HAVING 
  profit > 10000;

-- 6) View Report
SELECT * FROM profit_report;
