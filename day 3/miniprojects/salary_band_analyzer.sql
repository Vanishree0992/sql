CREATE DATABASE HR_SalaryBands;
USE HR_SalaryBands;

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

INSERT INTO departments VALUES
(1, 'Finance'),
(2, 'Engineering'),
(3, 'Marketing');

INSERT INTO employees VALUES
(101, 'Alice', 85000, 1),
(102, 'Bob', 60000, 1),
(103, 'Charlie', 95000, 2),
(104, 'David', 75000, 3),
(105, 'Eve', 90000, 1),
(106, 'Frank', 98000, 2),
(107, 'Grace', 55000, 3),
(108, 'Hannah', 89000, 2),
(109, 'Ian', 62000, 3),
(110, 'Jack', 88000, 2),
(111, 'Kara', 87000, 2),
(112, 'Leo', 89000, 2);


--	Use subqueries to get company and department averages.

SELECT AVG(salary) AS company_avg FROM employees;
SELECT department_id, AVG(salary) AS dept_avg
FROM employees
GROUP BY department_id;

--	Use CASE to tag salaries as Band A, B, C.
SELECT 
    e.employee_id,
    e.full_name,
    e.salary,
    d.department_name,
    CASE
        WHEN e.salary > (
            SELECT AVG(salary)
            FROM employees AS e2
            WHERE e2.department_id = e.department_id
        ) THEN 'Band A'
        WHEN e.salary = (
            SELECT AVG(salary)
            FROM employees AS e2
            WHERE e2.department_id = e.department_id
        ) THEN 'Band B'
        ELSE 'Band C'
    END AS salary_band
FROM employees e
JOIN departments d ON e.department_id = d.department_id;

--	Use GROUP BY to count employees per band per department.

SELECT 
    department_name,
    salary_band,
    COUNT(*) AS num_employees
FROM (
    SELECT 
        e.employee_id,
        e.full_name,
        e.salary,
        d.department_name,
        CASE
            WHEN e.salary > (
                SELECT AVG(salary)
                FROM employees AS e2
                WHERE e2.department_id = e.department_id
            ) THEN 'Band A'
            WHEN e.salary = (
                SELECT AVG(salary)
                FROM employees AS e2
                WHERE e2.department_id = e.department_id
            ) THEN 'Band B'
            ELSE 'Band C'
        END AS salary_band
    FROM employees e
    JOIN departments d ON e.department_id = d.department_id
) AS banded_employees
GROUP BY department_name, salary_band;


--	Include only those departments where band A employees > 3.
SELECT 
    department_name,
    salary_band,
    COUNT(*) AS num_employees
FROM (
    SELECT 
        e.employee_id,
        e.full_name,
        e.salary,
        d.department_name,
        CASE
            WHEN e.salary > (
                SELECT AVG(salary)
                FROM employees AS e2
                WHERE e2.department_id = e.department_id
            ) THEN 'Band A'
            WHEN e.salary = (
                SELECT AVG(salary)
                FROM employees AS e2
                WHERE e2.department_id = e.department_id
            ) THEN 'Band B'
            ELSE 'Band C'
        END AS salary_band
    FROM employees e
    JOIN departments d ON e.department_id = d.department_id
) AS banded_employees
GROUP BY department_name, salary_band
HAVING salary_band = 'Band A' AND COUNT(*) > 3;
