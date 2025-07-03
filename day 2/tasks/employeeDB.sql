CREATE DATABASE employeeDB;
USE employeeDB;

CREATE TABLE departments (
    department_id INT PRIMARY KEY,
    department_name VARCHAR(100)
);

CREATE TABLE employees (
    employee_id INT PRIMARY KEY,
    name VARCHAR(100),
    department_id INT,
    salary DECIMAL(10,2),
    hire_date DATE,
    manager_id INT,
    FOREIGN KEY (department_id) REFERENCES departments(department_id),
    FOREIGN KEY (manager_id) REFERENCES employees(employee_id)
);

CREATE TABLE salaries (
    employee_id INT,
    amount DECIMAL(10,2),
    date_paid DATE,
    FOREIGN KEY (employee_id) REFERENCES employees(employee_id)
);

INSERT INTO departments (department_id, department_name) 
VALUES
(1, 'HR'), (2, 'IT'), (3, 'Marketing'), (4, 'Finance');

INSERT INTO employees (employee_id, name, department_id, salary, hire_date, manager_id) 
VALUES
(101, 'Alice', 1, 60000, '2021-01-15', NULL),
(102, 'Bob', 2, 70000, '2020-03-22', 101),
(103, 'Charlie', 2, 50000, '2019-07-01', 101),
(104, 'David', 3, 45000, '2022-08-12', 102),
(105, 'Eve', 3, 55000, '2020-11-23', 103),
(106, 'Frank', NULL, 40000, '2023-04-05', 101);

INSERT INTO salaries (employee_id, amount, date_paid) 
VALUES
(101, 60000, '2024-01-01'),
(102, 70000, '2024-01-01'),
(103, 50000, '2024-01-01'),
(104, 45000, '2024-01-01'),
(105, 55000, '2024-01-01');

-- AGGREGATE FUNCTIONS
-- 1. Total number of employees
SELECT COUNT(*) AS total_employees FROM employees;

-- 2. Employees in the "IT" department
SELECT COUNT(*) AS it_employees
FROM employees e
JOIN departments d ON e.department_id = d.department_id
WHERE d.department_name = 'IT';

-- 3. Sum of all employees’ salaries
SELECT SUM(salary) AS total_salaries FROM employees;

-- 4. Sum of salaries for "HR" department
SELECT SUM(e.salary) AS hr_salaries
FROM employees e
JOIN departments d ON e.department_id = d.department_id
WHERE d.department_name = 'HR';

-- 5. Average salary of all employees
SELECT AVG(salary) AS avg_salary FROM employees;

-- 6. Average salary in "Marketing" department
SELECT AVG(e.salary) AS avg_marketing_salary
FROM employees e
JOIN departments d ON e.department_id = d.department_id
WHERE d.department_name = 'Marketing';

-- 7. Minimum salary
SELECT MIN(salary) AS min_salary FROM employees;

-- 8. Maximum salary
SELECT MAX(salary) AS max_salary FROM employees;

-- 9. Earliest hire date
SELECT MIN(hire_date) AS earliest_hire FROM employees;

-- 10. Latest hire date
SELECT MAX(hire_date) AS latest_hire FROM employees;

-- GROUPBY
-- 11. Total salary paid for each department
SELECT d.department_name, SUM(e.salary) AS total_salary
FROM employees e
JOIN departments d ON e.department_id = d.department_id
GROUP BY d.department_name;

-- 12. Average salary for each department
SELECT d.department_name, AVG(e.salary) AS avg_salary
FROM employees e
JOIN departments d ON e.department_id = d.department_id
GROUP BY d.department_name;

-- 13. Number of employees in each department
SELECT d.department_name, COUNT(*) AS employee_count
FROM employees e
JOIN departments d ON e.department_id = d.department_id
GROUP BY d.department_name;

-- 14. Departments with more than 2 employees
SELECT d.department_name, COUNT(*) AS employee_count
FROM employees e
JOIN departments d ON e.department_id = d.department_id
GROUP BY d.department_name
HAVING COUNT(*) > 2;

-- 15. Minimum salary for each department
SELECT d.department_name, MIN(e.salary) AS min_salary
FROM employees e
JOIN departments d ON e.department_id = d.department_id
GROUP BY d.department_name;

-- 16. Maximum salary for each department
SELECT d.department_name, MAX(e.salary) AS max_salary
FROM employees e
JOIN departments d ON e.department_id = d.department_id
GROUP BY d.department_name;

-- 17. Number of employees hired each year
SELECT YEAR(hire_date) AS hire_year, COUNT(*) AS employee_count
FROM employees
GROUP BY YEAR(hire_date);

-- 18. Total salary for departments where the total salary exceeds 100,000
SELECT d.department_name, SUM(e.salary) AS total_salary
FROM employees e
JOIN departments d ON e.department_id = d.department_id
GROUP BY d.department_name
HAVING SUM(e.salary) > 100000;

-- 19. Departments where average salary is above 60,000
SELECT d.department_name, AVG(e.salary) AS avg_salary
FROM employees e
JOIN departments d ON e.department_id = d.department_id
GROUP BY d.department_name
HAVING AVG(e.salary) > 60000;

-- 20. Years and number of employees hired in each year
SELECT YEAR(hire_date) AS hire_year, COUNT(*) AS employee_count
FROM employees
GROUP BY YEAR(hire_date);

-- 21. Departments where the sum of salaries is less than 120,000
SELECT d.department_name, SUM(e.salary) AS total_salary
FROM employees e
JOIN departments d ON e.department_id = d.department_id
GROUP BY d.department_name
HAVING SUM(e.salary) < 120000;

-- 22. Departments with an average salary below 55,000
SELECT d.department_name, AVG(e.salary) AS avg_salary
FROM employees e
JOIN departments d ON e.department_id = d.department_id
GROUP BY d.department_name
HAVING AVG(e.salary) < 55000;

-- 23. Departments with more than 3 employees and total salary above 150,000
SELECT d.department_name, COUNT(*) AS emp_count, SUM(e.salary) AS total_salary
FROM employees e
JOIN departments d ON e.department_id = d.department_id
GROUP BY d.department_name
HAVING COUNT(*) > 3 AND SUM(e.salary) > 150000;

-- 24. Departments where maximum salary is at least 70,000
SELECT d.department_name, MAX(e.salary) AS max_salary
FROM employees e
JOIN departments d ON e.department_id = d.department_id
GROUP BY d.department_name
HAVING MAX(e.salary) >= 70000;

-- 25. Departments where minimum salary is above 50,000
SELECT d.department_name, MIN(e.salary) AS min_salary
FROM employees e
JOIN departments d ON e.department_id = d.department_id
GROUP BY d.department_name
HAVING MIN(e.salary) > 50000;

-- 26. Highest salary among employees who joined after 2020-01-01
SELECT MAX(salary) AS max_salary
FROM employees
WHERE hire_date > '2020-01-01';

-- 27. Count of employees with salary below the overall average
SELECT COUNT(*) AS below_avg_count
FROM employees
WHERE salary < (SELECT AVG(salary) FROM employees);

-- 28. List all departments and their total salary, including departments with NULL names
SELECT d.department_name, SUM(e.salary) AS total_salary
FROM employees e
LEFT JOIN departments d ON e.department_id = d.department_id
GROUP BY d.department_name;

-- 29. Department with the most employees
SELECT d.department_name, COUNT(*) AS employee_count
FROM employees e
JOIN departments d ON e.department_id = d.department_id
GROUP BY d.department_name
ORDER BY employee_count DESC
LIMIT 1;

-- 30. Department with the lowest total salary
SELECT d.department_name, SUM(e.salary) AS total_salary
FROM employees e
JOIN departments d ON e.department_id = d.department_id
GROUP BY d.department_name
ORDER BY total_salary ASC
LIMIT 1;

-- 31. List all employees and their department names (INNER JOIN)
SELECT e.name AS employee_name, d.department_name
FROM employees e
INNER JOIN departments d ON e.department_id = d.department_id;

-- 32. List all employees and their department names, including those without a department (LEFT JOIN)
SELECT e.name AS employee_name, d.department_name
FROM employees e
LEFT JOIN departments d ON e.department_id = d.department_id;

-- 33. List all departments and employees, including departments with no employees (RIGHT JOIN)
SELECT d.department_name, e.name AS employee_name
FROM employees e
RIGHT JOIN departments d ON e.department_id = d.department_id;

-- 34. Show all department names, even if there are no employees in them
SELECT d.department_name
FROM departments d
LEFT JOIN employees e ON e.department_id = d.department_id;

-- 35. For each department, list the department name and the number of employees in it
SELECT d.department_name, COUNT(e.employee_id) AS employee_count
FROM departments d
LEFT JOIN employees e ON e.department_id = d.department_id
GROUP BY d.department_name;

-- 36. Show all employees, their department names, and their latest salary paid
SELECT e.name AS employee_name, d.department_name, s.amount AS latest_salary
FROM employees e
LEFT JOIN departments d ON e.department_id = d.department_id
LEFT JOIN salaries s ON e.employee_id = s.employee_id
WHERE s.date_paid = (
    SELECT MAX(s2.date_paid)
    FROM salaries s2
    WHERE s2.employee_id = e.employee_id
);

-- 37. List all salaries paid in each department
SELECT d.department_name, s.amount, s.date_paid
FROM salaries s
JOIN employees e ON s.employee_id = e.employee_id
JOIN departments d ON e.department_id = d.department_id;

-- 38. Find employees who have never been paid a salary
SELECT e.name
FROM employees e
LEFT JOIN salaries s ON e.employee_id = s.employee_id
WHERE s.employee_id IS NULL;

-- 39. List departments and the total paid to their employees
SELECT d.department_name, SUM(s.amount) AS total_paid
FROM salaries s
JOIN employees e ON s.employee_id = e.employee_id
JOIN departments d ON e.department_id = d.department_id
GROUP BY d.department_name;

-- 40. Find the average salary amount paid per department
SELECT d.department_name, ROUND(AVG(s.amount)) AS avg_paid
FROM salaries s
JOIN employees e ON s.employee_id = e.employee_id
JOIN departments d ON e.department_id = d.department_id
GROUP BY d.department_name;

-- 41. List all employees with their manager’s name
SELECT 
  e.name AS employee_name,
  m.name AS manager_name
FROM employees e
LEFT JOIN employees m ON e.manager_id = m.employee_id;

-- 42. Find employees who are also managers
SELECT DISTINCT m.name AS manager_name
FROM employees e
JOIN employees m ON e.manager_id = m.employee_id;

-- 43. Find employees who have the same manager
SELECT e1.name AS employee_1, e2.name AS employee_2, m.name AS shared_manager
FROM employees e1
JOIN employees e2 ON e1.manager_id = e2.manager_id AND e1.employee_id <> e2.employee_id
JOIN employees m ON e1.manager_id = m.employee_id;

-- 44. List all managers and the number of employees reporting to them
SELECT m.name AS manager_name, COUNT(e.employee_id) AS report_count
FROM employees e
JOIN employees m ON e.manager_id = m.employee_id
GROUP BY m.name;

-- 45. Show employees whose manager is in the "IT" department
SELECT e.name AS employee_name, m.name AS manager_name
FROM employees e
JOIN employees m ON e.manager_id = m.employee_id
JOIN departments d ON m.department_id = d.department_id
WHERE d.department_name = 'IT';

-- 46. For each department, show the department name and the highest salary of its employees
SELECT d.department_name, MAX(e.salary) AS highest_salary
FROM employees e
JOIN departments d ON e.department_id = d.department_id
GROUP BY d.department_name;

-- 47. List employees whose salary is higher than the average salary of their department
SELECT e.name, e.salary, d.department_name
FROM employees e
JOIN departments d ON e.department_id = d.department_id
WHERE e.salary > (
    SELECT AVG(e2.salary)
    FROM employees e2
    WHERE e2.department_id = e.department_id
);

-- 48. List all departments with the total salary paid to employees who joined before 2020
SELECT d.department_name, SUM(e.salary) AS total_salary
FROM employees e
JOIN departments d ON e.department_id = d.department_id
WHERE e.hire_date < '2020-01-01'
GROUP BY d.department_name;

-- 49. Show departments where all employees have a salary above 50,000
SELECT d.department_name
FROM departments d
JOIN employees e ON d.department_id = e.department_id
GROUP BY d.department_name
HAVING MIN(e.salary) > 50000;

-- 50. Find the manager who manages the most employees
SELECT m.name AS manager_name, COUNT(e.employee_id) AS num_reports
FROM employees e
JOIN employees m ON e.manager_id = m.employee_id
GROUP BY m.name
ORDER BY num_reports DESC
LIMIT 1;
