CREATE DATABASE customerSalesDB;
USE customerSalesDB;

CREATE TABLE Orders (
  order_id INT PRIMARY KEY,
  customer_id INT,
  order_date DATE,
  amount DECIMAL(12,2)
);

INSERT INTO Orders VALUES (1, 1, '2024-05-01', 5000.00);
INSERT INTO Orders VALUES (2, 1, '2024-06-01', 6000.00);
INSERT INTO Orders VALUES (3, 1, '2024-08-10', 4000.00);

INSERT INTO Orders VALUES (4, 2, '2024-05-15', 3000.00);
INSERT INTO Orders VALUES (5, 2, '2024-05-20', 2500.00);
INSERT INTO Orders VALUES (6, 2, '2024-07-01', 4500.00);

INSERT INTO Orders VALUES (7, 3, '2024-06-10', 2000.00);
INSERT INTO Orders VALUES (8, 3, '2024-06-15', 2200.00);

-- Use LAG(), LEAD(), and DATEDIFF() to compare orders
SELECT
  order_id,
  customer_id,
  order_date,
  amount,
  LAG(order_date) OVER (PARTITION BY customer_id ORDER BY order_date) AS prev_order_date,
  LEAD(order_date) OVER (PARTITION BY customer_id ORDER BY order_date) AS next_order_date,
  DATEDIFF(order_date, LAG(order_date) OVER (PARTITION BY customer_id ORDER BY order_date)) AS gap_from_prev,
  DATEDIFF(LEAD(order_date) OVER (PARTITION BY customer_id ORDER BY order_date), order_date) AS gap_to_next
FROM Orders
ORDER BY customer_id, order_date;

-- Use a CTE to find customers with gaps > 30 days
WITH OrderGaps AS (
  SELECT
    customer_id,
    order_id,
    order_date,
    LAG(order_date) OVER (PARTITION BY customer_id ORDER BY order_date) AS prev_order_date,
    DATEDIFF(order_date, LAG(order_date) OVER (PARTITION BY customer_id ORDER BY order_date)) AS gap_from_prev
  FROM Orders
)
SELECT
  customer_id,
  order_id,
  order_date,
  prev_order_date,
  gap_from_prev
FROM OrderGaps
WHERE gap_from_prev > 30;

-- Save as a view for easy analysis
CREATE VIEW CustomerOrderRecencyView AS
WITH OrderGaps AS (
  SELECT
    customer_id,
    order_id,
    order_date,
    LAG(order_date) OVER (PARTITION BY customer_id ORDER BY order_date) AS prev_order_date,
    DATEDIFF(order_date, LAG(order_date) OVER (PARTITION BY customer_id ORDER BY order_date)) AS gap_from_prev
  FROM Orders
)
SELECT
  customer_id,
  order_id,
  order_date,
  prev_order_date,
  gap_from_prev
FROM OrderGaps
WHERE gap_from_prev > 30;

SELECT * FROM CustomerOrderRecencyView;