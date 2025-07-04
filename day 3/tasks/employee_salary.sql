CREATE DATABASE employee_salaryDB;
USE employee_salaryDB;

CREATE TABLE department (
  dept_id INT PRIMARY KEY,
  dept_name VARCHAR(50)
);

CREATE TABLE employee (
  emp_id INT PRIMARY KEY,
  emp_name VARCHAR(100),
  salary DECIMAL(10,2),
  dept_id INT,
  manager_id INT,
  hire_date DATE,
  birthday DATE,
  FOREIGN KEY (dept_id) REFERENCES department(dept_id),
  FOREIGN KEY (manager_id) REFERENCES employee(emp_id)
);

CREATE TABLE current_employees (
  emp_id INT PRIMARY KEY
);

CREATE TABLE resigned_employees (
  emp_id INT PRIMARY KEY
);

CREATE TABLE full_time_employees (
  emp_id INT PRIMARY KEY,
  name VARCHAR(100),
  salary DECIMAL(10,2)
);

CREATE TABLE contract_employees (
  emp_id INT PRIMARY KEY,
  name VARCHAR(100),
  hourly_rate DECIMAL(10,2)
);

INSERT INTO full_time_employees (emp_id, name, salary) 
VALUES
(1, 'Alice', 90000),
(2, 'Bob', 70000),
(3, 'Charlie', 65000);

INSERT INTO contract_employees (emp_id, name, hourly_rate) 
VALUES
(101, 'David', 400),
(102, 'Eva', 350),
(103, 'Frank', 300);

INSERT INTO department (dept_id, dept_name) 
VALUES
(101, 'IT'),
(102, 'Finance'),
(103, 'HR'),
(104, 'Sales');

INSERT INTO employee (emp_id, emp_name, salary, dept_id, manager_id, hire_date, birthday) 
VALUES
(1, 'Alice', 90000, 101, NULL, '2020-02-15', '1990-07-10'),
(2, 'Bob', 60000, 101, 1, '2021-06-10', '1991-07-15'),
(3, 'Charlie', 75000, 102, 1, '2019-03-01', '1989-03-05'),
(4, 'David', 45000, 102, 3, '2022-11-23', '1992-11-20'),
(5, 'Eva', 30000, 103, NULL, '2024-01-01', '1995-01-20'),
(6, 'Frank', 85000, 104, NULL, '2018-09-12', '1987-09-09'),
(7, 'Grace', 55000, 104, 6, '2023-04-10', '1994-04-11'),
(8, 'Henry', 38000, 103, 5, '2025-06-01', '1996-06-05');

INSERT INTO current_employees (emp_id) 
VALUES
(1), (2), (3), (4), (5), (6), (7), (8);

INSERT INTO resigned_employees (emp_id) 
VALUES
(9), (10);


-- 1.	Retrieve each employee’s name and compare their salary to the highest salary in the company.
SELECT emp_name,
       salary,
       (SELECT MAX(salary) FROM employee) AS max_salary
FROM employee;

-- 2 Show each employee’s salary and total number of employees
SELECT emp_name,
       salary,
       (SELECT COUNT(*) FROM employee) AS total_employees
FROM employee;

-- 3 Employees with their salary and minimum salary in their department
SELECT e.emp_name,
       e.salary,
       (SELECT MIN(salary)
        FROM employee
        WHERE dept_id = e.dept_id) AS dept_min_salary
FROM employee e;

-- 5 For each employee, bonus = 10% of the company’s max salary
SELECT emp_name,
       salary * 0.10 AS bonus_wrt_own_salary,
       (SELECT MAX(salary) FROM employee) * 0.10 AS bonus_10pct_max
FROM employee;

-- 6 Departments where average salary > ₹10,000
SELECT dept_id, avg_sal
FROM (
  SELECT dept_id, AVG(salary) AS avg_sal
  FROM employee
  GROUP BY dept_id
) AS dept_avg
WHERE avg_sal > 10000;

-- 7 Dept avg salaries > company-wide avg
SELECT dept_id, avg_sal
FROM (
  SELECT dept_id, AVG(salary) AS avg_sal
  FROM employee
  GROUP BY dept_id
) AS dept_avg
WHERE avg_sal > (
  SELECT AVG(salary) FROM employee
);

-- 8 Top 3 salaried employees subquery + list names & departments
SELECT e.emp_name, d.dept_name
FROM (
  SELECT emp_id, salary
  FROM employee
  ORDER BY salary DESC
  LIMIT 3
) top3
JOIN employee e USING(emp_id)
JOIN department d USING(dept_id);

-- 9 Total salary by dept for depts with >5 employees
SELECT dept_id, SUM(salary) AS total_sal
FROM employee
GROUP BY dept_id
HAVING COUNT(*) > 5;

-- 10 Temporary table: salary ranges per department
 CREATE TEMPORARY TABLE dept_salary_stats AS
SELECT dept_id,
       MIN(salary) AS min_sal,
       MAX(salary) AS max_sal,
       AVG(salary) AS avg_sal
FROM employee
GROUP BY dept_id;

-- 11 Employees earning more than average salary
SELECT emp_name, salary
FROM employee
WHERE salary > (SELECT AVG(salary) FROM employee);


-- 13 Employees whose department has more than 3 employees
SELECT emp_name, dept_id
FROM employee e
WHERE (SELECT COUNT(*)
       FROM employee
       WHERE dept_id = e.dept_id) > 3;


-- 16 Employees earning more than dept’s average (correlated)
SELECT e.emp_name, e.salary
FROM employee e
WHERE e.salary > (
  SELECT AVG(salary)
  FROM employee
  WHERE dept_id = e.dept_id
);

-- 17 Highest paid employee in each department
SELECT emp_name, dept_id, salary
FROM employee e
WHERE salary = (
  SELECT MAX(salary)
  FROM employee
  WHERE dept_id = e.dept_id
);

-- 18 Departments with at least one employee earning > ₹50,000
SELECT DISTINCT dept_id
FROM employee e
WHERE EXISTS (
  SELECT 1 FROM employee
  WHERE dept_id = e.dept_id
    AND salary > 50000
);

-- 19 Employees earning more than all their team members (correlated)
SELECT e1.emp_name
FROM employee e1
WHERE salary > ALL (
  SELECT e2.salary
  FROM employee e2
  WHERE e2.manager_id = e1.manager_id
    AND e2.emp_id <> e1.emp_id
);

-- 20 Employees earning less than max salary of any department (non‑correlated)
SELECT emp_name, salary
FROM employee
WHERE salary < (
  SELECT MAX(salary) FROM employee
);
 -- 23 Combine employee names from full_time and contract tables
 SELECT name AS emp_name FROM full_time_employees
UNION
SELECT name FROM contract_employees;

-- 26 Employees in both IT (101) and Finance (102)
SELECT emp_id FROM employee WHERE dept_id = 101
INTERSECT
SELECT emp_id FROM employee WHERE dept_id = 102;

-- 27 Employees in IT but not HR
SELECT emp_id FROM employee WHERE dept_id = 101
EXCEPT
SELECT emp_id FROM employee WHERE dept_id = 103;

-- 30 Employee IDs in current but not resigned
SELECT emp_id FROM current_employees
EXCEPT
SELECT emp_id FROM resigned_employees;

-- 31 Total salary per department
SELECT d.dept_name, SUM(e.salary) AS total_salary
FROM employee e
JOIN department d USING(dept_id)
GROUP BY d.dept_name;

-- 32 Number of employees in each department
SELECT d.dept_name, COUNT(e.emp_id) AS emp_count
FROM department d
LEFT JOIN employee e USING(dept_id)
GROUP BY d.dept_name;

-- 33 Dept names and average salaries
SELECT d.dept_name, AVG(e.salary) AS avg_salary
FROM department d
JOIN employee e USING(dept_id)
GROUP BY d.dept_name;

-- 34 Departments with total salary > ₹100,000
SELECT d.dept_name, SUM(e.salary) AS total_salary
FROM department d
JOIN employee e USING(dept_id)
GROUP BY d.dept_name
HAVING SUM(e.salary) > 100000;

-- 35 Number of employees hired per year
SELECT YEAR(hire_date) AS year, COUNT(*) AS hired_count
FROM employee
GROUP BY YEAR(hire_date);
 
 -- 36 Departments with avg salary > company avg
 SELECT d.dept_name, dept_avg.avg_sal
FROM (
  SELECT dept_id, AVG(salary) AS avg_sal
  FROM employee
  GROUP BY dept_id
) dept_avg
JOIN department d USING(dept_id)
WHERE dept_avg.avg_sal > (
  SELECT AVG(salary) FROM employee
);

-- 37 Departments and their highest-paid employee
SELECT d.dept_name, e.emp_name, e.salary
FROM department d
JOIN employee e ON e.dept_id = d.dept_id
WHERE e.salary = (
  SELECT MAX(salary)
  FROM employee
  WHERE dept_id = d.dept_id
);

-- 38 Departments with fewer employees than average department size
SELECT dept_id, emp_count
FROM (
  SELECT dept_id, COUNT(*) AS emp_count
  FROM employee
  GROUP BY dept_id
) dept_counts
WHERE emp_count < (
  SELECT AVG(emp_count)
  FROM (
    SELECT dept_id, COUNT(*) AS emp_count
    FROM employee
    GROUP BY dept_id
  ) all_counts
);

-- 39 All departments & count of employees earning > ₹50,000
SELECT d.dept_name,
       SUM(CASE WHEN e.salary > 50000 THEN 1 ELSE 0 END) AS high_earners
FROM department d
LEFT JOIN employee e USING(dept_id)
GROUP BY d.dept_name;

-- 40 Employees earning more than their department’s avg salary
SELECT e.emp_name, e.salary, d.dept_name
FROM employee e
JOIN department d USING(dept_id)
WHERE e.salary > (
  SELECT AVG(salary)
  FROM employee
  WHERE dept_id = e.dept_id
);

-- 41 Classify employees by salary bands
SELECT emp_name, salary,
  CASE
    WHEN salary >= 80000 THEN 'High'
    WHEN salary >= 40000 THEN 'Medium'
    ELSE 'Low'
  END AS salary_band
FROM employee;

-- 43 Dept‑wise count of employees in each salary category
SELECT dept_id,
  SUM(CASE WHEN salary >= 80000 THEN 1 ELSE 0 END) AS high_count,
  SUM(CASE WHEN salary >= 40000 AND salary < 80000 THEN 1 ELSE 0 END) AS medium_count,
  SUM(CASE WHEN salary < 40000 THEN 1 ELSE 0 END) AS low_count
FROM employee
GROUP BY dept_id;

-- 44 Employees with remarks based on joining year
SELECT emp_name, hire_date,
  CASE
    WHEN YEAR(hire_date) >= YEAR(CURDATE()) - 1 THEN 'New Joiner'
    WHEN YEAR(hire_date) >= YEAR(CURDATE()) - 3 THEN 'Mid‑Level'
    ELSE 'Senior'
  END AS remark
FROM employee;

-- 45 Salary grade per employee using CASE
SELECT emp_name, salary,
  CASE
    WHEN salary >= 80000 THEN 'A'
    WHEN salary >= 50000 THEN 'B'
    ELSE 'C'
  END AS salary_grade
FROM employee;

-- 46 Employees who joined in the last 6 months
SELECT emp_name, hire_date
FROM employee
WHERE hire_date >= DATE_SUB(CURDATE(), INTERVAL 6 MONTH);

-- 47 Employees whose tenure is > 2 years
SELECT emp_name, hire_date,
  TIMESTAMPDIFF(YEAR, hire_date, CURDATE()) AS years_with_company
FROM employee
HAVING years_with_company > 2;

-- 48  Employees' names and months since joining
SELECT emp_name,
  TIMESTAMPDIFF(MONTH, hire_date, CURDATE()) AS months_since_join
FROM employee;

-- 49 Count how many employees joined each year
SELECT YEAR(hire_date) AS year,
       COUNT(*) AS num_joined
FROM employee
GROUP BY YEAR(hire_date);

-- 50 Employees whose birthday is in the current month
SELECT emp_name, birthday
FROM employee
WHERE MONTH(birthday) = MONTH(CURDATE());
