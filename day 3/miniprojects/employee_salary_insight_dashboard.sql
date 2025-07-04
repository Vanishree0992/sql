CREATE DATABASE HR_Insights;
USE HR_Insights;

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
(1, 'Human Resources'),
(2, 'Engineering'),
(3, 'Finance'),
(4, 'Sales');

INSERT INTO employees 
VALUES
(101, 'Alice Johnson', 70000, 2),
(102, 'Bob Smith', 50000, 1),
(103, 'Charlie Lee', 60000, 2),
(104, 'Diana King', 45000, 1),
(105, 'Edward Davis', 85000, 3),
(106, 'Fiona Hall', 55000, 4),
(107, 'George Clark', 90000, 2);

--	Show each employee’s salary alongside company-wide max, avg, and min salary (subqueries in SELECT).
    SELECT 
    employee_id,
    full_name,
    salary,

    (SELECT MAX(salary) FROM employees) AS company_max_salary,
    (SELECT MIN(salary) FROM employees) AS company_min_salary,
    (SELECT AVG(salary) FROM employees) AS company_avg_salary

FROM employees;
    
-- 	Classify salary as High, Medium, or Low using CASE WHEN.
SELECT 
    employee_id,
    full_name,
    salary,

    (SELECT MAX(salary) FROM employees) AS company_max_salary,
    (SELECT MIN(salary) FROM employees) AS company_min_salary,
    (SELECT AVG(salary) FROM employees) AS company_avg_salary,

    CASE
        WHEN salary >= (SELECT MAX(salary) FROM employees) * 0.85 THEN 'High'
        WHEN salary <= (SELECT MIN(salary) FROM employees) * 1.15 THEN 'Low'
        ELSE 'Medium'
    END AS salary_classification

FROM employees;

--	Use correlated subquery to compare salary to department average.
SELECT 
    e.employee_id,
    e.full_name,
    e.salary,
    e.department_id,

    (SELECT AVG(salary) 
     FROM employees e2 
     WHERE e2.department_id = e.department_id) AS dept_avg_salary,

    CASE
        WHEN e.salary > (SELECT AVG(salary) 
                         FROM employees e2 
                         WHERE e2.department_id = e.department_id) THEN 'Above Dept Avg'
        WHEN e.salary < (SELECT AVG(salary) 
                         FROM employees e2 
                         WHERE e2.department_id = e.department_id) THEN 'Below Dept Avg'
        ELSE 'Equal to Dept Avg'
    END AS salary_vs_dept_avg

FROM employees e;

--	Display department-wise salary summary with JOIN and GROUP BY.
SELECT 
    d.department_id,
    d.department_name,
    COUNT(e.employee_id) AS total_employees,
    MIN(e.salary) AS min_salary,
    MAX(e.salary) AS max_salary,
    AVG(e.salary) AS avg_salary
FROM departments d
JOIN employees e ON d.department_id = e.department_id
GROUP BY d.department_id, d.department_name;
