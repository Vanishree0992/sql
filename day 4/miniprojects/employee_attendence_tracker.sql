CREATE DATABASE Attendance_DB;
USE Attendance_DB;

CREATE TABLE Employees (
  emp_id INT PRIMARY KEY AUTO_INCREMENT,
  emp_name VARCHAR(100) NOT NULL,
  department VARCHAR(100)
);

CREATE TABLE Attendance (
  attendance_id INT PRIMARY KEY AUTO_INCREMENT,
  emp_id INT NOT NULL,
  attendance_date DATE NOT NULL,
  check_in_time TIME NOT NULL,
  check_out_time TIME,
  FOREIGN KEY (emp_id) REFERENCES Employees(emp_id) ON DELETE CASCADE,
  CHECK (check_out_time IS NULL OR check_out_time >= check_in_time) -- ✅ Valid check-out
);

INSERT INTO Employees (emp_name, department)
VALUES 
  ('Alice Worker', 'HR'),
  ('Bob Manager', 'IT');

-- •	Use transactions to insert multiple employees' attendance at once.
START TRANSACTION;

INSERT INTO Attendance (emp_id, attendance_date, check_in_time, check_out_time)
VALUES (1, '2025-07-05', '09:00:00', '17:00:00');

INSERT INTO Attendance (emp_id, attendance_date, check_in_time, check_out_time)
VALUES (2, '2025-07-05', '09:30:00', '18:00:00');

COMMIT;

-- •	Update records if employee corrects check-out.
UPDATE Attendance
SET check_out_time = '17:30:00'
WHERE attendance_id = 1 AND attendance_id > 0;

-- •	Delete invalid entries.
DELETE FROM Attendance
WHERE check_out_time < check_in_time
  AND attendance_id > 0; 


SELECT * FROM Employees;
SELECT * FROM Attendance;