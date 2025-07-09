USE SQL_24db;
-- 16.	Use EXPLAIN to analyze a full table scan and optimize it with indexing.
CREATE INDEX idx_emp_name ON Employees(emp_name);
EXPLAIN SELECT * FROM Employees WHERE emp_name = 'Emp12345';

-- 17.	Write a SELECT * query and optimize it by specifying only required columns.
SELECT * FROM Employees WHERE dept_id = 1;

-- 18.	Create a table Orders with columns order_id, customer_id, order_date.
CREATE TABLE Orders (
  order_id INT PRIMARY KEY AUTO_INCREMENT,
  customer_id INT,
  order_date DATE
);

INSERT INTO Orders (customer_id, order_date)
SELECT FLOOR(1 + RAND()*20), DATE_SUB(CURDATE(), INTERVAL FLOOR(RAND()*365) DAY)
FROM 
  (SELECT 1 UNION SELECT 2 UNION SELECT 3 UNION SELECT 4 UNION SELECT 5 UNION SELECT 6 
   UNION SELECT 7 UNION SELECT 8 UNION SELECT 9 UNION SELECT 10) t1,
  (SELECT 1 UNION SELECT 2 UNION SELECT 3) t2
LIMIT 50;

-- 19.	Insert 20+ sample orders and analyze a query using EXPLAIN SELECT * FROM Orders.
EXPLAIN SELECT * FROM Orders WHERE order_date >= '2024-01-01';

-- 20.	Create an index on order_date and rerun the EXPLAIN analysis.
CREATE INDEX idx_order_date ON Orders(order_date);
EXPLAIN SELECT * FROM Orders WHERE order_date >= '2024-01-01';

-- 21.	Write a query to retrieve all orders in the last 7 days using WHERE order_date BETWEEN.
SELECT * FROM Orders
WHERE order_date BETWEEN DATE_SUB(CURDATE(), INTERVAL 7 DAY) AND CURDATE();

-- 22.	Replace a subquery with a JOIN and compare performance using EXPLAIN.
SELECT * FROM Employees
WHERE dept_id IN (SELECT dept_id FROM Departments WHERE dept_name = 'HR');

-- 23.	Write a complex SELECT query using 3–4 columns and optimize it by reducing columns.
SELECT e.emp_name, d.dept_name, o.order_date
FROM Employees e
JOIN Departments d ON e.dept_id = d.dept_id
JOIN Orders o ON e.emp_id = o.customer_id;

-- 24.	Create a view using an optimized query with indexed columns.
CREATE VIEW v_employee_orders AS
SELECT e.emp_name, d.dept_name, o.order_date
FROM Employees e
JOIN Departments d ON e.dept_id = d.dept_id
JOIN Orders o ON e.emp_id = o.customer_id;

SELECT * FROM v_employee_orders;

-- 25.	Test query performance difference with/without LIMIT clause.
EXPLAIN SELECT * FROM Employees ORDER BY salary DESC;
-- With LIMIT
EXPLAIN SELECT * FROM Employees ORDER BY salary DESC LIMIT 10;