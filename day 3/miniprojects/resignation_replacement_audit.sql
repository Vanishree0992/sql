CREATE DATABASE HR_Audit;
USE HR_Audit;

CREATE TABLE departments (
    department_id INT PRIMARY KEY,
    department_name VARCHAR(100)
);

CREATE TABLE employees_resigned (
    emp_id INT PRIMARY KEY,
    full_name VARCHAR(100),
    designation VARCHAR(100),
    department_id INT,
    resignation_date DATE,
    FOREIGN KEY (department_id) REFERENCES departments(department_id)
);

CREATE TABLE employees_hired (
    emp_id INT PRIMARY KEY,
    full_name VARCHAR(100),
    designation VARCHAR(100),
    department_id INT,
    hire_date DATE,
    FOREIGN KEY (department_id) REFERENCES departments(department_id)
);

INSERT INTO departments 
VALUES
(1, 'Finance'),
(2, 'Engineering'),
(3, 'HR');

INSERT INTO employees_resigned 
VALUES
(101, 'Alice', 'Analyst', 1, '2024-12-10'),
(102, 'Bob', 'Engineer', 2, '2024-11-15'),
(103, 'Charlie', 'HR Manager', 3, '2024-12-20'),
(104, 'David', 'Engineer', 2, '2025-01-05');

INSERT INTO employees_hired 
VALUES
(201, 'Eve', 'Analyst', 1, '2025-01-10'),
(202, 'Frank', 'Engineer', 2, '2025-01-20'),
(203, 'Grace', 'Accountant', 1, '2025-02-10');

--	Use EXCEPT to list resigned employees not replaced.
SELECT designation FROM employees_resigned
EXCEPT
SELECT designation FROM employees_hired;

--	Use INTERSECT to identify overlapping designations.
SELECT designation FROM employees_resigned
INTERSECT
SELECT designation FROM employees_hired;

--	Use subqueries to find departments with highest attrition.
SELECT department_id
FROM (
    SELECT department_id, COUNT(*) AS resignations
    FROM employees_resigned
    GROUP BY department_id
) AS dept_resign
WHERE resignations = (
    SELECT MAX(resignation_count)
    FROM (
        SELECT COUNT(*) AS resignation_count
        FROM employees_resigned
        GROUP BY department_id
    ) AS counts
);

--	Use JOIN and GROUP BY for department-level resignation count.

SELECT 
    d.department_name,
    COUNT(r.emp_id) AS total_resignations
FROM employees_resigned r
JOIN departments d ON r.department_id = d.department_id
GROUP BY d.department_name;

