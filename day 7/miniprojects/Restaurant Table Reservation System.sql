CREATE DATABASE restaurent_table;
USE restaurent_table;

CREATE TABLE Tables (
  table_id INT PRIMARY KEY AUTO_INCREMENT,
  table_number INT,
  capacity INT,
  status VARCHAR(20) DEFAULT 'Available'
);

CREATE TABLE Reservations (
  reservation_id INT PRIMARY KEY AUTO_INCREMENT,
  table_id INT,
  customer_name VARCHAR(100),
  reservation_date DATE,
  reservation_time TIME,
  status VARCHAR(20) DEFAULT 'Booked',
  FOREIGN KEY (table_id) REFERENCES Tables(table_id)
);

CREATE TABLE Reservation_Audit (
  audit_id INT PRIMARY KEY AUTO_INCREMENT,
  reservation_id INT,
  table_id INT,
  action VARCHAR(50),
  audit_date DATETIME DEFAULT CURRENT_TIMESTAMP
);

INSERT INTO Tables (table_number, capacity) VALUES
(1, 2), (2, 2), (3, 4), (4, 4), (5, 4),
(6, 6), (7, 6), (8, 8), (9, 8), (10, 10);

INSERT INTO Reservations (table_id, customer_name, reservation_date, reservation_time) VALUES
(1, 'Alice', '2025-07-11', '18:00:00'),
(2, 'Bob', '2025-07-11', '18:30:00'),
(3, 'Charlie', '2025-07-11', '19:00:00'),
(4, 'David', '2025-07-11', '19:30:00'),
(5, 'Eve', '2025-07-11', '20:00:00'),
(6, 'Frank', '2025-07-11', '20:30:00'),
(7, 'Grace', '2025-07-11', '21:00:00'),
(8, 'Heidi', '2025-07-11', '21:30:00'),
(9, 'Ivan', '2025-07-11', '22:00:00'),
(10,'Judy', '2025-07-11', '22:30:00'),
(1, 'Alice', '2025-07-12', '18:00:00'),
(2, 'Bob', '2025-07-12', '18:30:00'),
(3, 'Charlie', '2025-07-12', '19:00:00'),
(4, 'David', '2025-07-12', '19:30:00'),
(5, 'Eve', '2025-07-12', '20:00:00'),
(6, 'Frank', '2025-07-12', '20:30:00'),
(7, 'Grace', '2025-07-12', '21:00:00'),
(8, 'Heidi', '2025-07-12', '21:30:00'),
(9, 'Ivan', '2025-07-12', '22:00:00'),
(10,'Judy', '2025-07-12', '22:30:00');

-- View: Show available tables for a given time slot
CREATE VIEW vw_available_tables AS
SELECT 
  t.table_id,
  t.table_number,
  t.capacity
FROM Tables t
WHERE t.status = 'Available';
SELECT * FROM vw_available_tables;
SELECT CheckAvailability(1, '2025-07-13', '18:00:00') AS IsAvailable;


-- Stored Procedure: Reserve a table
DELIMITER $$

CREATE PROCEDURE ReserveTable(
  IN p_table_id INT,
  IN p_customer_name VARCHAR(100),
  IN p_date DATE,
  IN p_time TIME
)
BEGIN
  INSERT INTO Reservations (table_id, customer_name, reservation_date, reservation_time)
  VALUES (p_table_id, p_customer_name, p_date, p_time);
  
  -- Update table status
  UPDATE Tables SET status = 'Reserved' WHERE table_id = p_table_id;
END$$

DELIMITER ;
CALL ReserveTable(1, 'NewCustomer', '2025-07-13', '18:00:00');


-- Function: Check table availability
DELIMITER $$

CREATE FUNCTION CheckAvailability(p_table_id INT, p_date DATE, p_time TIME)
RETURNS BOOLEAN
DETERMINISTIC
BEGIN
  DECLARE v_count INT;

  SELECT COUNT(*)
  INTO v_count
  FROM Reservations
  WHERE table_id = p_table_id AND reservation_date = p_date AND reservation_time = p_time AND status = 'Booked';

  RETURN v_count = 0;
END$$

DELIMITER ;


-- Trigger: Auto-update table status
DELIMITER $$

CREATE TRIGGER trg_update_table_status
AFTER INSERT ON Reservations
FOR EACH ROW
BEGIN
  UPDATE Tables SET status = 'Reserved' WHERE table_id = NEW.table_id;
END$$

DELIMITER ;
SELECT * FROM Tables WHERE table_id = 1;

-- Trigger: Log reservation cancellation
DELIMITER $$

CREATE TRIGGER trg_log_cancellation
AFTER UPDATE ON Reservations
FOR EACH ROW
BEGIN
  IF OLD.status = 'Booked' AND NEW.status = 'Cancelled' THEN
    INSERT INTO Reservation_Audit (reservation_id, table_id, action)
    VALUES (NEW.reservation_id, NEW.table_id, 'Cancelled');
    
    -- Mark table as available again
    UPDATE Tables SET status = 'Available' WHERE table_id = NEW.table_id;
  END IF;
END$$

DELIMITER ;
UPDATE Reservations SET status = 'Cancelled' WHERE reservation_id = 1;

SELECT * FROM Reservation_Audit;