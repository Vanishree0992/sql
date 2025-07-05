CREATE DATABASE EmployeeMDB;

USE EmployeeMDB;

CREATE TABLE Departments (
    dept_id INT PRIMARY KEY AUTO_INCREMENT,
    dept_name VARCHAR(50) NOT NULL
);

CREATE TABLE Employees (
    emp_id INT PRIMARY KEY AUTO_INCREMENT,
    emp_name VARCHAR(100) NOT NULL,
    salary DECIMAL(10, 2) CHECK (salary > 3000),
    department_id INT,
    FOREIGN KEY (department_id) REFERENCES Departments(dept_id)
        ON DELETE SET NULL
        ON UPDATE CASCADE
);

INSERT INTO Departments (dept_name)
VALUES 
('HR'),
('Finance'),
('Engineering');

INSERT INTO Employees (emp_name, salary, department_id)
VALUES 
('Alice', 5000, 1),
('Bob', 6000, 2),
('Charlie', 7000, 3);

-- 	Allow updating department or salary using UPDATE.
SELECT emp_id FROM Employees WHERE emp_name = 'Alice';
UPDATE Employees 
SET salary = 7500 
WHERE emp_id = 1;

SELECT emp_id, emp_name FROM Employees WHERE emp_name = 'Charlie';
UPDATE Employees
SET department_id = 2
WHERE emp_id = 3;

-- 	Allow deleting employees who resigned.
SELECT emp_id FROM Employees WHERE emp_name = 'Bob';
DELETE FROM Employees
WHERE emp_id = 2;

--	Add CHECK for salary > 3000.
ALTER TABLE Employees
ADD CONSTRAINT chk_salary CHECK (salary > 3000);

SHOW CREATE TABLE Employees;
--	Use FOREIGN KEY between Employees.department_id and Departments.dept_id.
ALTER TABLE Employees
ADD CONSTRAINT fk_department
FOREIGN KEY (department_id) REFERENCES Departments(dept_id)
ON DELETE SET NULL
ON UPDATE CASCADE;

--	Use transactions for hiring multiple employees with SAVEPOINT, ROLLBACK, and COMMIT.
START TRANSACTION;

INSERT INTO Employees (emp_name, salary, department_id)
VALUES ('David', 5000, 1);

SAVEPOINT hire_second_employee;

INSERT INTO Employees (emp_name, salary, department_id)
VALUES ('Eva', 2500, 2);

ROLLBACK TO hire_second_employee;

INSERT INTO Employees (emp_name, salary, department_id)
VALUES ('Eva', 5000, 2);  

COMMIT;