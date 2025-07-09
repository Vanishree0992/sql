CREATE DATABASE HRMSDB;
USE HRMSDB;

CREATE TABLE Departments (
  dept_id INT AUTO_INCREMENT PRIMARY KEY,
  dept_name VARCHAR(100) NOT NULL
);

CREATE TABLE Employees (
  emp_id INT AUTO_INCREMENT PRIMARY KEY,
  emp_name VARCHAR(100) NOT NULL,
  dept_id INT NOT NULL,
  salary DECIMAL(10,2),
  joining_date DATE,
  FOREIGN KEY (dept_id) REFERENCES Departments(dept_id)
);

CREATE INDEX idx_emp_name ON Employees(emp_name);
CREATE INDEX idx_dept_id ON Employees(dept_id);

INSERT INTO Departments (dept_name) VALUES
('HR'),
('Finance'),
('Engineering'),
('Marketing');

INSERT INTO Employees (emp_name, dept_id, salary, joining_date) VALUES
('Alice Johnson', 1, 60000, '2021-01-15'),
('Bob Smith', 2, 75000, '2020-06-10'),
('Carol White', 3, 90000, '2019-09-20'),
('David Brown', 3, 95000, '2018-03-12'),
('Eva Green', 4, 70000, '2022-02-01'),
('Frank Black', 2, 72000, '2021-11-25'),
('Grace Miller', 1, 64000, '2020-07-07'),
('Henry Lee', 3, 88000, '2019-04-18'),
('Ivy Wilson', 4, 71000, '2022-01-15'),
('Jack Taylor', 3, 93000, '2018-05-20'),
('Kara Adams', 2, 76000, '2020-10-02'),
('Liam Scott', 1, 61000, '2021-03-14'),
('Mia Clark', 4, 72000, '2022-03-01'),
('Noah Lewis', 3, 91000, '2019-06-25'),
('Olivia Young', 1, 65000, '2020-08-08'),
('Paul Hall', 2, 74000, '2021-12-11'),
('Quinn King', 3, 89000, '2018-07-15'),
('Ruby Baker', 4, 73000, '2022-04-12'),
('Sam Carter', 1, 63000, '2021-05-21'),
('Tom Evans', 3, 92000, '2019-08-30');

EXPLAIN
SELECT 
  e.emp_id, e.emp_name, d.dept_name, e.salary
FROM Employees e
JOIN Departments d ON e.dept_id = d.dept_id
WHERE d.dept_name = 'Engineering' AND e.salary > 80000
ORDER BY e.salary DESC;

CREATE OR REPLACE VIEW EmployeeReport AS
SELECT 
  e.emp_id,
  e.emp_name,
  d.dept_name,
  e.salary,
  e.joining_date
FROM Employees e
JOIN Departments d ON e.dept_id = d.dept_id;

SELECT *
FROM EmployeeReport
ORDER BY salary DESC
LIMIT 5;