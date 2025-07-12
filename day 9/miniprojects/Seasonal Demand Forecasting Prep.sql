CREATE DATABASE SeasonalForecastDB;
USE SeasonalForecastDB;

--  Tables
CREATE TABLE Orders (
  order_id INT PRIMARY KEY,
  order_date DATE
);

CREATE TABLE Order_Details (
  order_detail_id INT PRIMARY KEY,
  order_id INT,
  product_id INT,
  quantity INT,
  FOREIGN KEY (order_id) REFERENCES Orders(order_id)
);

CREATE TABLE Products (
  product_id INT PRIMARY KEY,
  product_name VARCHAR(100)
);

CREATE TABLE trending_products (
  product_id INT,
  product_name VARCHAR(100),
  month INT,
  year INT,
  quantity INT,
  mom_change INT,
  created_at DATETIME DEFAULT CURRENT_TIMESTAMP
);

--  Sample Data
INSERT INTO Products VALUES
 (1, 'Shirt'),
 (2, 'Shoes'),
 (3, 'TV');

INSERT INTO Orders VALUES
 (1, '2025-01-10'),
 (2, '2025-02-10'),
 (3, '2025-02-15'),
 (4, '2025-03-10'),
 (5, '2025-03-20');

INSERT INTO Order_Details VALUES
 (1, 1, 1, 10),
 (2, 2, 1, 12),
 (3, 3, 2, 5),
 (4, 4, 1, 15),
 (5, 5, 3, 2);

--  Load Trending Products
INSERT INTO trending_products (product_id, product_name, year, month, quantity, mom_change)
SELECT 
  product_id,
  product_name,
  yr,
  mnth,
  total_qty,
  mom_change
FROM 
  (
    WITH MonthlyDemand AS (
      SELECT 
        p.product_id,
        p.product_name,
        EXTRACT(YEAR FROM o.order_date) AS yr,
        EXTRACT(MONTH FROM o.order_date) AS mnth,
        SUM(od.quantity) AS total_qty
      FROM 
        Order_Details od
        JOIN Orders o ON od.order_id = o.order_id
        JOIN Products p ON od.product_id = p.product_id
      GROUP BY 
        p.product_id, p.product_name, yr, mnth
    ),
    MonthlyWithTrend AS (
      SELECT
        product_id,
        product_name,
        yr,
        mnth,
        total_qty,
        total_qty - LAG(total_qty, 1) OVER (PARTITION BY product_id ORDER BY yr, mnth) AS mom_change
      FROM 
        MonthlyDemand
    )
    SELECT * FROM MonthlyWithTrend
  ) AS sub
WHERE 
  mom_change > 0;

--  Verify
SELECT * FROM trending_products;
