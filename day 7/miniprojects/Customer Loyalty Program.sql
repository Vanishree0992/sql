CREATE DATABASE customer_loyalty;
USE customer_loyalty;

CREATE TABLE Customers (
  customer_id INT PRIMARY KEY AUTO_INCREMENT,
  customer_name VARCHAR(100),
  email VARCHAR(100)
);

CREATE TABLE Purchases (
  purchase_id INT PRIMARY KEY AUTO_INCREMENT,
  customer_id INT,
  purchase_date DATE,
  amount DECIMAL(10,2),
  FOREIGN KEY (customer_id) REFERENCES Customers(customer_id)
);

CREATE TABLE LoyaltyPoints (
  customer_id INT PRIMARY KEY,
  points INT DEFAULT 0,
  loyalty_level VARCHAR(20)
);

CREATE TABLE LoyaltyAudit (
  audit_id INT PRIMARY KEY AUTO_INCREMENT,
  customer_id INT,
  old_points INT,
  new_points INT,
  updated_at DATETIME DEFAULT CURRENT_TIMESTAMP
);

INSERT INTO Customers (customer_name, email) VALUES
('Alice', 'alice@example.com'),
('Bob', 'bob@example.com'),
('Charlie', 'charlie@example.com'),
('David', 'david@example.com'),
('Eve', 'eve@example.com'),
('Frank', 'frank@example.com'),
('Grace', 'grace@example.com'),
('Heidi', 'heidi@example.com'),
('Ivan', 'ivan@example.com'),
('Judy', 'judy@example.com');

INSERT INTO LoyaltyPoints (customer_id, points, loyalty_level) VALUES
(1, 500, 'Silver'), (2, 2000, 'Gold'), (3, 1500, 'Gold'),
(4, 700, 'Silver'), (5, 300, 'Bronze'),
(6, 100, 'Bronze'), (7, 1200, 'Gold'), (8, 50, 'Bronze'),
(9, 800, 'Silver'), (10, 2500, 'Platinum');

INSERT INTO Purchases (customer_id, purchase_date, amount) VALUES
(1, '2025-07-01', 100), (2, '2025-07-02', 250),
(3, '2025-07-03', 150), (4, '2025-07-04', 50),
(5, '2025-07-05', 30), (6, '2025-07-06', 20),
(7, '2025-07-07', 200), (8, '2025-07-08', 15),
(9, '2025-07-09', 90), (10,'2025-07-10', 400),
(1, '2025-07-11', 60), (2, '2025-07-12', 100),
(3, '2025-07-13', 250), (4, '2025-07-14', 30),
(5, '2025-07-15', 70), (6, '2025-07-16', 50),
(7, '2025-07-17', 80), (8, '2025-07-18', 20),
(9, '2025-07-19', 120), (10,'2025-07-20', 300);

-- Function: Calculate loyalty level
DELIMITER $$

CREATE FUNCTION GetLoyaltyLevel(p_points INT)
RETURNS VARCHAR(20)
DETERMINISTIC
BEGIN
  DECLARE level VARCHAR(20);

  IF p_points >= 2000 THEN
    SET level = 'Platinum';
  ELSEIF p_points >= 1000 THEN
    SET level = 'Gold';
  ELSEIF p_points >= 500 THEN
    SET level = 'Silver';
  ELSE
    SET level = 'Bronze';
  END IF;

  RETURN level;
END$$

DELIMITER ;
SELECT * FROM vw_loyalty_summary;

-- View: Customer points & level
CREATE OR REPLACE VIEW vw_loyalty_summary AS
SELECT 
  c.customer_id,
  c.customer_name,
  l.points,
  l.loyalty_level
FROM Customers c
JOIN LoyaltyPoints l ON c.customer_id = l.customer_id;


-- Stored Procedure: Update loyalty points after purchase
DELIMITER $$

CREATE PROCEDURE UpdateLoyaltyPoints(IN p_customer_id INT, IN p_amount DECIMAL(10,2))
BEGIN
  DECLARE v_old_points INT;
  DECLARE v_new_points INT;
  DECLARE v_new_level VARCHAR(20);

  SELECT points INTO v_old_points FROM LoyaltyPoints WHERE customer_id = p_customer_id;

  SET v_new_points = v_old_points + p_amount;
  SET v_new_level = GetLoyaltyLevel(v_new_points);

  UPDATE LoyaltyPoints 
  SET points = v_new_points, loyalty_level = v_new_level
  WHERE customer_id = p_customer_id;
END$$

DELIMITER ;
CALL UpdateLoyaltyPoints(1, 150);

-- Trigger: Log every loyalty update
DELIMITER $$

CREATE TRIGGER trg_log_loyalty_update
AFTER UPDATE ON LoyaltyPoints
FOR EACH ROW
BEGIN
  IF OLD.points != NEW.points THEN
    INSERT INTO LoyaltyAudit (customer_id, old_points, new_points)
    VALUES (NEW.customer_id, OLD.points, NEW.points);
  END IF;
END$$

DELIMITER ;
SELECT * FROM LoyaltyAudit;
SELECT GetLoyaltyLevel(2500) AS Level;

-- Drop & recreate views (when rules change)
DROP VIEW IF EXISTS vw_loyalty_summary;

CREATE OR REPLACE VIEW vw_loyalty_summary AS
SELECT 
  c.customer_id,
  c.customer_name,
  l.points,
  l.loyalty_level
FROM Customers c
JOIN LoyaltyPoints l ON c.customer_id = l.customer_id;

SELECT * FROM vw_loyalty_summary;