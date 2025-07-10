USE CompanyDB;
-- 16 Create the procedure
DELIMITER $$
CREATE PROCEDURE GetAllEmployees()
BEGIN
  SELECT * FROM Employees;
END $$
DELIMITER ;

-- 17 Call it & view output
CALL GetAllEmployees();

-- 18 Create the procedure
DELIMITER $$
CREATE PROCEDURE GetEmployeesByDept(IN dept_name VARCHAR(50))
BEGIN
  SELECT e.*
  FROM Employees e
  JOIN Departments d ON e.dept_id = d.dept_id
  WHERE d.dept_name = dept_name;
END $$
DELIMITER ;

-- 19 Call it & view output
CALL GetEmployeesByDept('HR');

-- 20 Insert a new employee
DELIMITER $$
CREATE PROCEDURE InsertEmployee(
  IN p_emp_name VARCHAR(50),
  IN p_dept_id INT,
  IN p_salary DECIMAL(10,2),
  IN p_status VARCHAR(20)
)
BEGIN
  INSERT INTO Employees(emp_name, dept_id, salary, status, joining_date)
  VALUES (p_emp_name, p_dept_id, p_salary, p_status, CURDATE());
END $$
DELIMITER ;

CALL InsertEmployee('Victor Hugo', 1, 59000, 'Active');

SELECT * FROM Employees WHERE emp_name = 'Victor Hugo';

-- 21 Delete an employee by ID
DELIMITER $$
CREATE PROCEDURE DeleteEmployee(IN p_emp_id INT)
BEGIN
  DELETE FROM Employees WHERE emp_id = p_emp_id;
END $$
DELIMITER ;

CALL DeleteEmployee(3);

SELECT * FROM Employees WHERE emp_id = 3;

-- 22 Update salary
DELIMITER $$
CREATE PROCEDURE UpdateSalary(IN p_emp_id INT, IN p_new_salary DECIMAL(10,2))
BEGIN
  UPDATE Employees SET salary = p_new_salary WHERE emp_id = p_emp_id;
END $$
DELIMITER ;
CALL UpdateSalary(1, 60000);
SELECT * FROM Employees WHERE emp_id = 1;

-- 23: Get total employees with OUT
DELIMITER $$
CREATE PROCEDURE GetEmployeeCount(OUT total INT)
BEGIN
  SELECT COUNT(*) INTO total FROM Employees;
END $$
DELIMITER ;

CALL GetEmployeeCount(@total);

SELECT @total AS TotalEmployees;

-- 24 Modify procedure
DROP PROCEDURE IF EXISTS GetAllEmployees;
DELIMITER $$
CREATE PROCEDURE GetAllEmployees()
BEGIN
  SELECT emp_id, emp_name FROM Employees;
END $$
DELIMITER ;

CALL GetAllEmployees();

-- 25 Name starts with letter
DELIMITER $$
CREATE PROCEDURE GetEmployeesByInitial(IN initial CHAR(1))
BEGIN
  SELECT * FROM Employees WHERE emp_name LIKE CONCAT(initial, '%');
END $$
DELIMITER ;

CALL GetEmployeesByInitial('A');

-- 26 Average salary per department
DELIMITER $$
CREATE PROCEDURE AvgSalaryPerDept()
BEGIN
  SELECT d.dept_name, AVG(e.salary) AS avg_salary
  FROM Employees e
  JOIN Departments d ON e.dept_id = d.dept_id
  GROUP BY d.dept_name;
END $$
DELIMITER ;

CALL AvgSalaryPerDept();

-- 27 Count employees by department
DELIMITER $$
CREATE PROCEDURE CountEmployeesByDept()
BEGIN
  SELECT d.dept_name, COUNT(e.emp_id) AS emp_count
  FROM Employees e
  JOIN Departments d ON e.dept_id = d.dept_id
  GROUP BY d.dept_name;
END $$
DELIMITER ;
CALL CountEmployeesByDept();

-- 28 Employees joined this month
DELIMITER $$
CREATE PROCEDURE EmployeesJoinedThisMonth()
BEGIN
  SELECT * FROM Employees
  WHERE MONTH(joining_date) = MONTH(CURDATE()) AND YEAR(joining_date) = YEAR(CURDATE());
END $$
DELIMITER ;

CALL EmployeesJoinedThisMonth();

-- 29 Multi-query procedure
DELIMITER $$
CREATE PROCEDURE LogAndGetEmployees()
BEGIN
  INSERT INTO LogTable(action) VALUES ('Fetch Employees');
  SELECT * FROM Employees;
END $$
DELIMITER ;

CALL LogAndGetEmployees();

SELECT * FROM LogTable;

--  30 Use in transaction with rollback
START TRANSACTION;

CALL InsertEmployee('Rollback Test', 2, 50000, 'Active');

ROLLBACK;

SELECT * FROM Employees WHERE emp_name = 'Rollback Test';
