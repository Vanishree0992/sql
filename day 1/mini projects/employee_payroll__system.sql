CREATE DATABASE EmployeePayrollDB;

USE EmployeePayrollDB;

--  Tables: Employees, Departments, Salaries.
CREATE TABLE Departments (
    DepartmentID INT AUTO_INCREMENT PRIMARY KEY,
    DepartmentName VARCHAR(100) NOT NULL
);

USE EmployeePayrollDB;
CREATE TABLE Employees (
    EmployeeID INT AUTO_INCREMENT PRIMARY KEY,
    Name VARCHAR(100) NOT NULL,
    DepartmentID INT,
    HireDate DATE,
    FOREIGN KEY (DepartmentID) REFERENCES Departments(DepartmentID)
);

USE EmployeePayrollDB;
CREATE TABLE Salaries (
    SalaryID INT AUTO_INCREMENT PRIMARY KEY,
    EmployeeID INT,
    SalaryAmount DECIMAL(10,2),
    LastUpdated DATE,
    FOREIGN KEY (EmployeeID) REFERENCES Employees(EmployeeID)
);

-- - Insert data for at least 10 employees, 3 departments.
INSERT INTO Departments (DepartmentName) VALUES 
('Human Resources'),
('Engineering'),
('Finance');

INSERT INTO Employees (Name, DepartmentID, HireDate) 
VALUES 
('Alice', 1, '2022-01-10'),
('Bob', 2, '2021-05-15'),
('Charlie', 2, '2020-03-20'),
('David', 3, '2019-07-25'),
('Eva', 1, '2023-02-01'),
('Frank', 2, '2022-09-30'),
('Grace', 3, '2021-11-11'),
('Hank', 1, '2020-04-05'),
('Ivy', 2, '2023-01-15'),
('Jake', 3, '2022-06-18');

INSERT INTO Salaries (EmployeeID, SalaryAmount, LastUpdated) 
VALUES 
(1, 45000.00, '2025-07-02'),
(2, 75000.00, '2025-07-02'),
(3, 70000.00, '2025-07-02'),
(4, 65000.00, '2025-07-02'),
(5, 48000.00, '2025-07-02'),
(6, 72000.00, '2025-07-02'),
(7, 55000.00, '2025-07-02'),
(8, 50000.00, '2025-07-02'),
(9, 68000.00, '2025-07-02'),
(10, 60000.00, '2025-07-02');

-- Retrieve all employees in a department earning above a certain salary.
SELECT 
    e.EmployeeID,
    e.Name,
    d.DepartmentName,
    s.SalaryAmount
FROM 
    Employees e
JOIN 
    Departments d ON e.DepartmentID = d.DepartmentID
JOIN 
    Salaries s ON e.EmployeeID = s.EmployeeID
WHERE 
    d.DepartmentName = 'Engineering'
    AND s.SalaryAmount > 70000;
    
-- Update salary for employees based on performance.
UPDATE Salaries s
JOIN Employees e ON s.EmployeeID = e.EmployeeID
JOIN Departments d ON e.DepartmentID = d.DepartmentID
SET 
    s.SalaryAmount = s.SalaryAmount * 1.10,
    s.LastUpdated = CURDATE()
WHERE 
    d.DepartmentName = 'Finance';
