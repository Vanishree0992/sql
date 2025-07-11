USE hierarchical_data;

-- 16. Create Salaries table
CREATE TABLE Salaries (
  emp_id INT PRIMARY KEY,
  emp_name VARCHAR(50),
  department VARCHAR(50),
  salary DECIMAL(10,2)
);

-- 17. Insert sample data for 10 employees across 3 departments
INSERT INTO Salaries VALUES (1, 'Alice', 'Sales', 90000);
INSERT INTO Salaries VALUES (2, 'Bob', 'Sales', 75000);
INSERT INTO Salaries VALUES (3, 'Carol', 'Sales', 75000);
INSERT INTO Salaries VALUES (4, 'David', 'IT', 80000);
INSERT INTO Salaries VALUES (5, 'Eve', 'IT', 82000);
INSERT INTO Salaries VALUES (6, 'Frank', 'IT', 80000);
INSERT INTO Salaries VALUES (7, 'Grace', 'HR', 70000);
INSERT INTO Salaries VALUES (8, 'Heidi', 'HR', 68000);
INSERT INTO Salaries VALUES (9, 'Ivan', 'HR', 72000);
INSERT INTO Salaries VALUES (10, 'Judy', 'HR', 70000);

-- 18. Use ROW_NUMBER() to rank employees by salary (descending)
SELECT 
  emp_id,
  emp_name,
  salary,
  ROW_NUMBER() OVER (ORDER BY salary DESC) AS row_num
FROM Salaries;

-- 19. Use RANK() to handle ties
SELECT 
  emp_id,
  emp_name,
  salary,
  RANK() OVER (ORDER BY salary DESC) AS salary_rank
FROM Salaries;

-- 20. Use DENSE_RANK() and compare
SELECT 
  emp_id,
  emp_name,
  salary,
  RANK() OVER (ORDER BY salary DESC) AS rank_order,
  DENSE_RANK() OVER (ORDER BY salary DESC) AS dense_rank_order
FROM Salaries;

--  21. Partition ranking by department
SELECT 
  emp_id,
  emp_name,
  department,
  salary,
  RANK() OVER (PARTITION BY department ORDER BY salary DESC) AS dept_rank
FROM Salaries;

-- 22. Use LAG() to get previous salary
SELECT 
  emp_id,
  emp_name,
  salary,
  LAG(salary) OVER (ORDER BY salary DESC) AS prev_salary
FROM Salaries;

-- 23. Use LEAD() to get next salary
SELECT 
  emp_id,
  emp_name,
  salary,
  LEAD(salary) OVER (ORDER BY salary DESC) AS next_salary
FROM Salaries;

-- 24. Combine ROW_NUMBER() and LAG()
SELECT 
  emp_id,
  emp_name,
  salary,
  ROW_NUMBER() OVER (ORDER BY salary DESC) AS row_num,
  LAG(salary) OVER (ORDER BY salary DESC) AS prev_salary
FROM Salaries;

--  25. Find employees whose salary increased compared to previous
WITH Ranked AS (
  SELECT 
    emp_id,
    emp_name,
    salary,
    LAG(salary) OVER (ORDER BY emp_id) AS prev_salary
  FROM Salaries
)
SELECT *
FROM Ranked
WHERE salary > prev_salary;

--  26. Use NTILE(3) to divide into salary tiers
SELECT 
  emp_id,
  emp_name,
  salary,
  NTILE(3) OVER (ORDER BY salary DESC) AS salary_tier
FROM Salaries;

-- 27. Use FIRST_VALUE() and LAST_VALUE() per department
SELECT 
  emp_id,
  emp_name,
  department,
  salary,
  FIRST_VALUE(salary) OVER (PARTITION BY department ORDER BY salary DESC) AS top_salary,
  LAST_VALUE(salary) OVER (
    PARTITION BY department 
    ORDER BY salary ASC 
    ROWS BETWEEN UNBOUNDED PRECEDING AND UNBOUNDED FOLLOWING
  ) AS lowest_salary
FROM Salaries;

-- 28. Use CUME_DIST() and PERCENT_RANK()
SELECT 
  s1.emp_id,
  s1.emp_name,
  s1.salary,
  (
    SELECT COUNT(*) 
    FROM Salaries s2
    WHERE s2.salary <= s1.salary
  ) / COUNT(*) OVER () AS cumedist
FROM Salaries s1
ORDER BY salary;

-- 29. Moving average salary (window frame)
SELECT 
  emp_id,
  emp_name,
  salary,
  AVG(salary) OVER (ORDER BY salary ROWS BETWEEN 2 PRECEDING AND CURRENT ROW) AS moving_avg_salary
FROM Salaries;

-- 30. Create a view with salary ranking
CREATE VIEW SalaryRankingView AS
SELECT 
  emp_id,
  emp_name,
  department,
  salary,
  RANK() OVER (PARTITION BY department ORDER BY salary DESC) AS dept_rank
FROM Salaries;

-- 31. Salary as % of department total
SELECT 
  emp_id,
  emp_name,
  department,
  salary,
  ROUND(salary * 100.0 / SUM(salary) OVER (PARTITION BY department), 2) AS pct_of_dept
FROM Salaries;

-- 32. Salary difference from highest in department
SELECT 
  emp_id,
  emp_name,
  department,
  salary,
  (MAX(salary) OVER (PARTITION BY department) - salary) AS diff_from_top
FROM Salaries;

--  33. Report showing comparison with peers
SELECT 
  emp_id,
  emp_name,
  department,
  salary,
  AVG(salary) OVER (PARTITION BY department) AS avg_dept_salary,
  salary - AVG(salary) OVER (PARTITION BY department) AS diff_from_avg
FROM Salaries;

-- 34. Identify employees below department average
SELECT *
FROM (
  SELECT 
    emp_id,
    emp_name,
    department,
    salary,
    AVG(salary) OVER (PARTITION BY department) AS avg_dept_salary
  FROM Salaries
) AS t
WHERE salary < avg_dept_salary;

-- 35. Group by department and rank salaries
SELECT 
  emp_id,
  emp_name,
  department,
  salary,
  RANK() OVER (PARTITION BY department ORDER BY salary DESC) AS dept_rank
FROM Salaries;
