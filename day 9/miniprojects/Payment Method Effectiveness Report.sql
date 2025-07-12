CREATE DATABASE PaymentDB;
USE PaymentDB;

--  Table
CREATE TABLE Orders (
  order_id INT PRIMARY KEY,
  customer_id INT,
  payment_method VARCHAR(50),
  order_date DATE,
  total_amount DECIMAL(12,2)
);

--  Sample Data
INSERT INTO Orders VALUES
 (1, 1, 'Credit Card', '2025-07-01', 5000.00),
 (2, 2, 'UPI', '2025-07-02', 2500.00),
 (3, 3, 'Cash', '2025-07-02', 1500.00),
 (4, 4, 'Credit Card', '2025-07-03', 8000.00),
 (5, 5, 'UPI', '2025-07-03', 3000.00),
 (6, 6, 'Wallet', '2025-07-04', 2000.00),
 (7, 7, 'Cash', '2025-07-04', 1000.00);

--  Report
SELECT
  payment_method,
  COUNT(*) AS total_orders,
  SUM(total_amount) AS total_sales,
  AVG(total_amount) AS avg_order_value
FROM
  Orders
GROUP BY
  payment_method;
