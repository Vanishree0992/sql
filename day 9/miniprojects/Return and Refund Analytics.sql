CREATE DATABASE  ReturnAnalyticsDB;
USE ReturnAnalyticsDB;

CREATE TABLE Orders (
  order_id INT PRIMARY KEY,
  product_id INT,
  category VARCHAR(50),
  order_date DATE,
  total_amount DECIMAL(12,2)
);

CREATE TABLE Returns (
  return_id INT PRIMARY KEY,
  order_id INT,
  return_date DATE,
  refund_amount DECIMAL(12,2),
  FOREIGN KEY (order_id) REFERENCES Orders(order_id)
);

CREATE TABLE return_refund_summary (
  product_id INT,
  category VARCHAR(50),
  total_returns INT,
  total_refund_amount DECIMAL(12,2),
  total_orders INT,
  return_rate_pct DECIMAL(5,2),
  created_at DATETIME DEFAULT CURRENT_TIMESTAMP
);

-- 3) Sample Data
INSERT INTO Orders VALUES
 (1, 1, 'Apparel', '2025-07-01', 3000.00),
 (2, 2, 'Electronics', '2025-07-02', 10000.00),
 (3, 1, 'Apparel', '2025-07-03', 4000.00),
 (4, 3, 'Shoes', '2025-07-04', 2000.00),
 (5, 2, 'Electronics', '2025-07-05', 12000.00);

INSERT INTO Returns VALUES
 (1, 1, '2025-07-06', 3000.00),
 (2, 2, '2025-07-07', 10000.00),
 (3, 5, '2025-07-08', 12000.00);

-- Analyze Return Rates & Refund Impact
SELECT
  o.product_id,
  o.category,
  COUNT(r.return_id) AS total_returns,
  SUM(r.refund_amount) AS total_refund_amount,
  COUNT(DISTINCT o.order_id) AS total_orders,
  ROUND(COUNT(r.return_id) / COUNT(DISTINCT o.order_id) * 100, 2) AS return_rate_pct
FROM
  Orders o
  LEFT JOIN Returns r ON o.order_id = r.order_id
GROUP BY
  o.product_id, o.category;


SELECT *
FROM (
  SELECT
    o.product_id,
    o.category,
    COUNT(r.return_id) AS total_returns,
    SUM(r.refund_amount) AS total_refund_amount,
    COUNT(DISTINCT o.order_id) AS total_orders,
    ROUND(COUNT(r.return_id) / COUNT(DISTINCT o.order_id) * 100, 2) AS return_rate_pct
  FROM
    Orders o
    LEFT JOIN Returns r ON o.order_id = r.order_id
  GROUP BY
    o.product_id, o.category
) AS sub
WHERE
  return_rate_pct > 50 OR total_refund_amount > 10000;

--  Load Summary
INSERT INTO return_refund_summary (product_id, category, total_returns, total_refund_amount, total_orders, return_rate_pct)
SELECT
  o.product_id,
  o.category,
  COUNT(r.return_id) AS total_returns,
  SUM(r.refund_amount) AS total_refund_amount,
  COUNT(DISTINCT o.order_id) AS total_orders,
  ROUND(COUNT(r.return_id) / COUNT(DISTINCT o.order_id) * 100, 2) AS return_rate_pct
FROM
  Orders o
  LEFT JOIN Returns r ON o.order_id = r.order_id
GROUP BY
  o.product_id, o.category;

-- Check
SELECT * FROM return_refund_summary;
