USE CompanyDB;
-- 41  AFTER INSERT trigger to log new employees
DELIMITER $$
CREATE TRIGGER trg_AfterInsertEmployee
AFTER INSERT ON Employees
FOR EACH ROW
BEGIN
  INSERT INTO Employee_Audit(emp_id, action)
  VALUES (NEW.emp_id, 'INSERT');
END $$
DELIMITER ;

-- 42.	Create an AFTER INSERT trigger on Employees to log new entries into Employee_Audit.
INSERT INTO Employees (emp_name, dept_id, salary, status, joining_date)
VALUES ('Test Insert Trigger', 1, 50000, 'Active', CURDATE());

-- 43.	Insert a new employee and verify the audit table is updated.
SELECT * FROM Employee_Audit WHERE emp_id = LAST_INSERT_ID();

-- 44 BEFORE UPDATE to prevent salary decrease
DELIMITER $$
CREATE TRIGGER trg_PreventSalaryDecrease
BEFORE UPDATE ON Employees
FOR EACH ROW
BEGIN
  IF NEW.salary < OLD.salary THEN
    SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Salary decrease not allowed!';
  END IF;
END $$
DELIMITER ;

UPDATE Employees SET salary = salary - 1000 WHERE emp_id = 1;

UPDATE Employees SET salary = salary + 1000 WHERE emp_id = 1;

-- 45 Update and verify
UPDATE Employees SET salary = salary - 5000 WHERE emp_id = 2;

-- 46  AFTER DELETE log to backup
DELIMITER $$
CREATE TRIGGER trg_AfterDeleteEmployee
AFTER DELETE ON Employees
FOR EACH ROW
BEGIN
  INSERT INTO DeletedEmployees(emp_id)
  VALUES (OLD.emp_id);
END $$
DELIMITER ;

DELETE FROM Employees WHERE emp_id = 4;

SELECT * FROM DeletedEmployees WHERE emp_id = 4;

-- 47 AFTER UPDATE: update LastModified column
ALTER TABLE Employees ADD COLUMN LastModified DATETIME;

DELIMITER $$
CREATE TRIGGER trg_AfterUpdateEmployee
AFTER UPDATE ON Employees
FOR EACH ROW
BEGIN
  UPDATE Employees SET LastModified = NOW() WHERE emp_id = NEW.emp_id;
END $$
DELIMITER ;

UPDATE Employees SET salary = salary + 1000 WHERE emp_id = 1;

SELECT emp_id, LastModified FROM Employees WHERE emp_id = 1;

-- 48 Insert default roles for new user
DELIMITER $$
CREATE TRIGGER trg_AfterInsertUser
AFTER INSERT ON Users
FOR EACH ROW
BEGIN
  INSERT INTO UserRoles (user_id, role)
  VALUES (NEW.user_id, 'user');
END $$
DELIMITER ;

INSERT INTO Users (username) VALUES ('new_user');

SELECT * FROM UserRoles WHERE user_id = LAST_INSERT_ID();

-- 49 Drop a trigger
DROP TRIGGER IF EXISTS trg_AfterInsertEmployee;

SHOW TRIGGERS LIKE 'Employees';

-- 50  Complex: prevent deletion if assigned to active projects
DELIMITER $$
CREATE TRIGGER trg_PreventDeleteAssignedEmployee
BEFORE DELETE ON Employees
FOR EACH ROW
BEGIN
  IF EXISTS (
    SELECT 1 FROM Projects WHERE emp_id = OLD.emp_id AND status = 'Active'
  ) THEN
    SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Cannot delete employee assigned to active projects.';
  END IF;
END $$
DELIMITER ;

DELETE FROM Employees WHERE emp_id = 1;


SELECT * FROM Projects WHERE emp_id = 1;

SHOW TRIGGERS;

SHOW CREATE TRIGGER trg_AfterInsertEmployee;