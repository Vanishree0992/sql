CREATE DATABASE HR_Performance;
USE HR_Performance;

CREATE TABLE departments (
    department_id INT PRIMARY KEY,
    department_name VARCHAR(100)
);

CREATE TABLE employees (
    employee_id INT PRIMARY KEY,
    full_name VARCHAR(100),
    salary DECIMAL(10,2),
    department_id INT,
    FOREIGN KEY (department_id) REFERENCES departments(department_id)
);

INSERT INTO departments VALUES
(1, 'Finance'),
(2, 'Engineering'),
(3, 'Sales');

INSERT INTO employees VALUES
(101, 'Alice', 90000, 2),
(102, 'Bob', 60000, 1),
(103, 'Charlie', 95000, 2),
(104, 'David', 70000, 3),
(105, 'Eve', 85000, 1),
(106, 'Frank', 40000, 3),
(107, 'Grace', 100000, 2);

-- Use a correlated subquery to get employees with salary > dept average.
SELECT 
    e.employee_id, e.full_name, e.salary, e.department_id
FROM employees e
WHERE e.salary > (
    SELECT AVG(salary) 
    FROM employees 
    WHERE department_id = e.department_id
);

-- Highlight top 5 earners using subquery with ORDER BY LIMIT.
SELECT * FROM employees
ORDER BY salary DESC
LIMIT 5;

-- Show department-level performance summary using JOIN + GROUP BY.
SELECT 
    d.department_name,
    COUNT(e.employee_id) AS num_employees,
    AVG(e.salary) AS avg_salary,
    MAX(e.salary) AS max_salary,
    MIN(e.salary) AS min_salary
FROM departments d
LEFT JOIN employees e ON d.department_id = e.department_id
GROUP BY d.department_name;

-- Use CASE WHEN to classify employee performance level.
SELECT 
    e.employee_id,
    e.full_name,
    e.salary,
    d.department_name,
    (SELECT AVG(salary) FROM employees WHERE department_id = e.department_id) AS dept_avg_salary,
    CASE
        WHEN e.salary >= 1.2 * (SELECT AVG(salary) FROM employees WHERE department_id = e.department_id) THEN 'High'
        WHEN e.salary >= (SELECT AVG(salary) FROM employees WHERE department_id = e.department_id) THEN 'Medium'
        ELSE 'Low'
    END AS performance_level
FROM employees e
JOIN departments d ON e.department_id = d.department_id;
