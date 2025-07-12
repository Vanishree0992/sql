CREATE DATABASE FlashSalesDB;
USE FlashSalesDB;

--  Orders Table
CREATE TABLE Orders (
  order_id INT PRIMARY KEY,
  order_date DATE,
  total_amount DECIMAL(12,2)
);

--  Sample Data
INSERT INTO Orders VALUES
 (1, '2025-07-01', 5000.00),
 (2, '2025-07-03', 3000.00),
 (3, '2025-07-05', 10000.00),
 (4, '2025-07-06', 15000.00),
 (5, '2025-07-08', 4000.00),
 (6, '2025-07-09', 2000.00);

--  Flash Sale Summary Table
CREATE TABLE flash_sale_summary (
  period VARCHAR(20),
  total_orders INT,
  total_revenue DECIMAL(12,2),
  avg_order_value DECIMAL(12,2),
  report_date DATETIME DEFAULT CURRENT_TIMESTAMP
);

--  ETL Load
INSERT INTO flash_sale_summary (period, total_orders, total_revenue, avg_order_value)
WITH periods AS (
  SELECT
    CASE
      WHEN order_date < '2025-07-05' THEN 'Before'
      WHEN order_date BETWEEN '2025-07-05' AND '2025-07-07' THEN 'During'
      ELSE 'After'
    END AS sale_period,
    total_amount
  FROM Orders
)
SELECT
  sale_period,
  COUNT(*) AS total_orders,
  SUM(total_amount) AS total_revenue,
  AVG(total_amount) AS avg_order_value
FROM
  periods
GROUP BY
  sale_period;

--  Check
SELECT * FROM flash_sale_summary;
