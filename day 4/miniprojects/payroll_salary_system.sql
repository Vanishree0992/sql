CREATE DATABASE Payroll_DB;
USE Payroll_DB;

CREATE TABLE Employees (
  emp_id INT PRIMARY KEY AUTO_INCREMENT,
  emp_name VARCHAR(100) NOT NULL,
  department VARCHAR(100)
);

CREATE TABLE Salaries (
  salary_id INT PRIMARY KEY AUTO_INCREMENT,
  emp_id INT NOT NULL,
  salary_date DATE NOT NULL,
  base_salary DECIMAL(10, 2) NOT NULL CHECK (base_salary >= 3000),
  bonus DECIMAL(10, 2) DEFAULT 0,
  FOREIGN KEY (emp_id) REFERENCES Employees(emp_id) ON DELETE CASCADE
);

CREATE TABLE Deductions (
  deduction_id INT PRIMARY KEY AUTO_INCREMENT,
  salary_id INT NOT NULL,
  deduction_reason VARCHAR(255),
  deduction_amount DECIMAL(10, 2) NOT NULL CHECK (deduction_amount >= 0),
  FOREIGN KEY (salary_id) REFERENCES Salaries(salary_id) ON DELETE CASCADE
);

INSERT INTO Employees (emp_name, department)
VALUES 
  ('Alice Employee', 'HR'),
  ('Bob Staff', 'Finance');

-- •	Use transactions for salary + deduction insertion.
START TRANSACTION;

INSERT INTO Salaries (emp_id, salary_date, base_salary, bonus)
VALUES (1, '2025-07-05', 4000, 500);

SET @salary_id = LAST_INSERT_ID();

-- •	Update with bonus or deduction.
INSERT INTO Deductions (salary_id, deduction_reason, deduction_amount)
VALUES (@salary_id, 'Tax', 200.00);

COMMIT;

--	Update with bonus or deduction.
UPDATE Salaries
SET bonus = 700
WHERE salary_id = 1 AND salary_id > 0;
 
-- •	Delete old salary records after 2 years.
DELETE FROM Salaries
WHERE salary_date < DATE_SUB(CURDATE(), INTERVAL 2 YEAR)
  AND salary_id > 0;

SELECT * FROM Employees;
SELECT * FROM Salaries;
SELECT * FROM Deductions;