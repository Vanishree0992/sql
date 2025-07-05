CREATE DATABASE employees_23;
USE employees_23;
-- 1 Create Departments table and insert 3 departments
CREATE TABLE Departments (
  dept_id INT PRIMARY KEY,
  dept_name VARCHAR(50) UNIQUE
);

INSERT INTO Departments (dept_id, dept_name) VALUES
(1, 'HR'),
(2, 'Finance'),
(3, 'IT');

-- 2 Create Employees table and insert 5 rows
CREATE TABLE Employees (
  emp_id INT PRIMARY KEY,
  name VARCHAR(100) NOT NULL,
  department INT,
  salary DECIMAL(10,2),
  FOREIGN KEY (department) REFERENCES Departments(dept_id)
);

INSERT INTO Employees (emp_id, name, department, salary) VALUES
(1, 'Alice', 1, 50000),
(2, 'Bob', 2, 60000),
(3, 'Charlie', 3, 45000),
(4, 'David', 3, 40000),
(5, 'Eve', 1, 55000);

--  3 Insert employee specifying only emp_id and name
INSERT INTO Employees (emp_id, name) 
VALUES (6, 'Frank');

-- 4 Insert employee with columns in different order
INSERT INTO Employees (name, salary, emp_id, department) VALUES ('Grace', 47000, 7, 2);

-- 5 Insert multiple employees in one query
INSERT INTO Employees (emp_id, name, department, salary) VALUES
(8, 'Hannah', 1, 52000),
(9, 'Ian', 2, 51000),
(10, 'Jack', 3, 48000);

--  6 Insert without salary (should store NULL)
INSERT INTO Employees (emp_id, name, department) VALUES (11, 'Kelly', 1);

 -- 7 Insert into a non-existent department (should fail if FK enforced)
INSERT INTO Employees (emp_id, name, department, salary) VALUES (12, 'Laura', 999, 50000);

--  8 Insert duplicate emp_id (should fail due to PRIMARY KEY)
INSERT INTO Employees (emp_id, name, department, salary) VALUES (1, 'Megan', 1, 48000);

--  9 Insert duplicate department name (should fail due to UNIQUE)
INSERT INTO Departments (dept_id, dept_name) VALUES (4, 'HR');

-- 10 Create Attendance table with defaults
CREATE TABLE Attendance (
  attendance_id INT PRIMARY KEY AUTO_INCREMENT,
  emp_id INT,
  attendance_date TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  status VARCHAR(20) DEFAULT 'Present',
  FOREIGN KEY (emp_id) REFERENCES Employees(emp_id)
);

INSERT INTO Attendance (emp_id) VALUES (1);
INSERT INTO Attendance (emp_id, status) VALUES (2, 'Absent');

-- 11 Update salary of all HR employees by ₹5,000
UPDATE Employees
SET salary = salary + 5000
WHERE department = (SELECT dept_id FROM Departments WHERE dept_name = 'HR');

-- 12 Update department of emp_id=2 to 'Finance'
UPDATE Employees
SET department = (SELECT dept_id FROM Departments WHERE dept_name = 'Finance')
WHERE emp_id = 2;

-- 13 Update salary of employees earning less than ₹40,000 to ₹45,000
UPDATE Employees
SET salary = 45000
WHERE salary < 40000
LIMIT 100;

-- 14  Change name of employee emp_id = 3 to 'Michael Scott'
UPDATE Employees
SET name = 'Michael Scott'
WHERE emp_id = 3
LIMIT 50;

-- 15 Increase all IT department employees’ salary by 10%
UPDATE Employees
SET salary = salary * 1.10
WHERE department = (SELECT dept_id FROM Departments WHERE dept_name = 'IT');

-- 16 Set salary to NULL for employees in ‘Testing’ department (test NOT NULL)
INSERT INTO Departments (dept_id, dept_name) VALUES (4, 'Testing');
UPDATE Employees SET department = 4 WHERE emp_id = 5; 

-- 17 . Update department to 'Admin' for all employees with NULL department
INSERT INTO Departments (dept_id, dept_name) VALUES (5, 'Admin');
UPDATE Employees
SET department = 5
WHERE department IS NULL;

-- 18 Update multiple columns in one query
UPDATE Employees
SET department = (SELECT dept_id FROM Departments WHERE dept_name = 'Finance'),
    salary = 70000
WHERE emp_id = 4;

-- 19  Update salaries using a subquery (e.g., raise salary if below average)
SET SQL_SAFE_UPDATES = 0;
UPDATE Employees
JOIN (
  SELECT AVG(salary) AS avg_salary FROM Employees
) AS sub
SET salary = salary + 5000
WHERE salary < sub.avg_salary;

-- 20  Add a bonus column and update it with 5% of salary
ALTER TABLE Employees ADD COLUMN bonus DECIMAL(10,2);
UPDATE Employees
SET bonus = salary * 0.05;

-- 21 Delete an employee with
DELETE FROM Employees
WHERE emp_id = 2;

-- 22 Delete all employees from the 'Finance' department
DELETE FROM Employees
WHERE department = (SELECT dept_id FROM Departments WHERE dept_name = 'Finance');

-- 23 Delete employees whose salary is below ₹30,000
DELETE FROM Employees
WHERE salary < 30000 AND emp_id IS NOT NULL;

-- 24 Delete all rows from Employees (no WHERE)
DELETE FROM Employees;

-- 25  Try deleting a department that is referenced in Employees
DELETE FROM Departments WHERE dept_id = 1;

-- 26 Delete employees who joined before a specific year
ALTER TABLE Employees ADD COLUMN join_date DATE;

UPDATE Employees SET join_date = '2018-05-10' WHERE emp_id = 3;
UPDATE Employees SET join_date = '2023-06-15' WHERE emp_id = 4;

DELETE FROM Employees
WHERE join_date < '2020-01-01' AND emp_id IS NOT NULL;

-- 27 Delete all employees except those in ‘HR’
DELETE FROM Employees
WHERE department NOT IN (SELECT dept_id FROM Departments WHERE dept_name = 'HR')
  AND emp_id IS NOT NULL;

-- 28 Delete employees with NULL department
DELETE FROM Employees
WHERE department IS NULL AND emp_id IS NOT NULL;

-- 29 Delete a record and immediately insert it again (test integrity)
DELETE FROM Employees WHERE emp_id = 5;

INSERT INTO Employees (emp_id, name, department, salary)
VALUES (5, 'Eve', 1, 55000);

-- 30  Perform a delete inside a transaction and rollback it
START TRANSACTION;

DELETE FROM Employees WHERE emp_id = 4;

ROLLBACK;
