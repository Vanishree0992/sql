CREATE DATABASE TimeRevenueDB;
USE TimeRevenueDB;

CREATE TABLE Orders (
  order_id INT PRIMARY KEY,
  customer_id INT,
  product_id INT,
  order_date DATE,
  total_amount DECIMAL(12,2)
);

INSERT INTO Orders VALUES
 (1, 1, 1, '2025-01-05', 5000.00),
 (2, 1, 2, '2025-01-15', 15000.00),
 (3, 2, 1, '2025-02-10', 8000.00),
 (4, 2, 3, '2025-03-20', 12000.00),
 (5, 3, 2, '2025-04-10', 20000.00),
 (6, 3, 1, '2025-05-05', 7000.00),
 (7, 4, 2, '2025-06-25', 25000.00),
 (8, 1, 3, '2025-07-10', 5000.00),
 (9, 2, 1, '2025-08-15', 9000.00),
 (10, 3, 2, '2025-09-05', 22000.00);


SELECT 
  order_date,
  SUM(total_amount) AS daily_revenue
FROM Orders
GROUP BY order_date
ORDER BY order_date;

SELECT 
  EXTRACT(YEAR FROM order_date) AS year,
  EXTRACT(WEEK FROM order_date) AS week,
  SUM(total_amount) AS weekly_revenue
FROM Orders
GROUP BY year, week
ORDER BY year, week;

SELECT 
  EXTRACT(YEAR FROM order_date) AS year,
  EXTRACT(MONTH FROM order_date) AS month,
  SUM(total_amount) AS monthly_revenue
FROM Orders
GROUP BY year, month
ORDER BY year, month;

SELECT 
  EXTRACT(YEAR FROM order_date) AS year,
  QUARTER(order_date) AS quarter,
  SUM(total_amount) AS quarterly_revenue
FROM Orders
GROUP BY year, quarter
ORDER BY year, quarter;

SELECT 
  EXTRACT(YEAR FROM order_date) AS year,
  SUM(total_amount) AS yearly_revenue
FROM Orders
GROUP BY year
ORDER BY year;

SELECT 
  year,
  quarter,
  quarterly_revenue
FROM (
  SELECT 
    EXTRACT(YEAR FROM order_date) AS year,
    QUARTER(order_date) AS quarter,
    SUM(total_amount) AS quarterly_revenue
  FROM Orders
  GROUP BY year, quarter
) AS sub
ORDER BY quarterly_revenue DESC;

-- Best Quarter vs Worst Quarter
SELECT 
  year,
  quarter,
  quarterly_revenue
FROM (
  SELECT 
    EXTRACT(YEAR FROM order_date) AS year,
    QUARTER(order_date) AS quarter,
    SUM(total_amount) AS quarterly_revenue
  FROM Orders
  GROUP BY year, quarter
) AS sub
ORDER BY quarterly_revenue DESC;

