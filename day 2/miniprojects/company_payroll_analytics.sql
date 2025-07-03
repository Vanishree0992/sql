CREATE DATABASE companypayrollDB;
USE companypayrollDB;


CREATE TABLE departments (
    department_id INT PRIMARY KEY,
    department_name VARCHAR(100) NOT NULL
);


CREATE TABLE employees (
    employee_id INT PRIMARY KEY,
    name VARCHAR(100) NOT NULL,
    department_id INT,
    FOREIGN KEY (department_id) REFERENCES departments(department_id)
);


CREATE TABLE salaries (
    salary_id INT PRIMARY KEY AUTO_INCREMENT,
    employee_id INT,
    amount DECIMAL(10, 2),
    date_paid DATE,
    FOREIGN KEY (employee_id) REFERENCES employees(employee_id)
);

INSERT INTO departments (department_id, department_name) VALUES
(1, 'HR'), (2, 'IT'), (3, 'Marketing');

INSERT INTO employees (employee_id, name, department_id) VALUES
(101, 'Alice', 1),
(102, 'Bob', 2),
(103, 'Charlie', 2),
(104, 'Diana', 3),
(105, 'Eve', 1);

INSERT INTO salaries (employee_id, amount, date_paid) VALUES
(101, 60000, '2025-01-01'),
(102, 80000, '2025-01-01'),
(103, 75000, '2025-01-01'),
(104, 50000, '2025-01-01'),
(105, 65000, '2025-01-01');

-- - Calculate total, average, min, and max salaries by department.
SELECT 
    d.department_name,
    SUM(s.amount) AS total_salary,
    AVG(s.amount) AS avg_salary,
    MIN(s.amount) AS min_salary,
    MAX(s.amount) AS max_salary
FROM salaries s
JOIN employees e ON s.employee_id = e.employee_id
JOIN departments d ON e.department_id = d.department_id
GROUP BY d.department_name;

-- List Departments with Total Salary Above a Threshold (e.g., > 120000)
SELECT 
    d.department_name,
    SUM(s.amount) AS total_salary
FROM salaries s
JOIN employees e ON s.employee_id = e.employee_id
JOIN departments d ON e.department_id = d.department_id
GROUP BY d.department_name
HAVING SUM(s.amount) > 120000;

-- Identify Top 3 Highest Paid Employees
SELECT 
    e.name AS employee_name,
    d.department_name,
    s.amount AS salary
FROM salaries s
JOIN employees e ON s.employee_id = e.employee_id
JOIN departments d ON e.department_id = d.department_id
ORDER BY s.amount DESC
LIMIT 3;
