CREATE DATABASE HR;
USE HR;

CREATE TABLE Employees (
  emp_id INT PRIMARY KEY,
  emp_name VARCHAR(100),
  department VARCHAR(50)
);

CREATE TABLE EmployeeSalaries (
  salary_id INT PRIMARY KEY,
  emp_id INT,
  salary DECIMAL(12,2),
  effective_date DATE,
  FOREIGN KEY (emp_id) REFERENCES Employees(emp_id)
);

-- Employees
INSERT INTO Employees VALUES (1, 'Alice', 'HR');
INSERT INTO Employees VALUES (2, 'Bob', 'IT');
INSERT INTO Employees VALUES (3, 'Charlie', 'Finance');

-- Salary records over time
INSERT INTO EmployeeSalaries VALUES (1, 1, 50000.00, '2023-01-01');
INSERT INTO EmployeeSalaries VALUES (2, 1, 55000.00, '2024-06-01'); 

INSERT INTO EmployeeSalaries VALUES (3, 2, 60000.00, '2023-01-01');
INSERT INTO EmployeeSalaries VALUES (4, 2, 60000.00, '2024-06-01'); 

INSERT INTO EmployeeSalaries VALUES (5, 3, 45000.00, '2023-01-01');
INSERT INTO EmployeeSalaries VALUES (6, 3, 50000.00, '2024-02-01'); 

-- Use LAG() to compare current vs previous salary
SELECT
  es.emp_id,
  e.emp_name,
  es.effective_date,
  es.salary,
  LAG(es.salary) OVER (PARTITION BY es.emp_id ORDER BY es.effective_date) AS prev_salary,
  CASE
    WHEN LAG(es.salary) OVER (PARTITION BY es.emp_id ORDER BY es.effective_date) IS NULL THEN 'No History'
    WHEN es.salary > LAG(es.salary) OVER (PARTITION BY es.emp_id ORDER BY es.effective_date) THEN 'Raised'
    WHEN es.salary = LAG(es.salary) OVER (PARTITION BY es.emp_id ORDER BY es.effective_date) THEN 'No Change'
    ELSE 'Decreased'
  END AS salary_trend
FROM EmployeeSalaries es
JOIN Employees e ON es.emp_id = e.emp_id
ORDER BY es.emp_id, es.effective_date;

-- Use CTE to filter only current year promotions/raises
WITH SalaryChanges AS (
  SELECT
    es.emp_id,
    e.emp_name,
    es.effective_date,
    es.salary,
    LAG(es.salary) OVER (PARTITION BY es.emp_id ORDER BY es.effective_date) AS prev_salary
  FROM EmployeeSalaries es
  JOIN Employees e ON es.emp_id = e.emp_id
)
SELECT
  emp_id,
  emp_name,
  effective_date,
  salary,
  prev_salary,
  salary - prev_salary AS salary_difference,
  CASE
    WHEN prev_salary IS NULL THEN 'New Record'
    WHEN salary > prev_salary THEN 'Raised'
    WHEN salary = prev_salary THEN 'No Change'
    ELSE 'Decreased'
  END AS salary_trend
FROM SalaryChanges
WHERE YEAR(effective_date) = YEAR(CURDATE()) AND salary > prev_salary;

