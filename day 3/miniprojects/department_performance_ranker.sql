CREATE DATABASE Management_Performance;
USE Management_Performance;

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
(4, 'HR');

INSERT INTO employees 
VALUES
(101, 'Alice', 90000, 2),
(102, 'Bob', 60000, 1),
(103, 'Charlie', 95000, 2),
(104, 'David', 70000, 3),
(105, 'Eve', 85000, 1),
(106, 'Frank', 40000, 3),
(107, 'Grace', 100000, 2),
(108, 'Hannah', 30000, 4);

--	Use subqueries to calculate total, average salary per department.
SELECT 
    department_id,
    SUM(salary) AS total_salary,
    ROUND(AVG(salary)) AS avg_salary
FROM employees
GROUP BY department_id;

--	Use JOIN to get department names.
SELECT 
    d.department_name,
    e_stats.total_salary,
    e_stats.avg_salary
FROM (
    SELECT 
        department_id,
        SUM(salary) AS total_salary,
        ROUND(AVG(salary)) AS avg_salary
    FROM employees
    GROUP BY department_id
) AS e_stats
JOIN departments d ON d.department_id = e_stats.department_id;

--	Use CASE WHEN to assign performance tags.
SELECT 
    d.department_name,
    e_stats.total_salary,
    e_stats.avg_salary,
    CASE
        WHEN e_stats.total_salary > 250000 THEN 'Excellent'
        WHEN e_stats.total_salary BETWEEN 150000 AND 250000 THEN 'Good'
        ELSE 'Average'
    END AS performance_tag
FROM (
    SELECT 
        department_id,
        SUM(salary) AS total_salary,
       ROUND( AVG(salary)) AS avg_salary
    FROM employees
    GROUP BY department_id
) AS e_stats
JOIN departments d ON d.department_id = e_stats.department_id;

--	Filter departments above average salary expense.
SELECT 
    d.department_name,
    e_stats.total_salary,
    e_stats.avg_salary
FROM (
    SELECT 
        department_id,
        SUM(salary) AS total_salary,
        ROUND(AVG(salary)) AS avg_salary
    FROM employees
    GROUP BY department_id
) AS e_stats
JOIN departments d ON d.department_id = e_stats.department_id
WHERE e_stats.total_salary > (
    SELECT AVG(dept_total)
    FROM (
        SELECT SUM(salary) AS dept_total
        FROM employees
        GROUP BY department_id
    ) AS dept_sums
);
