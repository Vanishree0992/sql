CREATE DATABASE itassetDB;
USE itassetDB;

CREATE TABLE departments (
    department_id INT PRIMARY KEY,
    department_name VARCHAR(100)
);

CREATE TABLE employees (
    employee_id INT PRIMARY KEY,
    name VARCHAR(100),
    department_id INT,
    FOREIGN KEY (department_id) REFERENCES departments(department_id)
);

CREATE TABLE assets (
    asset_id INT PRIMARY KEY,
    asset_name VARCHAR(100),
    employee_id INT,
    FOREIGN KEY (employee_id) REFERENCES employees(employee_id)
);


INSERT INTO departments 
VALUES
(1, 'IT'),
(2, 'HR'),
(3, 'Finance'),
(4, 'Marketing');


INSERT INTO employees 
VALUES
(1, 'Alice', 1),
(2, 'Bob', 1),
(3, 'Charlie', 2),
(4, 'Diana', 3);

INSERT INTO assets 
VALUES
(1, 'Laptop', 1),
(2, 'Monitor', 1),
(3, 'Keyboard', 1),
(4, 'Laptop', 2),
(5, 'Phone', 3),
(6, 'Tablet', NULL); 


-- Count assets assigned per department.
SELECT 
    d.department_id,
    d.department_name,
    COUNT(a.asset_id) AS assets_count
FROM departments d
LEFT JOIN employees e ON d.department_id = e.department_id
LEFT JOIN assets a ON e.employee_id = a.employee_id
GROUP BY d.department_id, d.department_name;

-- List employees with more than 2 assets.
SELECT 
    e.employee_id,
    e.name,
    COUNT(a.asset_id) AS asset_count
FROM employees e
JOIN assets a ON e.employee_id = a.employee_id
GROUP BY e.employee_id, e.name
HAVING COUNT(a.asset_id) > 2;

-- Show departments with no assigned assets.
SELECT 
    d.department_id,
    d.department_name
FROM departments d
LEFT JOIN employees e ON d.department_id = e.department_id
LEFT JOIN assets a ON e.employee_id = a.employee_id
WHERE a.asset_id IS NULL
GROUP BY d.department_id, d.department_name;

