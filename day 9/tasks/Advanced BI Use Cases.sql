CREATE DATABASE Retail_BI;
USE Retail_BI;

CREATE TABLE Products (
  product_id INT PRIMARY KEY,
  product_name VARCHAR(50),
  category VARCHAR(50)
);

CREATE TABLE Locations (
  location_id INT PRIMARY KEY,
  city VARCHAR(50),
  region VARCHAR(50)
);

CREATE TABLE Sales (
  sales_id INT PRIMARY KEY,
  product_id INT,
  location_id INT,
  customer_id INT,
  order_date DATE,
  amount DECIMAL(12,2),
  FOREIGN KEY (product_id) REFERENCES Products(product_id),
  FOREIGN KEY (location_id) REFERENCES Locations(location_id)
);

INSERT INTO Products VALUES
  (1, 'Shirt', 'Apparel'),
  (2, 'TV', 'Electronics'),
  (3, 'Shoes', 'Footwear'),
  (4, 'Phone', 'Electronics'),
  (5, 'Jeans', 'Apparel');

INSERT INTO Locations VALUES
  (1, 'New York', 'East'),
  (2, 'Los Angeles', 'West'),
  (3, 'Chicago', 'Midwest');

INSERT INTO Sales VALUES
  (1, 1, 1, 101, '2025-01-10', 1000.00),
  (2, 2, 1, 102, '2025-02-15', 5000.00),
  (3, 3, 2, 103, '2025-02-20', 2000.00),
  (4, 4, 2, 104, '2025-03-01', 7000.00),
  (5, 5, 3, 105, '2025-04-05', 3000.00),
  (6, 1, 1, 101, '2025-04-10', 1500.00),
  (7, 2, 1, 102, '2025-04-15', 8000.00),
  (8, 3, 2, 103, '2025-04-20', 2500.00),
  (9, 4, 2, 104, '2025-05-01', 6000.00),
  (10, 5, 3, 105, '2025-05-05', 3500.00);

CREATE OR REPLACE VIEW Dashboard_View AS
SELECT 
  EXTRACT(YEAR FROM s.order_date) AS sales_year,
  EXTRACT(MONTH FROM s.order_date) AS sales_month,
  SUM(s.amount) AS monthly_sales,
  p.product_name,
  SUM(s.amount) AS product_sales,
  l.region,
  SUM(SUM(s.amount)) OVER (PARTITION BY l.region) AS region_revenue
FROM 
  Sales s
  JOIN Products p ON s.product_id = p.product_id
  JOIN Locations l ON s.location_id = l.location_id
GROUP BY 
  sales_year, sales_month, p.product_name, l.region
ORDER BY 
  monthly_sales DESC, product_sales DESC
LIMIT 3;

-- 46 Simulate by creating a table + populate it + schedule refresh
CREATE TABLE High_Cost_Agg AS
SELECT 
  EXTRACT(YEAR FROM order_date) AS sales_year,
  EXTRACT(MONTH FROM order_date) AS sales_month,
  product_id,
  SUM(amount) AS total_sales
FROM Sales
GROUP BY sales_year, sales_month, product_id;


-- 47 Rolling 3-month average revenue
SELECT
  EXTRACT(YEAR FROM order_date) AS sales_year,
  EXTRACT(MONTH FROM order_date) AS sales_month,
  SUM(amount) AS monthly_sales,
  AVG(SUM(amount)) OVER (
    ORDER BY EXTRACT(YEAR FROM order_date), EXTRACT(MONTH FROM order_date)
    ROWS BETWEEN 2 PRECEDING AND CURRENT ROW
  ) AS rolling_3_month_avg
FROM 
  Sales
GROUP BY 
  sales_year, sales_month
ORDER BY 
  sales_year, sales_month;


-- 48 Customer churn: inactive in last 90 days
SELECT DISTINCT 
  customer_id
FROM 
  Sales
WHERE 
  customer_id NOT IN (
    SELECT DISTINCT customer_id
    FROM Sales
    WHERE order_date >= DATE_SUB(CURDATE(), INTERVAL 90 DAY)
  );

-- 49 Top 5 product categories consistently appearing in top sales monthly
SELECT 
  category, 
  COUNT(*) AS months_in_top5
FROM (
  SELECT 
    EXTRACT(YEAR FROM s.order_date) AS year,
    EXTRACT(MONTH FROM s.order_date) AS month,
    p.category,
    SUM(s.amount) AS total_sales,
    RANK() OVER (PARTITION BY EXTRACT(YEAR FROM s.order_date), EXTRACT(MONTH FROM s.order_date)
                 ORDER BY SUM(s.amount) DESC) AS rank_in_month
  FROM 
    Sales s JOIN Products p ON s.product_id = p.product_id
  GROUP BY 
    year, month, category
) ranked
WHERE 
  rank_in_month <= 5
GROUP BY 
  category
ORDER BY 
  months_in_top5 DESC
LIMIT 5;

-- 50 Optimize heavy query: create index + run EXPLAIN
CREATE INDEX idx_order_date_product ON Sales(order_date, product_id);

EXPLAIN
SELECT 
  EXTRACT(YEAR FROM order_date) AS sales_year,
  EXTRACT(MONTH FROM order_date) AS sales_month,
  product_id,
  SUM(amount) AS total_sales
FROM Sales
GROUP BY sales_year, sales_month, product_id;
