CREATE DATABASE payroll_processing;
USE payroll_processing;

CREATE TABLE Employees (
  emp_id INT PRIMARY KEY AUTO_INCREMENT,
  emp_name VARCHAR(100),
  department VARCHAR(50),
  joining_date DATE
);

CREATE TABLE Payroll (
  payroll_id INT PRIMARY KEY AUTO_INCREMENT,
  emp_id INT,
  month_year VARCHAR(10),
  base_salary DECIMAL(10,2),
  tax_deducted DECIMAL(10,2),
  net_salary DECIMAL(10,2),
  FOREIGN KEY (emp_id) REFERENCES Employees(emp_id)
);

CREATE TABLE PayrollAudit (
  audit_id INT PRIMARY KEY AUTO_INCREMENT,
  emp_id INT,
  action VARCHAR(50),
  old_salary DECIMAL(10,2),
  new_salary DECIMAL(10,2),
  action_date DATETIME DEFAULT CURRENT_TIMESTAMP
);


INSERT INTO Employees (emp_name, department, joining_date) VALUES
('Alice', 'HR', '2021-01-15'),
('Bob', 'Finance', '2020-03-20'),
('Charlie', 'IT', '2022-05-10'),
('David', 'HR', '2019-08-01'),
('Eve', 'Marketing', '2023-02-05'),
('Frank', 'Finance', '2018-11-25'),
('Grace', 'IT', '2022-06-12'),
('Heidi', 'Marketing', '2021-07-07'),
('Ivan', 'Finance', '2020-12-15'),
('Judy', 'HR', '2022-01-19');


INSERT INTO Payroll (emp_id, month_year, base_salary, tax_deducted, net_salary)
VALUES
(1, '2025-07', 5000, 500, 4500),
(2, '2025-07', 6000, 600, 5400),
(3, '2025-07', 5500, 550, 4950),
(4, '2025-07', 5200, 520, 4680),
(5, '2025-07', 4800, 480, 4320),
(6, '2025-07', 6200, 620, 5580),
(7, '2025-07', 5300, 530, 4770),
(8, '2025-07', 4700, 470, 4230),
(9, '2025-07', 5800, 580, 5220),
(10,'2025-07', 5100, 510, 4590),
(1, '2025-06', 5000, 500, 4500),
(2, '2025-06', 6000, 600, 5400),
(3, '2025-06', 5500, 550, 4950),
(4, '2025-06', 5200, 520, 4680),
(5, '2025-06', 4800, 480, 4320),
(6, '2025-06', 6200, 620, 5580),
(7, '2025-06', 5300, 530, 4770),
(8, '2025-06', 4700, 470, 4230),
(9, '2025-06', 5800, 580, 5220),
(10,'2025-06', 5100, 510, 4590);

-- Views: HR vs Employee
CREATE OR REPLACE VIEW vw_hr_payroll AS
SELECT 
  e.emp_id,
  e.emp_name,
  e.department,
  p.month_year,
  p.base_salary,
  p.tax_deducted,
  p.net_salary
FROM Employees e
JOIN Payroll p ON e.emp_id = p.emp_id;

CREATE OR REPLACE VIEW vw_employee_payroll AS
SELECT 
  e.emp_id,
  e.emp_name,
  e.department,
  p.month_year
FROM Employees e
JOIN Payroll p ON e.emp_id = p.emp_id;
SELECT * FROM vw_hr_payroll;
SELECT * FROM vw_employee_payroll;

-- Stored Procedure: Generate Monthly Payroll Report
DELIMITER $$

CREATE PROCEDURE GenerateMonthlyPayrollReport(IN report_month VARCHAR(10))
BEGIN
  SELECT 
    e.emp_id,
    e.emp_name,
    e.department,
    p.month_year,
    p.base_salary,
    p.tax_deducted,
    p.net_salary
  FROM Employees e
  JOIN Payroll p ON e.emp_id = p.emp_id
  WHERE p.month_year = report_month;
END$$

DELIMITER ;
CALL GenerateMonthlyPayrollReport('2025-07');


-- Function: Calculate Tax Deduction
DELIMITER $$

CREATE FUNCTION CalculateTax(salary DECIMAL(10,2))
RETURNS DECIMAL(10,2)
DETERMINISTIC
BEGIN
  RETURN salary * 0.10;
END$$

DELIMITER ;
SELECT CalculateTax(6000) AS TaxAmount;

-- Trigger: Log salary changes
DELIMITER $$

CREATE TRIGGER trg_log_salary_change
AFTER UPDATE ON Payroll
FOR EACH ROW
BEGIN
  IF OLD.base_salary != NEW.base_salary THEN
    INSERT INTO PayrollAudit (emp_id, action, old_salary, new_salary)
    VALUES (NEW.emp_id, 'Salary Changed', OLD.base_salary, NEW.base_salary);
  END IF;
END$$

DELIMITER ;
SELECT * FROM PayrollAudit;


-- Example summary
CREATE OR REPLACE VIEW vw_payroll_summary AS
SELECT 
  department,
  SUM(base_salary) AS total_base_salary,
  SUM(tax_deducted) AS total_tax,
  SUM(net_salary) AS total_net_salary
FROM vw_hr_payroll
GROUP BY department;

-- Output updated summary
SELECT * FROM vw_payroll_summary;
