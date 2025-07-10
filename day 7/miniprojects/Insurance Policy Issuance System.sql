CREATE DATABASE insurance_policy;
USE insurance_policy; 

-- Customers table
CREATE TABLE Customers (
  customer_id INT PRIMARY KEY AUTO_INCREMENT,
  customer_name VARCHAR(100),
  email VARCHAR(100)
);

-- Policies table
CREATE TABLE Policies (
  policy_id INT PRIMARY KEY AUTO_INCREMENT,
  customer_id INT,
  policy_type VARCHAR(100),
  coverage_amount DECIMAL(12,2),
  status VARCHAR(20) DEFAULT 'Active',
  terms TEXT,
  issue_date DATETIME DEFAULT CURRENT_TIMESTAMP,
  FOREIGN KEY (customer_id) REFERENCES Customers(customer_id)
);

-- PolicyAudit table
CREATE TABLE PolicyAudit (
  audit_id INT PRIMARY KEY AUTO_INCREMENT,
  policy_id INT,
  action VARCHAR(50),
  changed_at DATETIME DEFAULT CURRENT_TIMESTAMP,
  old_terms TEXT,
  new_terms TEXT
);


-- Insert customers
INSERT INTO Customers (customer_name, email) VALUES
('Alice', 'alice@example.com'),
('Bob', 'bob@example.com'),
('Charlie', 'charlie@example.com'),
('David', 'david@example.com'),
('Eve', 'eve@example.com');

-- Insert policies (>20 policies)
INSERT INTO Policies (customer_id, policy_type, coverage_amount, status, terms) VALUES
(1, 'Health', 100000, 'Active', 'Standard health coverage'),
(1, 'Auto', 50000, 'Active', 'Full auto coverage'),
(1, 'Life', 200000, 'Lapsed', 'Life insurance coverage'),
(2, 'Health', 80000, 'Active', 'Basic health coverage'),
(2, 'Auto', 45000, 'Active', 'Basic auto coverage'),
(3, 'Health', 120000, 'Active', 'Extended health coverage'),
(3, 'Home', 300000, 'Active', 'Home insurance'),
(4, 'Health', 90000, 'Active', 'Family health coverage'),
(4, 'Travel', 25000, 'Active', 'Travel insurance'),
(4, 'Life', 180000, 'Active', 'Life coverage'),
(5, 'Auto', 40000, 'Active', 'Comprehensive auto plan'),
(5, 'Home', 350000, 'Active', 'Premium home insurance'),
(1, 'Travel', 30000, 'Active', 'Holiday travel insurance'),
(2, 'Life', 150000, 'Lapsed', 'Life policy'),
(2, 'Home', 250000, 'Active', 'House policy'),
(3, 'Auto', 55000, 'Active', 'Auto plus plan'),
(3, 'Travel', 20000, 'Active', 'Basic travel'),
(4, 'Auto', 42000, 'Active', 'Auto coverage'),
(4, 'Home', 280000, 'Active', 'Home standard'),
(5, 'Health', 110000, 'Active', 'Individual health');

CREATE VIEW vw_customer_policy_status AS
SELECT 
  policy_id,
  customer_id,
  policy_type,
  coverage_amount,
  status,
  issue_date
FROM Policies;

DELIMITER $$

CREATE PROCEDURE IssuePolicy(
  IN p_customer_id INT,
  IN p_policy_type VARCHAR(100),
  IN p_coverage_amount DECIMAL(12,2),
  IN p_terms TEXT
)
BEGIN
  INSERT INTO Policies (customer_id, policy_type, coverage_amount, terms)
  VALUES (p_customer_id, p_policy_type, p_coverage_amount, p_terms);
END$$

DELIMITER ;

DELIMITER $$

CREATE FUNCTION GetActivePolicies(p_customer_id INT)
RETURNS INT
DETERMINISTIC
BEGIN
  DECLARE v_count INT;

  SELECT COUNT(*)
  INTO v_count
  FROM Policies
  WHERE customer_id = p_customer_id AND status = 'Active';

  RETURN v_count;
END$$

DELIMITER ;


DELIMITER $$

CREATE TRIGGER trg_log_policy_change
AFTER UPDATE ON Policies
FOR EACH ROW
BEGIN
  IF OLD.terms <> NEW.terms THEN
    INSERT INTO PolicyAudit (policy_id, action, old_terms, new_terms)
    VALUES (NEW.policy_id, 'Terms Updated', OLD.terms, NEW.terms);
  END IF;
END$$

DELIMITER ;


CREATE VIEW vw_underwriter_policy_details AS
SELECT
  p.policy_id,
  c.customer_name,
  p.policy_type,
  p.coverage_amount,
  p.status,
  p.terms,
  p.issue_date
FROM Policies p
JOIN Customers c ON p.customer_id = c.customer_id;

SELECT * FROM vw_customer_policy_status WHERE customer_id = 1;

SELECT * FROM vw_underwriter_policy_details WHERE customer_id = 1;

CALL IssuePolicy(1, 'Pet', 25000, 'Pet insurance terms and conditions');

SELECT GetActivePolicies(1) AS ActivePolicies;

UPDATE Policies SET terms = 'Updated terms and conditions' WHERE policy_id = 1;
SELECT * FROM PolicyAudit;
