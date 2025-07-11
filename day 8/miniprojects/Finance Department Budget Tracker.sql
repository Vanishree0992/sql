CREATE DATABASE FinancebudgetDB;
USE FinancebudgetDB;

CREATE TABLE Departments (
  department_id INT PRIMARY KEY,
  department_name VARCHAR(100)
);

CREATE TABLE DepartmentBudgets (
  budget_id INT PRIMARY KEY,
  department_id INT,
  budget_year INT,
  amount DECIMAL(15,2),
  FOREIGN KEY (department_id) REFERENCES Departments(department_id)
);

INSERT INTO Departments VALUES (1, 'HR');
INSERT INTO Departments VALUES (2, 'IT');
INSERT INTO Departments VALUES (3, 'Marketing');
INSERT INTO Departments VALUES (4, 'Operations');

INSERT INTO DepartmentBudgets VALUES (1, 1, 2024, 500000);
INSERT INTO DepartmentBudgets VALUES (2, 2, 2024, 1200000);
INSERT INTO DepartmentBudgets VALUES (3, 3, 2024, 800000);
INSERT INTO DepartmentBudgets VALUES (4, 4, 2024, 1500000);


-- Use a CTE to filter budgets above a threshold
WITH HighSpenders AS (
  SELECT
    d.department_id,
    d.department_name,
    b.amount
  FROM DepartmentBudgets b
  JOIN Departments d ON b.department_id = d.department_id
  WHERE b.amount > 700000
)
SELECT * FROM HighSpenders;


-- Rank departments by spend
WITH HighSpenders AS (
  SELECT
    d.department_id,
    d.department_name,
    b.amount
  FROM DepartmentBudgets b
  JOIN Departments d ON b.department_id = d.department_id
  WHERE b.amount > 700000
)
SELECT
  department_id,
  department_name,
  amount AS total_spend,
  RANK() OVER (ORDER BY amount DESC) AS spend_rank
FROM HighSpenders
ORDER BY spend_rank;


-- Calculate difference from top spender
WITH HighSpenders AS (
  SELECT
    d.department_id,
    d.department_name,
    b.amount
  FROM DepartmentBudgets b
  JOIN Departments d ON b.department_id = d.department_id
  WHERE b.amount > 700000
)
SELECT
  department_id,
  department_name,
  amount AS total_spend,
  RANK() OVER (ORDER BY amount DESC) AS spend_rank,
  MAX(amount) OVER () - amount AS spend_delta
FROM HighSpenders
ORDER BY spend_rank;

-- Save as a view
CREATE VIEW DepartmentBudgetTrackerView AS
WITH HighSpenders AS (
  SELECT
    d.department_id,
    d.department_name,
    b.amount
  FROM DepartmentBudgets b
  JOIN Departments d ON b.department_id = d.department_id
  WHERE b.amount > 700000
)
SELECT
  department_id,
  department_name,
  amount AS total_spend,
  RANK() OVER (ORDER BY amount DESC) AS spend_rank,
  MAX(amount) OVER () - amount AS spend_delta
FROM HighSpenders;
