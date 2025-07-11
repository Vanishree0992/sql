USE hierarchical_data;

-- 36. Create Orders table
CREATE TABLE Orders (
  order_id INT PRIMARY KEY,
  customer_id INT,
  amount DECIMAL(10,2),
  order_date DATE
);

--  37. Insert at least 20 orders across 5 customers
INSERT INTO Orders VALUES (1, 1, 5000, '2024-01-01');
INSERT INTO Orders VALUES (2, 1, 12000, '2024-01-03');
INSERT INTO Orders VALUES (3, 2, 15000, '2024-01-05');
INSERT INTO Orders VALUES (4, 2, 8000, '2024-01-07');
INSERT INTO Orders VALUES (5, 3, 25000, '2024-01-10');
INSERT INTO Orders VALUES (6, 3, 7000, '2024-01-15');
INSERT INTO Orders VALUES (7, 3, 11000, '2024-01-20');
INSERT INTO Orders VALUES (8, 4, 2000, '2024-01-22');
INSERT INTO Orders VALUES (9, 4, 5000, '2024-01-24');
INSERT INTO Orders VALUES (10, 4, 6000, '2024-01-26');
INSERT INTO Orders VALUES (11, 5, 30000, '2024-01-28');
INSERT INTO Orders VALUES (12, 5, 4000, '2024-02-01');
INSERT INTO Orders VALUES (13, 5, 8000, '2024-02-03');
INSERT INTO Orders VALUES (14, 2, 16000, '2024-02-05');
INSERT INTO Orders VALUES (15, 2, 9000, '2024-02-07');
INSERT INTO Orders VALUES (16, 1, 7000, '2024-02-10');
INSERT INTO Orders VALUES (17, 1, 11000, '2024-02-12');
INSERT INTO Orders VALUES (18, 1, 15000, '2024-02-15');
INSERT INTO Orders VALUES (19, 4, 4000, '2024-02-17');
INSERT INTO Orders VALUES (20, 5, 12000, '2024-02-20');

-- 38. CTE: Orders above ₹10,000
WITH HighValueOrders AS (
  SELECT * FROM Orders WHERE amount > 10000
)
SELECT * FROM HighValueOrders;

-- 39. CTE: Total order amount per customer
WITH TotalPerCustomer AS (
  SELECT customer_id, SUM(amount) AS total_amount
  FROM Orders
  GROUP BY customer_id
)
SELECT * FROM TotalPerCustomer;

-- 40. CTE: Customers with more than 3 orders
WITH OrderCounts AS (
  SELECT customer_id, COUNT(*) AS num_orders
  FROM Orders
  GROUP BY customer_id
)
SELECT * FROM OrderCounts WHERE num_orders > 3;

-- 41. Two CTEs: Top spenders & frequent buyers
WITH TopSpenders AS (
  SELECT customer_id, SUM(amount) AS total_spent
  FROM Orders
  GROUP BY customer_id
  HAVING SUM(amount) > 40000
),
FrequentBuyers AS (
  SELECT customer_id, COUNT(*) AS num_orders
  FROM Orders
  GROUP BY customer_id
  HAVING COUNT(*) > 3
)
SELECT * FROM TopSpenders
UNION
SELECT * FROM FrequentBuyers;

-- 42. Recursive CTE: Product category tree (example)
-- Example table
CREATE TABLE Categories (
  category_id INT PRIMARY KEY,
  category_name VARCHAR(50),
  parent_id INT
);

INSERT INTO Categories VALUES (1, 'Electronics', NULL);
INSERT INTO Categories VALUES (2, 'Computers', 1);
INSERT INTO Categories VALUES (3, 'Laptops', 2);
INSERT INTO Categories VALUES (4, 'Desktops', 2);
INSERT INTO Categories VALUES (5, 'Accessories', 1);

WITH RECURSIVE CategoryTree AS (
  SELECT category_id, category_name, parent_id, 1 AS level
  FROM Categories WHERE parent_id IS NULL
  UNION ALL
  SELECT c.category_id, c.category_name, c.parent_id, ct.level + 1
  FROM Categories c
  JOIN CategoryTree ct ON c.parent_id = ct.category_id
)
SELECT * FROM CategoryTree;

-- 43. Recursive CTE: Factorial of 5
WITH RECURSIVE Factorial(n, fact) AS (
  SELECT 1, 1
  UNION ALL
  SELECT n + 1, (n + 1) * fact
  FROM Factorial
  WHERE n < 5
)
SELECT * FROM Factorial;

-- 44. Running total daily sales
WITH DailySales AS (
  SELECT order_date, SUM(amount) AS daily_total
  FROM Orders
  GROUP BY order_date
)
SELECT 
  order_date,
  daily_total,
  SUM(daily_total) OVER (ORDER BY order_date) AS running_total
FROM DailySales;

--  45. Use CTE inside a view
CREATE VIEW CustomerOrderTotals AS
WITH Totals AS (
  SELECT customer_id, SUM(amount) AS total_spent
  FROM Orders
  GROUP BY customer_id
)
SELECT * FROM Totals;

-- 46. Chain multiple CTEs
WITH Filtered AS (
  SELECT * FROM Orders WHERE amount > 5000
),
Grouped AS (
  SELECT customer_id, COUNT(*) AS order_count
  FROM Filtered
  GROUP BY customer_id
)
SELECT * FROM Grouped;

-- 47. Compare nested query vs. CTE
WITH Totals AS (
  SELECT customer_id, SUM(amount) AS total_spent
  FROM Orders
  GROUP BY customer_id
)
SELECT * FROM Totals WHERE total_spent > 30000;

-- 48. Recursive CTE: List all reporting managers
-- Using Employees table from part A
WITH RECURSIVE Managers AS (
  SELECT emp_id, manager_id
  FROM Employees
  WHERE emp_id = 7  -- Example employee
  UNION ALL
  SELECT e.emp_id, e.manager_id
  FROM Employees e
  JOIN Managers m ON e.emp_id = m.manager_id
)
SELECT * FROM Managers;

-- 49  Temporary table for top 5 customers per region (example)
-- Example Regions table
CREATE TABLE Customers (
  customer_id INT PRIMARY KEY,
  region VARCHAR(50)
);

INSERT INTO Customers VALUES (1, 'North');
INSERT INTO Customers VALUES (2, 'North');
INSERT INTO Customers VALUES (3, 'South');
INSERT INTO Customers VALUES (4, 'South');
INSERT INTO Customers VALUES (5, 'East');

WITH CustomerTotals AS (
  SELECT o.customer_id, c.region, SUM(o.amount) AS total_spent,
         RANK() OVER (PARTITION BY c.region ORDER BY SUM(o.amount) DESC) AS rnk
  FROM Orders o
  JOIN Customers c ON o.customer_id = c.customer_id
  GROUP BY o.customer_id, c.region
)
SELECT * FROM CustomerTotals WHERE rnk <= 5;

-- 50. Combine CTE + window function to rank customers
WITH CustomerOrderTotal AS (
  SELECT customer_id, SUM(amount) AS total_spent
  FROM Orders
  GROUP BY customer_id
)
SELECT *,
  RANK() OVER (ORDER BY total_spent DESC) AS spending_rank
FROM CustomerOrderTotal;
