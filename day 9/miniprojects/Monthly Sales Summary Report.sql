CREATE DATABASE SalesDB;
USE SalesDB;

CREATE TABLE Orders (
  order_id INT PRIMARY KEY,
  customer_id INT,
  product_id INT,
  order_date DATE,
  quantity INT,
  total_amount DECIMAL(12,2)
);

INSERT INTO Orders VALUES
  (1, 1, 1, '2025-01-10', 2, 10000.00),
  (2, 2, 2, '2025-01-15', 1, 15000.00),
  (3, 3, 3, '2025-02-05', 1, 30000.00),
  (4, 1, 1, '2025-02-20', 3, 25000.00),
  (5, 2, 2, '2025-03-01', 2, 50000.00),
  (6, 3, 3, '2025-03-25', 1, 10000.00);

-- Monthly Sales Summary Report
SELECT 
  YEAR(order_date) AS sales_year,
  MONTH(order_date) AS sales_month,
  COUNT(order_id) AS total_orders,
  SUM(total_amount) AS total_revenue
FROM 
  Orders
GROUP BY 
  YEAR(order_date), MONTH(order_date)
HAVING 
  SUM(total_amount) > 50000
ORDER BY 
  sales_year, sales_month;
