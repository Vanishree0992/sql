USE CompanyDB;
-- 31 & 32 — EmployeeCount
DELIMITER $$
CREATE FUNCTION EmployeeCount(dept_name VARCHAR(50))
RETURNS INT
DETERMINISTIC
BEGIN
  DECLARE total INT;
  SELECT COUNT(*) INTO total
  FROM Employees e
  JOIN Departments d ON e.dept_id = d.dept_id
  WHERE d.dept_name = dept_name;
  RETURN total;
END $$
DELIMITER ;

SELECT EmployeeCount('IT') AS TotalInIT;

-- 33 Average salary of a department
DELIMITER $$
CREATE FUNCTION AvgSalary(dept_name VARCHAR(50))
RETURNS DECIMAL(10,2)
DETERMINISTIC
BEGIN
  DECLARE avg_sal DECIMAL(10,2);
  SELECT AVG(salary) INTO avg_sal
  FROM Employees e
  JOIN Departments d ON e.dept_id = d.dept_id
  WHERE d.dept_name = dept_name;
  RETURN avg_sal;
END $$
DELIMITER ;

SELECT AvgSalary('Finance') AS AvgSalaryFinance;

-- 34 Age from date of birth
DELIMITER $$
CREATE FUNCTION GetAge(dob DATE)
RETURNS INT
DETERMINISTIC
BEGIN
  RETURN TIMESTAMPDIFF(YEAR, dob, CURDATE());
END $$
DELIMITER ;

SELECT GetAge('1995-03-15') AS Age;

-- 35 Highest salary
DELIMITER $$
CREATE FUNCTION HighestSalary()
RETURNS DECIMAL(10,2)
DETERMINISTIC
BEGIN
  DECLARE max_sal DECIMAL(10,2);
  SELECT MAX(salary) INTO max_sal FROM Employees;
  RETURN max_sal;
END $$
DELIMITER ;

SELECT HighestSalary() AS MaxSalary;

-- 36 Formatted full name
DELIMITER $$
CREATE FUNCTION FullName(first_name VARCHAR(50), last_name VARCHAR(50))
RETURNS VARCHAR(100)
DETERMINISTIC
BEGIN
  RETURN CONCAT(first_name, ' ', last_name);
END $$
DELIMITER ;

SELECT FullName('John', 'Doe') AS FullName;

-- 37  Department exists
DELIMITER $$
CREATE FUNCTION DepartmentExists(dept_name VARCHAR(50))
RETURNS BOOLEAN
DETERMINISTIC
BEGIN
  RETURN EXISTS (SELECT 1 FROM Departments WHERE dept_name = dept_name);
END $$
DELIMITER ;

SELECT DepartmentExists('Marketing') AS DeptExists;

-- 38 Working days since joining
DELIMITER $$
CREATE FUNCTION WorkingDays(join_date DATE)
RETURNS INT
DETERMINISTIC
BEGIN
  RETURN DATEDIFF(CURDATE(), join_date);
END $$
DELIMITER ;

SELECT emp_name, WorkingDays(joining_date) AS DaysWorked
FROM Employees;

-- 39 Total number of orders for a customer
DELIMITER $$
CREATE FUNCTION TotalOrders(customer_id INT)
RETURNS INT
DETERMINISTIC
BEGIN
  DECLARE total INT;
  SELECT COUNT(*) INTO total FROM Orders WHERE customer_id = customer_id;
  RETURN total;
END $$
DELIMITER ;

SELECT customer_id, TotalOrders(customer_id) AS OrderCount
FROM Customers;

-- 40 Eligible for bonus
DELIMITER $$
CREATE FUNCTION IsEligibleForBonus(salary DECIMAL(10,2))
RETURNS BOOLEAN
DETERMINISTIC
BEGIN
  RETURN salary > 60000;
END $$
DELIMITER ;

SELECT emp_name, salary, IsEligibleForBonus(salary) AS BonusEligible
FROM Employees;

SHOW FUNCTION STATUS WHERE Db = 'CompanyDB';

SHOW CREATE FUNCTION EmployeeCount;