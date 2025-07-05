CREATE DATABASE new_tasks;
USE new_tasks;
-- 31 Create Departments with PRIMARY KEY on dept_id and UNIQUE on dept_name
CREATE TABLE Departments (
  dept_id INT PRIMARY KEY,
  dept_name VARCHAR(50) UNIQUE
);

-- Insert test data
INSERT INTO Departments (dept_id, dept_name) VALUES
(1, 'HR'),
(2, 'Finance'),
(3, 'IT');

-- 32  Create Employees with NOT NULL on name and salary
CREATE TABLE Employees (
  emp_id INT PRIMARY KEY,
  name VARCHAR(100) NOT NULL,
  department_id INT,
  salary DECIMAL(10,2) NOT NULL
);

-- 33 Add a CHECK constraint for salary > ₹3,000
ALTER TABLE Employees
ADD CONSTRAINT chk_salary CHECK (salary > 3000);

-- 34 Add FOREIGN KEY from Employees.department_id to Departments.dept_id
ALTER TABLE Employees
ADD CONSTRAINT fk_department
FOREIGN KEY (department_id) REFERENCES Departments(dept_id);

-- 35 Try inserting an employee with NULL name (should fail)
INSERT INTO Employees (emp_id, name, department_id, salary)
VALUES (1, NULL, 1, 40000); 

-- 36 Insert employee with salary below ₹3,000 (should fail CHECK)
INSERT INTO Employees (emp_id, name, department_id, salary)
VALUES (2, 'LowPay', 1, 2500); 

-- 37  Insert duplicate department name (should fail UNIQUE)
INSERT INTO Departments (dept_id, dept_name)
VALUES (4, 'HR');

-- 38 Insert employee with non-existent department_id (should fail FK)
INSERT INTO Employees (emp_id, name, department_id, salary)
VALUES (3, 'Ghost', 999, 45000);

-- 39 Add a new constraint to an existing table using ALTER TABLE
ALTER TABLE Employees
ADD CONSTRAINT uq_emp_name UNIQUE (name);

-- 40  Drop a constraint using ALTER TABLE DROP CONSTRAINT
SHOW CREATE TABLE Employees;
ALTER TABLE Employees DROP FOREIGN KEY fk_department;
ALTER TABLE Employees DROP CHECK chk_salary;
ALTER TABLE Employees DROP INDEX uq_emp_name;

-- 41 Start a transaction and insert two new employees, then COMMIT
START TRANSACTION;

INSERT INTO Employees (emp_id, name, department_id, salary)
VALUES (10, 'Alice', 1, 60000);

INSERT INTO Employees (emp_id, name, department_id, salary)
VALUES (11, 'Bob', 2, 55000);

COMMIT;

-- 42  Start a transaction, update salary, then ROLLBACK
START TRANSACTION;
UPDATE Employees
SET salary = salary + 10000
WHERE emp_id = 10;
ROLLBACK;

-- 43 Insert a record, create a SAVEPOINT, update it, then rollback to SAVEPOINT
START TRANSACTION;

INSERT INTO Employees (emp_id, name, department_id, salary)
VALUES (12, 'Charlie', 3, 50000);

SAVEPOINT after_insert;

UPDATE Employees
SET salary = 70000
WHERE emp_id = 12;

ROLLBACK TO SAVEPOINT after_insert;

COMMIT;

-- 44 Start a transaction and delete 2 employees, then COMMIT
START TRANSACTION;

DELETE FROM Employees WHERE emp_id = 10;
DELETE FROM Employees WHERE emp_id = 11;

COMMIT;

-- 45 Update salary, create two SAVEPOINTs, rollback to first one
START TRANSACTION;

UPDATE Employees SET salary = salary + 5000 WHERE emp_id = 12;
SAVEPOINT sp1;

UPDATE Employees SET salary = salary + 5000 WHERE emp_id = 12;
SAVEPOINT sp2;

ROLLBACK TO SAVEPOINT sp1;

COMMIT;

-- 46 Test isolation: update same record in 2 sessions
START TRANSACTION;
UPDATE Employees SET salary = 80000 WHERE emp_id = 12;

-- 47 Insert multiple records inside a transaction, rollback on simulated error
START TRANSACTION;

INSERT INTO Employees (emp_id, name, department_id, salary)
VALUES (13, 'David', 2, 50000);

INSERT INTO Employees (emp_id, name, department_id, salary)
VALUES (13, 'Duplicate', 1, 60000);

ROLLBACK;

-- 48 Update all department names in a transaction, commit only if all succeed
START TRANSACTION;

UPDATE Departments SET dept_name = 'HR Team' WHERE dept_id = 1;
UPDATE Departments SET dept_name = 'Finance Team' WHERE dept_id = 2;
UPDATE Departments SET dept_name = 'IT Team' WHERE dept_id = 3;

COMMIT;

-- 49  Simulate partial failure ➜ rollback entire transaction
START TRANSACTION;

INSERT INTO Departments (dept_id, dept_name) VALUES (4, 'Legal');
INSERT INTO Departments (dept_id, dept_name) VALUES (1, 'Duplicate HR'); -- fails UNIQUE

ROLLBACK;

SELECT * FROM Departments;

-- 50 Use transaction to transfer employee & log the change
CREATE TABLE IF NOT EXISTS Dept_Transfers (
  transfer_id INT PRIMARY KEY AUTO_INCREMENT,
  emp_id INT,
  old_dept INT,
  new_dept INT,
  transfer_date TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);
START TRANSACTION;

SET @old_dept := (SELECT department_id FROM Employees WHERE emp_id = 12);

UPDATE Employees SET department_id = 1 WHERE emp_id = 12;

INSERT INTO Dept_Transfers (emp_id, old_dept, new_dept)
VALUES (12, @old_dept, 1);

COMMIT;