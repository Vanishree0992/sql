CREATE DATABASE HR_DB;
USE HR_DB;

CREATE TABLE Departments (
  DeptID INT PRIMARY KEY AUTO_INCREMENT,
  DeptName VARCHAR(50) NOT NULL
);

CREATE TABLE Employees (
  EmpID INT PRIMARY KEY AUTO_INCREMENT,
  EmpName VARCHAR(100) NOT NULL,
  DeptID INT,
  HireDate DATE,
  FOREIGN KEY (DeptID) REFERENCES Departments(DeptID)
);

CREATE TABLE Salaries (
  SalaryID INT PRIMARY KEY AUTO_INCREMENT,
  EmpID INT,
  Salary DECIMAL(10,2),
  LastUpdated TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  FOREIGN KEY (EmpID) REFERENCES Employees(EmpID)
);

INSERT INTO Departments (DeptName)
VALUES 
('HR'),
('Finance'),
('IT'),
('Marketing');

INSERT INTO Employees (EmpName, DeptID, HireDate)
VALUES ('Alice Johnson', 1, '2022-03-15');

INSERT INTO Employees (EmpName, DeptID, HireDate)
VALUES 
('Bob Smith', 2, '2021-05-20'),
('Carol White', 3, '2020-08-10'),
('David Brown', 3, '2023-01-12'),
('Eve Black', 4, '2022-09-25');

INSERT INTO Salaries (EmpID, Salary)
VALUES 
(1, 75000),
(2, 80000),
(3, 90000),
(4, 95000),
(5, 70000);

--	Use SELECT, WHERE, and ORDER BY to retrieve and sort high-performing employees.
SELECT e.EmpName, d.DeptName, s.Salary
FROM Employees e
JOIN Departments d ON e.DeptID = d.DeptID
JOIN Salaries s ON e.EmpID = s.EmpID
WHERE s.Salary > 80000
ORDER BY s.Salary DESC;

-- •	Use GROUP BY with AVG(salary) to get department-wise averages
SELECT d.DeptName, AVG(s.Salary) AS AvgSalary
FROM Employees e
JOIN Departments d ON e.DeptID = d.DeptID
JOIN Salaries s ON e.EmpID = s.EmpID
GROUP BY d.DeptName;


--	Use CASE WHEN to classify salaries as High, Medium, Low.

SELECT e.EmpName, s.Salary,
  CASE 
    WHEN s.Salary >= 90000 THEN 'High'
    WHEN s.Salary >= 75000 THEN 'Medium'
    ELSE 'Low'
  END AS SalaryLevel
FROM Employees e
JOIN Salaries s ON e.EmpID = s.EmpID;

--	Update salaries using UPDATE, and rollback changes if the update fails (use transactions).
START TRANSACTION;

UPDATE Salaries s
JOIN Employees e ON s.EmpID = e.EmpID
SET s.Salary = s.Salary * 1.10
WHERE e.DeptID = 3;

SELECT * FROM Salaries;

COMMIT;