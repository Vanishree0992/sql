CREATE DATABASE HRMS_DB;
USE HRMS_DB;

CREATE TABLE Departments (
  dept_id INT AUTO_INCREMENT PRIMARY KEY,
  dept_name VARCHAR(50) NOT NULL
);

CREATE TABLE Employees (
  emp_id INT AUTO_INCREMENT PRIMARY KEY,
  emp_name VARCHAR(100) NOT NULL,
  dept_id INT,
  salary DECIMAL(10,2),
  status VARCHAR(20),
  email VARCHAR(100),
  joining_date DATE,
  FOREIGN KEY (dept_id) REFERENCES Departments(dept_id)
);

CREATE TABLE EmployeeAudit (
  audit_id INT AUTO_INCREMENT PRIMARY KEY,
  emp_id INT,
  action VARCHAR(50),
  action_time DATETIME DEFAULT CURRENT_TIMESTAMP
);


INSERT INTO Departments (dept_name) VALUES
('HR'), ('Finance'), ('IT'), ('Marketing'), ('Sales');

INSERT INTO Employees (emp_name, dept_id, salary, status, email, joining_date)
VALUES
('Alice Johnson', 1, 50000, 'Active', 'alice.johnson@company.com', '2023-01-15'),
('Bob Smith', 2, 65000, 'Active', 'bob.smith@company.com', '2022-11-20'),
('Charlie Brown', 3, 72000, 'Active', 'charlie.brown@company.com', '2021-09-12'),
('Diana Prince', 4, 58000, 'Active', 'diana.prince@company.com', '2022-04-10'),
('Ethan Hunt', 5, 54000, 'Active', 'ethan.hunt@company.com', '2023-02-25'),
('Fiona Carter', 1, 48000, 'Active', 'fiona.carter@company.com', '2022-08-18'),
('George Miller', 2, 70000, 'Active', 'george.miller@company.com', '2023-03-22'),
('Hannah Lee', 3, 69000, 'Active', 'hannah.lee@company.com', '2023-04-02'),
('Ian Wright', 4, 53000, 'Active', 'ian.wright@company.com', '2022-12-05'),
('Jenny Brown', 5, 51000, 'Active', 'jenny.brown@company.com', '2023-05-10'),
('Kevin Adams', 1, 47000, 'Active', 'kevin.adams@company.com', '2023-06-01'),
('Laura Wilson', 2, 68000, 'Active', 'laura.wilson@company.com', '2021-07-15'),
('Mike Taylor', 3, 75000, 'Active', 'mike.taylor@company.com', '2022-10-30'),
('Nina Scott', 4, 56000, 'Active', 'nina.scott@company.com', '2023-01-12'),
('Oscar Reed', 5, 52000, 'Active', 'oscar.reed@company.com', '2022-03-19'),
('Paula Green', 1, 49000, 'Active', 'paula.green@company.com', '2023-07-05'),
('Quincy Hall', 2, 71000, 'Active', 'quincy.hall@company.com', '2022-09-22'),
('Rachel Young', 3, 73000, 'Active', 'rachel.young@company.com', '2023-04-20'),
('Steve King', 4, 55000, 'Active', 'steve.king@company.com', '2021-11-11'),
('Tina Lewis', 5, 50000, 'Active', 'tina.lewis@company.com', '2023-05-28'),
('Uma Patel', 1, 48000, 'Active', 'uma.patel@company.com', '2022-06-15');

-- View: PublicEmployeeView
CREATE OR REPLACE VIEW PublicEmployeeView AS
SELECT 
  e.emp_id,
  e.emp_name,
  d.dept_name
FROM 
  Employees e
  JOIN Departments d ON e.dept_id = d.dept_id;
SELECT * FROM PublicEmployeeView;

-- Stored Procedure: Get employees by department
DELIMITER $$
CREATE PROCEDURE GetEmployeesByDepartment(IN p_dept_name VARCHAR(50))
BEGIN
  SELECT 
    e.emp_id,
    e.emp_name,
    d.dept_name
  FROM 
    Employees e
    JOIN Departments d ON e.dept_id = d.dept_id
  WHERE 
    d.dept_name = p_dept_name;
END $$
DELIMITER ;

CALL GetEmployeesByDepartment('IT');

-- Trigger: Log new employee insertions
-- Audit table if not exists
CREATE TABLE IF NOT EXISTS EmployeeAudit (
  audit_id INT AUTO_INCREMENT PRIMARY KEY,
  emp_id INT,
  action VARCHAR(50),
  action_time DATETIME DEFAULT CURRENT_TIMESTAMP
);

-- Trigger: log every insert
DELIMITER $$
CREATE TRIGGER trg_AfterInsertEmployee
AFTER INSERT ON Employees
FOR EACH ROW
BEGIN
  INSERT INTO EmployeeAudit(emp_id, action)
  VALUES (NEW.emp_id, 'INSERT');
END $$
DELIMITER ;
INSERT INTO Employees (emp_name, dept_id, salary, status, joining_date)
VALUES ('New Hire', 1, 50000, 'Active', CURDATE());

SELECT * FROM EmployeeAudit;

--  Function: Count employees in a department
DELIMITER $$
CREATE FUNCTION CountEmployeesByDept(p_dept_name VARCHAR(50))
RETURNS INT
DETERMINISTIC
BEGIN
  DECLARE total INT;
  SELECT COUNT(*) INTO total
  FROM Employees e
  JOIN Departments d ON e.dept_id = d.dept_id
  WHERE d.dept_name = p_dept_name;
  RETURN total;
END $$
DELIMITER ;

SELECT CountEmployeesByDept('Finance') AS TotalInFinance;

-- CREATE OR REPLACE VIEW for department changes
CREATE OR REPLACE VIEW PublicEmployeeView AS
SELECT 
  e.emp_id,
  e.emp_name,
  d.dept_name
FROM 
  Employees e
  JOIN Departments d ON e.dept_id = d.dept_id;

