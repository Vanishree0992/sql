-- Indexing in SQL
CREATE DATABASE sql_24DB;
USE sql_24DB;
-- 1.	Create a table Employees with emp_id, emp_name, dept_id, salary.
CREATE TABLE Employees (
    emp_id INT PRIMARY KEY AUTO_INCREMENT,
    emp_name VARCHAR(50),
    dept_id INT,
    salary DECIMAL(10,2)
);
-- 2.	Insert 15 employee records into the Employees table.
INSERT INTO Employees (emp_name, dept_id, salary) VALUES
('John', 1, 60000),
('Alice', 2, 55000),
('Bob', 1, 70000),
('Charlie', 3, 52000),
('David', 2, 48000),
('Eve', 1, 72000),
('Frank', 3, 50000),
('Grace', 2, 58000),
('Heidi', 1, 75000),
('Ivan', 2, 62000),
('Judy', 3, 54000),
('Mallory', 1, 68000),
('Niaj', 2, 66000),
('Olivia', 3, 59000),
('Peggy', 1, 71000);

-- 3.	Create an index on emp_name to speed up name-based searches.
CREATE INDEX idx_emp_name ON Employees(emp_name);

-- 4. Run SELECT query with WHERE emp_name = 'John'
SELECT * FROM Employees WHERE emp_name = 'John';

-- 5. Use EXPLAIN to check index usage
EXPLAIN SELECT * FROM Employees WHERE emp_name = 'John';

-- 6. Create compound index on (dept_id, salary)
CREATE INDEX idx_dept_salary ON Employees(dept_id, salary);

-- Test WHERE query using both
EXPLAIN SELECT * FROM Employees WHERE dept_id = 1 AND salary > 60000;

-- 7. Drop index on emp_name
DROP INDEX idx_emp_name ON Employees;

-- 8. Create Departments table
CREATE TABLE Departments (
    dept_id INT PRIMARY KEY,
    dept_name VARCHAR(50)
);

-- Insert 3 departments
INSERT INTO Departments (dept_id, dept_name) VALUES
(1, 'HR'),
(2, 'Finance'),
(3, 'IT');

-- 9. PRIMARY KEY on dept_id is already clustered index
-- 10. Non-clustered index on dept_name
CREATE INDEX idx_dept_name ON Departments(dept_name);

-- 11. JOIN query using indexed columns
SELECT e.emp_id, e.emp_name, d.dept_name
FROM Employees e
JOIN Departments d ON e.dept_id = d.dept_id;

-- 12. EXPLAIN JOIN performance
EXPLAIN SELECT e.emp_id, e.emp_name, d.dept_name
FROM Employees e
JOIN Departments d ON e.dept_id = d.dept_id;

-- 13. SELECT with ORDER BY emp_name
SELECT * FROM Employees ORDER BY emp_name;

-- 14. Insert 1000+ dummy rows (use a loop in your client or do a bulk insert)
INSERT INTO Employees (emp_name, dept_id, salary)
SELECT 
  CONCAT('Emp', t1.a, t2.b, t3.c, t4.d),
  FLOOR(1 + (RAND()*3)),
  FLOOR(40000 + (RAND()*40000))
FROM 
  (SELECT 0 a UNION ALL SELECT 1 UNION ALL SELECT 2 UNION ALL SELECT 3 UNION ALL SELECT 4 
   UNION ALL SELECT 5 UNION ALL SELECT 6 UNION ALL SELECT 7 UNION ALL SELECT 8 UNION ALL SELECT 9) t1,
  (SELECT 0 b UNION ALL SELECT 1 UNION ALL SELECT 2 UNION ALL SELECT 3 UNION ALL SELECT 4 
   UNION ALL SELECT 5 UNION ALL SELECT 6 UNION ALL SELECT 7 UNION ALL SELECT 8 UNION ALL SELECT 9) t2,
  (SELECT 0 c UNION ALL SELECT 1 UNION ALL SELECT 2 UNION ALL SELECT 3 UNION ALL SELECT 4 
   UNION ALL SELECT 5 UNION ALL SELECT 6 UNION ALL SELECT 7 UNION ALL SELECT 8 UNION ALL SELECT 9) t3,
  (SELECT 0 d UNION ALL SELECT 1 UNION ALL SELECT 2 UNION ALL SELECT 3 UNION ALL SELECT 4 
   UNION ALL SELECT 5 UNION ALL SELECT 6 UNION ALL SELECT 7 UNION ALL SELECT 8 UNION ALL SELECT 9) t4
LIMIT 1000;
SELECT * FROM Employees ORDER BY emp_name;
-- 15.	Identify columns where indexing should be avoided (e.g., high-update frequency or rarely queried).
-- last_login_time
-- is_active
-- comments