CREATE DATABASE rankingDB;
USE rankingDB;

CREATE TABLE Employees (
  emp_id INT PRIMARY KEY,
  emp_name VARCHAR(100),
  department VARCHAR(50),
  salary DECIMAL(12,2)
);

INSERT INTO Employees VALUES (1, 'Alice', 'HR', 50000.00);
INSERT INTO Employees VALUES (2, 'Bob', 'HR', 52000.00);
INSERT INTO Employees VALUES (3, 'Charlie', 'HR', 52000.00);
INSERT INTO Employees VALUES (4, 'Dan', 'IT', 60000.00);
INSERT INTO Employees VALUES (5, 'Eve', 'IT', 58000.00);
INSERT INTO Employees VALUES (6, 'Frank', 'IT', 60000.00);


-- Use window functions for ranking
SELECT
  emp_id,
  emp_name,
  department,
  salary,
  ROW_NUMBER() OVER (PARTITION BY department ORDER BY salary DESC) AS row_number_rank,
  RANK() OVER (PARTITION BY department ORDER BY salary DESC) AS ranking,
  DENSE_RANK() OVER (PARTITION BY department ORDER BY salary DESC) AS dense_ranking
FROM Employees
ORDER BY department, salary DESC;

-- Add LAG() and LEAD() for previous & next salaries
SELECT
  emp_id,
  emp_name,
  department,
  salary,
  ROW_NUMBER() OVER (PARTITION BY department ORDER BY salary DESC) AS row_number_rank,
  RANK() OVER (PARTITION BY department ORDER BY salary DESC) AS ranking,
  DENSE_RANK() OVER (PARTITION BY department ORDER BY salary DESC) AS dense_ranking,
  LAG(salary) OVER (PARTITION BY department ORDER BY salary DESC) AS prev_salary,
  LEAD(salary) OVER (PARTITION BY department ORDER BY salary DESC) AS next_salary
FROM Employees
ORDER BY department, salary DESC;


--  Build full dashboard with salary movement insights
SELECT
  emp_id,
  emp_name,
  department,
  salary,

  -- These are window functions: they must go here in SELECT
  ROW_NUMBER() OVER (PARTITION BY department ORDER BY salary DESC) AS row_number_rank,
  RANK() OVER (PARTITION BY department ORDER BY salary DESC) AS rank_position,
  DENSE_RANK() OVER (PARTITION BY department ORDER BY salary DESC) AS dense_rank_position,

  LAG(salary) OVER (PARTITION BY department ORDER BY salary DESC) AS prev_salary,
  LEAD(salary) OVER (PARTITION BY department ORDER BY salary DESC) AS next_salary,

  salary - LAG(salary) OVER (PARTITION BY department ORDER BY salary DESC) AS diff_from_prev

FROM Employees
ORDER BY department, salary DESC;



WITH RankedSalaries AS (
  SELECT
    emp_id,
    emp_name,
    department,
    salary,
    RANK() OVER (PARTITION BY department ORDER BY salary DESC) AS rank_position
  FROM Employees
)
SELECT *
FROM RankedSalaries
WHERE rank_position <= 3; -- e.g., Top 3 per department


-- Save as a dashboard view

CREATE VIEW SalaryRankingDashboard AS
SELECT
  emp_id,
  emp_name,
  department,
  salary,
  ROW_NUMBER() OVER (PARTITION BY department ORDER BY salary DESC) AS row_number_rank,
  RANK() OVER (PARTITION BY department ORDER BY salary DESC) AS rank_position,
  DENSE_RANK() OVER (PARTITION BY department ORDER BY salary DESC) AS dense_rank_position,
  LAG(salary) OVER (PARTITION BY department ORDER BY salary DESC) AS prev_salary,
  LEAD(salary) OVER (PARTITION BY department ORDER BY salary DESC) AS next_salary,
  salary - LAG(salary) OVER (PARTITION BY department ORDER BY salary DESC) AS diff_from_prev
FROM Employees;

SELECT * FROM SalaryRankingDashboard ORDER BY department, salary DESC;

SELECT * FROM SalaryRankingDashboard;

