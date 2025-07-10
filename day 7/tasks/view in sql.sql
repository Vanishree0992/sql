CREATE DATABASE CompanyDB;
USE CompanyDB;

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
  role VARCHAR(50),
  LastModified DATETIME,
  FOREIGN KEY (dept_id) REFERENCES Departments(dept_id)
);

CREATE TABLE Customers (
  customer_id INT AUTO_INCREMENT PRIMARY KEY,
  customer_name VARCHAR(100),
  joining_date DATE
);


CREATE TABLE Products (
  product_id INT AUTO_INCREMENT PRIMARY KEY,
  product_name VARCHAR(100)
);


CREATE TABLE Orders (
  order_id INT AUTO_INCREMENT PRIMARY KEY,
  customer_id INT,
  product_id INT,
  quantity INT,
  FOREIGN KEY (customer_id) REFERENCES Customers(customer_id),
  FOREIGN KEY (product_id) REFERENCES Products(product_id)
);

CREATE TABLE Projects (
  project_id INT AUTO_INCREMENT PRIMARY KEY,
  emp_id INT,
  project_name VARCHAR(100),
  status VARCHAR(20),
  FOREIGN KEY (emp_id) REFERENCES Employees(emp_id)
);

CREATE TABLE Users (
  user_id INT AUTO_INCREMENT PRIMARY KEY,
  username VARCHAR(50)
);

CREATE TABLE UserRoles (
  role_id INT AUTO_INCREMENT PRIMARY KEY,
  user_id INT,
  role VARCHAR(50),
  FOREIGN KEY (user_id) REFERENCES Users(user_id)
);

CREATE TABLE LogTable (
  log_id INT AUTO_INCREMENT PRIMARY KEY,
  action VARCHAR(100),
  action_time DATETIME DEFAULT CURRENT_TIMESTAMP
);


CREATE TABLE Employee_Audit (
  audit_id INT AUTO_INCREMENT PRIMARY KEY,
  emp_id INT,
  action VARCHAR(50),
  action_time DATETIME DEFAULT CURRENT_TIMESTAMP
);


CREATE TABLE DeletedEmployees (
  del_id INT AUTO_INCREMENT PRIMARY KEY,
  emp_id INT,
  deleted_at DATETIME DEFAULT CURRENT_TIMESTAMP
);


INSERT INTO Departments (dept_name) VALUES
('HR'), ('Finance'), ('IT'), ('Marketing'), ('Sales');

INSERT INTO Employees (emp_name, dept_id, salary, status, email, joining_date, role)
VALUES
('Alice Johnson', 1, 55000, 'Active', 'alice.johnson@example.com', '2024-01-15', 'Junior'),
('Bob Smith', 2, 72000, 'Active', 'bob.smith@example.com', '2023-06-10', 'Senior'),
('Charlie Davis', 3, 48000, 'Active', NULL, '2023-11-20', 'Junior'),
('Diana Prince', 3, 85000, 'Active', 'diana.prince@example.com', '2022-04-01', 'Lead'),
('Ethan Hunt', 4, 60000, 'Active', 'ethan.hunt@example.com', '2023-08-05', 'Senior'),
('Fiona Carter', 5, 40000, 'Inactive', NULL, '2024-02-10', 'Junior'),
('George Miller', 1, 52000, 'Active', 'george.miller@example.com', '2024-04-12', 'Junior'),
('Hannah Lee', 2, 69000, 'Active', 'hannah.lee@example.com', '2023-09-18', 'Senior'),
('Ian Wright', 3, 75000, 'Active', 'ian.wright@example.com', '2022-12-25', 'Lead'),
('Jenny Brown', 4, 53000, 'Active', 'jenny.brown@example.com', '2023-07-11', 'Junior'),
('Kevin Adams', 5, 46000, 'Inactive', NULL, '2023-11-05', 'Junior'),
('Laura Wilson', 1, 58000, 'Active', 'laura.wilson@example.com', '2023-03-21', 'Junior'),
('Mike Taylor', 2, 78000, 'Active', 'mike.taylor@example.com', '2022-05-15', 'Senior'),
('Nina Scott', 3, 82000, 'Active', 'nina.scott@example.com', '2023-02-14', 'Lead'),
('Oscar Reed', 4, 49000, 'Inactive', NULL, '2024-03-03', 'Junior'),
('Paula Green', 5, 56000, 'Active', 'paula.green@example.com', '2023-12-01', 'Junior'),
('Quincy Hall', 1, 63000, 'Active', 'quincy.hall@example.com', '2023-10-22', 'Senior'),
('Rachel Young', 2, 70000, 'Active', 'rachel.young@example.com', '2022-09-09', 'Senior'),
('Steve King', 3, 67000, 'Active', 'steve.king@example.com', '2024-01-30', 'Junior'),
('Tina Lewis', 4, 54000, 'Active', 'tina.lewis@example.com', '2023-06-06', 'Junior'),
('Uma Patel', 5, 48000, 'Inactive', NULL, '2023-07-29', 'Junior');


INSERT INTO Customers (customer_name, joining_date) VALUES
('Acme Corp', CURDATE()),
('Beta Ltd', DATE_SUB(CURDATE(), INTERVAL 2 MONTH)),
('Gamma Inc', DATE_SUB(CURDATE(), INTERVAL 4 MONTH)),
('Delta Enterprises', DATE_SUB(CURDATE(), INTERVAL 1 YEAR)),
('Epsilon LLC', CURDATE()),
('Zeta Group', DATE_SUB(CURDATE(), INTERVAL 5 MONTH)),
('Eta Solutions', DATE_SUB(CURDATE(), INTERVAL 3 MONTH)),
('Theta Services', DATE_SUB(CURDATE(), INTERVAL 6 MONTH)),
('Iota Systems', DATE_SUB(CURDATE(), INTERVAL 8 MONTH)),
('Kappa Industries', DATE_SUB(CURDATE(), INTERVAL 2 WEEK));


INSERT INTO Products (product_name) VALUES
('Product Alpha'),
('Product Beta'),
('Product Gamma'),
('Product Delta'),
('Product Epsilon');


INSERT INTO Orders (customer_id, product_id, quantity) VALUES
(1, 1, 5),
(2, 2, 3),
(3, 3, 7),
(4, 4, 2),
(5, 5, 6),
(6, 1, 4),
(7, 2, 8),
(8, 3, 1),
(9, 4, 10),
(10, 5, 5),
(1, 2, 6),
(2, 3, 2),
(3, 4, 9),
(4, 5, 3),
(5, 1, 7);


INSERT INTO Projects (emp_id, project_name, status) VALUES
(1, 'Project Apollo', 'Active'),
(2, 'Project Zeus', 'Active'),
(3, 'Project Hera', 'Completed'),
(4, 'Project Poseidon', 'Active'),
(5, 'Project Athena', 'Completed'),
(6, 'Project Ares', 'Active'),
(7, 'Project Artemis', 'Active'),
(8, 'Project Hermes', 'Completed'),
(9, 'Project Hades', 'Active'),
(10, 'Project Demeter', 'Active');

INSERT INTO Users (username) VALUES
('alice'),
('bob'),
('charlie'),
('diana'),
('ethan');

 -- A. Views in SQL 
 -- 1. Active employees
CREATE VIEW ActiveEmployees AS
SELECT * FROM Employees WHERE status = 'Active';
SELECT * FROM ActiveEmployees;

-- 2. High salary employees (>50k)
CREATE VIEW HighSalaryEmployees AS
SELECT * FROM Employees WHERE salary > 50000;
SELECT * FROM HighSalaryEmployees;

-- 3. Join Employees + Departments
CREATE VIEW EmployeeDept AS
SELECT e.emp_name, d.dept_name
FROM Employees e
JOIN Departments d ON e.dept_id = d.dept_id;
SELECT * FROM EmployeeDept;

-- 4. Update HighSalaryEmployees to include dept
DROP VIEW IF EXISTS HighSalaryEmployees;
CREATE VIEW HighSalaryEmployees AS
SELECT e.*, d.dept_name
FROM Employees e
JOIN Departments d ON e.dept_id = d.dept_id
WHERE salary > 50000;
SELECT * FROM HighSalaryEmployees;
    
-- 5. Hide salary
CREATE VIEW EmployeePublicView AS
SELECT emp_id, emp_name FROM Employees;
SELECT * FROM EmployeePublicView;

-- 6. IT Employees
CREATE VIEW ITEmployees AS
SELECT * FROM Employees
WHERE dept_id = (SELECT dept_id FROM Departments WHERE dept_name = 'IT');
SELECT * FROM ITEmployees;

-- 7. Drop ITEmployees view
DROP VIEW IF EXISTS ITEmployees;

-- 8. Customers joined in last 6 months
CREATE VIEW RecentCustomers AS
SELECT * FROM Customers
WHERE joining_date >= DATE_SUB(CURDATE(), INTERVAL 6 MONTH);
SELECT * FROM RecentCustomers;

-- 9. View with aliases
CREATE VIEW EmployeeAliasView AS
SELECT emp_name AS EmployeeName, d.dept_name AS Dept
FROM Employees e
JOIN Departments d ON e.dept_id = d.dept_id;
SELECT * FROM EmployeeAliasView;

-- 10. Filter out NULL emails
CREATE VIEW NonNullEmailEmployees AS
SELECT * FROM Employees WHERE email IS NOT NULL;
SELECT * FROM NonNullEmailEmployees;

-- 11. Employees hired in last year
CREATE VIEW LastYearHires AS
SELECT * FROM Employees
WHERE joining_date >= DATE_SUB(CURDATE(), INTERVAL 1 YEAR);
SELECT * FROM LastYearHires;

-- 12. Computed column (bonus)
CREATE VIEW EmployeesWithBonus AS
SELECT *, salary * 0.10 AS bonus FROM Employees;
SELECT * FROM EmployeesWithBonus;

-- 13. Join Orders, Customers, Products
CREATE VIEW OrderDetails AS
SELECT o.order_id, c.customer_name, p.product_name, o.quantity
FROM Orders o
JOIN Customers c ON o.customer_id = c.customer_id
JOIN Products p ON o.product_id = p.product_id;
SELECT * FROM OrderDetails;

-- 14. View for total salary by dept
CREATE VIEW SalaryByDept AS
SELECT d.dept_name, SUM(e.salary) AS total_salary
FROM Employees e
JOIN Departments d ON e.dept_id = d.dept_id
GROUP BY d.dept_name;
SELECT * FROM SalaryByDept;

-- 15. Read-only junior staff
CREATE VIEW JuniorStaffPublic AS
SELECT emp_id, emp_name, dept_id FROM Employees WHERE role = 'Junior';
SELECT * FROM JuniorStaffPublic;
