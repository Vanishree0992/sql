CREATE DATABASE service_center;
USE service_center;

CREATE TABLE Customers (
  customer_id INT PRIMARY KEY AUTO_INCREMENT,
  customer_name VARCHAR(100),
  email VARCHAR(100)
);

-- Technicians table
CREATE TABLE Technicians (
  technician_id INT PRIMARY KEY AUTO_INCREMENT,
  technician_name VARCHAR(100),
  specialization VARCHAR(100)
);

CREATE TABLE ServiceRequests (
  request_id INT PRIMARY KEY AUTO_INCREMENT,
  customer_id INT,
  technician_id INT,
  request_date DATETIME,
  status VARCHAR(20) DEFAULT 'Open',
  description VARCHAR(255),
  FOREIGN KEY (customer_id) REFERENCES Customers(customer_id),
  FOREIGN KEY (technician_id) REFERENCES Technicians(technician_id)
);

CREATE TABLE Service_Audit (
  audit_id INT PRIMARY KEY AUTO_INCREMENT,
  request_id INT,
  status VARCHAR(20),
  audit_date DATETIME DEFAULT CURRENT_TIMESTAMP
);

INSERT INTO Technicians (technician_name, specialization) VALUES
('Alice', 'Electrical'),
('Bob', 'Mechanical'),
('Charlie', 'Software');

INSERT INTO Customers (customer_name, email) VALUES
('John Doe', 'john@example.com'),
('Jane Smith', 'jane@example.com'),
('Michael Brown', 'michael@example.com');

INSERT INTO ServiceRequests (customer_id, technician_id, request_date, status, description) VALUES
(1, 1, '2025-07-10 08:00:00', 'Open', 'Battery issue'),
(1, 2, '2025-07-10 09:00:00', 'Open', 'Engine noise'),
(2, 2, '2025-07-10 10:00:00', 'Open', 'Brake pads replacement'),
(2, 1, '2025-07-10 11:00:00', 'Closed', 'Oil change'),
(3, 3, '2025-07-10 12:00:00', 'Open', 'Software update'),
(1, 3, '2025-07-11 08:00:00', 'Closed', 'Diagnostics'),
(1, 2, '2025-07-11 09:00:00', 'Open', 'Suspension check'),
(2, 1, '2025-07-11 10:00:00', 'Closed', 'Battery replacement'),
(2, 2, '2025-07-11 11:00:00', 'Open', 'Alignment'),
(3, 3, '2025-07-11 12:00:00', 'Open', 'Software patch'),
(1, 1, '2025-07-12 08:00:00', 'Open', 'Battery test'),
(1, 2, '2025-07-12 09:00:00', 'Open', 'Engine tuneup'),
(2, 2, '2025-07-12 10:00:00', 'Closed', 'Brake fluid change'),
(2, 1, '2025-07-12 11:00:00', 'Closed', 'Oil filter replacement'),
(3, 3, '2025-07-12 12:00:00', 'Open', 'Software configuration'),
(1, 3, '2025-07-13 08:00:00', 'Open', 'System diagnostics'),
(1, 2, '2025-07-13 09:00:00', 'Open', 'Transmission check'),
(2, 1, '2025-07-13 10:00:00', 'Open', 'Battery replacement'),
(2, 2, '2025-07-13 11:00:00', 'Open', 'Tire rotation'),
(3, 3, '2025-07-13 12:00:00', 'Closed', 'Software update');

-- View: Open vs Closed Service Requests
CREATE VIEW vw_service_request_status AS
SELECT 
  request_id,
  customer_id,
  technician_id,
  request_date,
  status,
  description
FROM ServiceRequests;
SELECT * FROM vw_service_request_status;

--  Stored Procedure: Assign a Technician
DELIMITER $$

CREATE PROCEDURE AssignTechnician(
  IN p_request_id INT,
  IN p_technician_id INT
)
BEGIN
  UPDATE ServiceRequests
  SET technician_id = p_technician_id
  WHERE request_id = p_request_id;
END$$

DELIMITER ;
CALL AssignTechnician(1, 2);


-- Function: Calculate Time Since Request
DELIMITER $$

CREATE FUNCTION GetHoursSinceRequest(p_request_id INT)
RETURNS INT
DETERMINISTIC
BEGIN
  DECLARE v_hours INT;

  SELECT TIMESTAMPDIFF(HOUR, request_date, NOW()) INTO v_hours
  FROM ServiceRequests
  WHERE request_id = p_request_id;

  RETURN v_hours;
END$$

DELIMITER ;

SELECT GetHoursSinceRequest(1) AS HoursElapsed;

-- Trigger: Log completion into Service_Audit
DELIMITER $$

CREATE TRIGGER trg_log_service_completion
AFTER UPDATE ON ServiceRequests
FOR EACH ROW
BEGIN
  IF OLD.status = 'Open' AND NEW.status = 'Closed' THEN
    INSERT INTO Service_Audit (request_id, status)
    VALUES (NEW.request_id, 'Closed');
  END IF;
END$$

DELIMITER ;
UPDATE ServiceRequests SET status = 'Closed' WHERE request_id = 1;

SELECT * FROM Service_Audit;

-- Secure Views: No customer access to Service_Audit
CREATE VIEW vw_customer_service_requests AS
SELECT
  request_id,
  request_date,
  status,
  description
FROM ServiceRequests
WHERE customer_id = 1;
SELECT * FROM vw_customer_service_requests;