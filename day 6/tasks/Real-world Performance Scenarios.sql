USE sql_24DB;
-- 46.	Run a JOIN between Customers and Orders without index — measure execution time.
SELECT * FROM Customers LIMIT 5;
SELECT * FROM Orders LIMIT 5;

-- Remove index on Orders.customer_id if exists
ALTER TABLE Orders DROP FOREIGN KEY Orders_ibfk_1;
ALTER TABLE Orders DROP INDEX customer_id;

EXPLAIN SELECT o.order_id, c.customer_name
FROM Orders o
JOIN Customers c ON o.customer_id = c.customer_id;
-- 47.	Add indexes on customer_id in both tables and rerun JOIN — measure again.
ALTER TABLE Orders ADD INDEX idx_orders_customer_id (customer_id);
ALTER TABLE Customers ADD INDEX idx_customers_id (customer_id);

EXPLAIN SELECT o.order_id, c.customer_name
FROM Orders o
JOIN Customers c ON o.customer_id = c.customer_id;
-- 48.	Write a query using a subquery in WHERE clause and compare it to an equivalent JOIN.
EXPLAIN SELECT *
FROM Orders
WHERE customer_id IN (
  SELECT customer_id FROM Customers WHERE customer_name = 'Alice'
);

-- 49.	Analyze performance of a filtered GROUP BY query with and without an index on the grouping column.
ALTER TABLE Employees DROP INDEX idx_dept_salary;

EXPLAIN SELECT dept_id, COUNT(*) 
FROM Employees 
GROUP BY dept_id;

-- 50.	Combine multiple techniques (LIMIT, SELECT columns, WHERE filter, indexed JOIN) into a highly optimized report query.
EXPLAIN SELECT o.order_id, c.customer_name, o.order_date
FROM Orders o
JOIN Customers c ON o.customer_id = c.customer_id
WHERE o.order_date >= CURDATE() - INTERVAL 30 DAY
ORDER BY o.order_date DESC
LIMIT 10;