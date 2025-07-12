CREATE DATABASE IF NOT EXISTS ProductStockDB;
USE ProductStockDB;

CREATE TABLE Products (
  product_id INT PRIMARY KEY,
  product_name VARCHAR(50),
  initial_stock INT,
  reorder_threshold INT
);

CREATE TABLE Orders (
  order_id INT PRIMARY KEY,
  product_id INT,
  quantity_sold INT,
  order_date DATE,
  FOREIGN KEY (product_id) REFERENCES Products(product_id)
);

CREATE TABLE warehouse_alerts (
  alert_id INT AUTO_INCREMENT PRIMARY KEY,
  product_id INT,
  product_name VARCHAR(50),
  stock_left INT,
  reorder_threshold INT,
  alert_date DATETIME DEFAULT CURRENT_TIMESTAMP
);

-- 3) Data
INSERT INTO Products VALUES
 (1, 'Shirt', 100, 20),
 (2, 'Shoes', 50, 10),
 (3, 'TV', 30, 5),
 (4, 'Phone', 40, 8);

INSERT INTO Orders VALUES
 (1, 1, 30, '2025-01-10'),
 (2, 1, 40, '2025-02-15'),
 (3, 2, 45, '2025-03-20'),
 (4, 3, 20, '2025-04-05'),
 (5, 4, 35, '2025-04-25');
 
-- Check Stock Left
SELECT 
  p.product_id,
  p.product_name,
  p.initial_stock - IFNULL(SUM(o.quantity_sold), 0) AS stock_left,
  p.reorder_threshold
FROM 
  Products p
  LEFT JOIN Orders o ON p.product_id = o.product_id
GROUP BY 
  p.product_id, p.product_name, p.initial_stock, p.reorder_threshold;

-- Filter Low Stock
SELECT 
  p.product_id,
  p.product_name,
  p.initial_stock - IFNULL(SUM(o.quantity_sold), 0) AS stock_left,
  p.reorder_threshold
FROM 
  Products p
  LEFT JOIN Orders o ON p.product_id = o.product_id
GROUP BY 
  p.product_id, p.product_name, p.initial_stock, p.reorder_threshold
HAVING 
  stock_left < reorder_threshold;
-- 4) ETL: Load alerts
INSERT INTO warehouse_alerts (product_id, product_name, stock_left, reorder_threshold)
SELECT 
  p.product_id,
  p.product_name,
  p.initial_stock - IFNULL(SUM(o.quantity_sold), 0) AS stock_left,
  p.reorder_threshold
FROM 
  Products p
  LEFT JOIN Orders o ON p.product_id = o.product_id
GROUP BY 
  p.product_id, p.product_name, p.initial_stock, p.reorder_threshold
HAVING 
  stock_left < reorder_threshold;

-- 5) Check Alerts
SELECT * FROM warehouse_alerts;
