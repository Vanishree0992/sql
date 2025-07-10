CREATE DATABASE leave_management;
USE leave_management;

CREATE TABLE Employees (
  emp_id INT PRIMARY KEY AUTO_INCREMENT,
  emp_name VARCHAR(100),
  team_id INT,
  team_lead_id INT
);

CREATE TABLE LeaveRequests (
  leave_id INT PRIMARY KEY AUTO_INCREMENT,
  emp_id INT,
  leave_date DATE,
  leave_days INT,
  status ENUM('Pending', 'Approved', 'Rejected') DEFAULT 'Pending',
  request_date DATETIME DEFAULT CURRENT_TIMESTAMP,
  FOREIGN KEY (emp_id) REFERENCES Employees(emp_id)
);

CREATE TABLE LeaveBalance (
  emp_id INT PRIMARY KEY,
  total_leaves INT DEFAULT 30,
  leaves_taken INT DEFAULT 0,
  leaves_remaining INT DEFAULT 30,
  FOREIGN KEY (emp_id) REFERENCES Employees(emp_id)
);

INSERT INTO Employees (emp_name, team_id, team_lead_id) VALUES
('Alice', 1, 101), ('Bob', 1, 101), ('Charlie', 1, 101), ('David', 2, 102),
('Eve', 2, 102), ('Frank', 2, 102), ('Grace', 3, 103), ('Heidi', 3, 103),
('Ivan', 3, 103), ('Judy', 3, 103), 
-- Team leads
('Lead1', 1, NULL), ('Lead2', 2, NULL), ('Lead3', 3, NULL);

INSERT INTO LeaveBalance (emp_id, total_leaves, leaves_taken, leaves_remaining) VALUES
(1, 30, 2, 28), (2, 30, 4, 26), (3, 30, 1, 29),
(4, 30, 3, 27), (5, 30, 5, 25), (6, 30, 0, 30),
(7, 30, 2, 28), (8, 30, 1, 29), (9, 30, 0, 30),
(10, 30, 2, 28), (11, 30, 0, 30), (12, 30, 0, 30), (13, 30, 0, 30);

INSERT INTO LeaveRequests (emp_id, leave_date, leave_days, status)
VALUES
(1, '2025-07-01', 1, 'Approved'), (2, '2025-07-02', 2, 'Pending'),
(3, '2025-07-03', 1, 'Approved'), (4, '2025-07-04', 1, 'Rejected'),
(5, '2025-07-05', 1, 'Pending'), (6, '2025-07-06', 2, 'Pending'),
(7, '2025-07-07', 1, 'Approved'), (8, '2025-07-08', 1, 'Pending'),
(9, '2025-07-09', 2, 'Pending'), (10, '2025-07-10', 1, 'Pending'),
(1, '2025-07-11', 1, 'Pending'), (2, '2025-07-12', 1, 'Pending'),
(3, '2025-07-13', 1, 'Pending'), (4, '2025-07-14', 2, 'Pending'),
(5, '2025-07-15', 1, 'Pending'), (6, '2025-07-16', 2, 'Pending'),
(7, '2025-07-17', 1, 'Pending'), (8, '2025-07-18', 1, 'Pending'),
(9, '2025-07-19', 1, 'Pending'), (10, '2025-07-20', 2, 'Pending');

-- Trigger: Auto-update LeaveBalance
DELIMITER $$

CREATE TRIGGER trg_update_leave_balance
AFTER INSERT ON LeaveRequests
FOR EACH ROW
BEGIN
  UPDATE LeaveBalance
  SET 
    leaves_taken = leaves_taken + NEW.leave_days,
    leaves_remaining = leaves_remaining - NEW.leave_days
  WHERE emp_id = NEW.emp_id;
END$$

DELIMITER ;
SELECT * FROM LeaveBalance;

--  View: Team leads see only their team’s leave requests
CREATE VIEW vw_team_lead_requests AS
SELECT
  lr.leave_id,
  e.emp_id,
  e.emp_name,
  e.team_id,
  lr.leave_date,
  lr.leave_days,
  lr.status
FROM LeaveRequests lr
JOIN Employees e ON lr.emp_id = e.emp_id
WHERE e.team_lead_id IS NOT NULL; 
SELECT * FROM LeaveRequests WHERE leave_id = 5;

-- Stored Procedure: Approve/Reject Leave
DELIMITER $$

CREATE PROCEDURE ApproveRejectLeave(IN p_leave_id INT, IN p_status ENUM('Approved','Rejected'))
BEGIN
  UPDATE LeaveRequests
  SET status = p_status
  WHERE leave_id = p_leave_id;
  
  -- If rejected, roll back leave balance
  IF p_status = 'Rejected' THEN
    DECLARE v_emp_id INT;
    DECLARE v_days INT;

    SELECT emp_id, leave_days INTO v_emp_id, v_days
    FROM LeaveRequests WHERE leave_id = p_leave_id;

    UPDATE LeaveBalance
    SET 
      leaves_taken = leaves_taken - v_days,
      leaves_remaining = leaves_remaining + v_days
    WHERE emp_id = v_emp_id;
  END IF;
END$$

DELIMITER ;
CALL ApproveRejectLeave(6, 'Rejected');

-- Function: Check remaining balance
DELIMITER $$

CREATE FUNCTION GetLeaveBalance(p_emp_id INT)
RETURNS INT
DETERMINISTIC
BEGIN
  DECLARE remaining INT;

  SELECT leaves_remaining INTO remaining
  FROM LeaveBalance
  WHERE emp_id = p_emp_id;

  RETURN remaining;
END$$

DELIMITER ;

