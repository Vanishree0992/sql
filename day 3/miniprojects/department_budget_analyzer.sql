CREATE DATABASE budget_analyzer;
USE budget_analyzer;

CREATE TABLE departments (
    department_id INT PRIMARY KEY,
    department_name VARCHAR(100)
);

CREATE TABLE employees (
    employee_id INT PRIMARY KEY,
    full_name VARCHAR(100),
    salary DECIMAL(10, 2),
    department_id INT,
    FOREIGN KEY (department_id) REFERENCES departments(department_id)
);

INSERT INTO departments 
VALUES
(1, 'Finance'),
(2, 'Engineering'),
(3, 'Sales'),
(4, 'Marketing');

INSERT INTO employees 
VALUES
(101, 'Alice Kumar', 72000, 2),
(102, 'Bhavesh Rao', 58000, 1),
(103, 'Charu Mehta', 63000, 2),
(104, 'Deepa Rani', 49000, 1),
(105, 'Ehsan Ali', 87000, 3),
(106, 'Fatima Khan', 51000, 4),
(107, 'Gaurav Sen', 94000, 2),
(108, 'Heena Joshi', 46000, 3),
(109, 'Ishan Das', 52000, 4);


-- Use subquery in FROM clause to calculate average salary by department.
SELECT 
    dept_avg.department_id,
    d.department_name,
    dept_avg.avg_salary
FROM (
    SELECT 
        department_id,
      ROUND(  AVG(salary)) AS avg_salary
    FROM employees
    GROUP BY department_id
) AS dept_avg
JOIN departments d ON dept_avg.department_id = d.department_id;

-- 	Filter only those departments with average salary > ₹50,000.
SELECT *
FROM (
    SELECT 
        department_id,
       ROUND( AVG(salary)) AS avg_salary
    FROM employees
    GROUP BY department_id
) AS dept_avg
WHERE avg_salary > 50000;

-- 	Show total salary paid by each department.
SELECT 
    d.department_name,
    SUM(e.salary) AS total_salary
FROM employees e
JOIN departments d ON e.department_id = d.department_id
GROUP BY d.department_name;

-- Show which department has the highest total salary using subquery comparison.
WITH dept_totals AS (
    SELECT 
        d.department_name,
        SUM(e.salary) AS total_salary
    FROM employees e
    JOIN departments d ON e.department_id = d.department_id
    GROUP BY d.department_name
)
SELECT *
FROM dept_totals
WHERE total_salary = (SELECT MAX(total_salary) FROM dept_totals);
