CREATE DATABASE ngo_donation;
USE ngo_donation;

CREATE TABLE Donors (
  donor_id INT PRIMARY KEY AUTO_INCREMENT,
  donor_name VARCHAR(100),
  email VARCHAR(100) -- sensitive
);

CREATE TABLE Campaigns (
  campaign_id INT PRIMARY KEY AUTO_INCREMENT,
  campaign_name VARCHAR(100),
  goal_amount DECIMAL(10,2)
);

CREATE TABLE Donations (
  donation_id INT PRIMARY KEY AUTO_INCREMENT,
  donor_id INT,
  campaign_id INT,
  donation_date DATE,
  amount DECIMAL(10,2),
  FOREIGN KEY (donor_id) REFERENCES Donors(donor_id),
  FOREIGN KEY (campaign_id) REFERENCES Campaigns(campaign_id)
);

CREATE TABLE DonationAudit (
  audit_id INT PRIMARY KEY AUTO_INCREMENT,
  donation_id INT,
  donor_id INT,
  campaign_id INT,
  amount DECIMAL(10,2),
  created_at DATETIME DEFAULT CURRENT_TIMESTAMP
);

INSERT INTO Campaigns (campaign_name, goal_amount) VALUES
('Health Support', 5000.00),
('Education Fund', 10000.00),
('Disaster Relief', 15000.00);

INSERT INTO Donors (donor_name, email) VALUES
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

INSERT INTO Donations (donor_id, campaign_id, donation_date, amount) VALUES
(1, 1, '2025-07-01', 100),
(2, 1, '2025-07-02', 200),
(3, 1, '2025-07-02', 50),
(4, 1, '2025-07-03', 75),
(5, 1, '2025-07-04', 25),
(6, 2, '2025-07-01', 500),
(7, 2, '2025-07-02', 300),
(8, 2, '2025-07-03', 250),
(9, 2, '2025-07-04', 100),
(10,2, '2025-07-04', 150),
(1, 3, '2025-07-05', 1000),
(2, 3, '2025-07-05', 500),
(3, 3, '2025-07-06', 750),
(4, 3, '2025-07-07', 300),
(5, 3, '2025-07-07', 200),
(6, 3, '2025-07-08', 50),
(7, 3, '2025-07-08', 100),
(8, 3, '2025-07-09', 200),
(9, 3, '2025-07-09', 400),
(10,3, '2025-07-10', 500);

-- View: Public campaign donation totals
CREATE VIEW vw_campaign_donation_summary AS
SELECT 
  c.campaign_id,
  c.campaign_name,
  SUM(d.amount) AS total_donated,
  c.goal_amount
FROM Campaigns c
LEFT JOIN Donations d ON c.campaign_id = d.campaign_id
GROUP BY c.campaign_id, c.campaign_name, c.goal_amount;
SELECT * FROM vw_campaign_donation_summary;

-- Stored Procedure: Register a donation
DELIMITER $$

CREATE PROCEDURE RegisterDonation(
  IN p_donor_id INT,
  IN p_campaign_id INT,
  IN p_amount DECIMAL(10,2)
)
BEGIN
  INSERT INTO Donations (donor_id, campaign_id, donation_date, amount)
  VALUES (p_donor_id, p_campaign_id, CURRENT_DATE, p_amount);
END$$

DELIMITER ;
CALL RegisterDonation(1, 1, 500);
SELECT * FROM DonationAudit;

-- unction: Total donations per donor
DELIMITER $$

CREATE FUNCTION GetDonorTotal(p_donor_id INT)
RETURNS DECIMAL(10,2)
DETERMINISTIC
BEGIN
  DECLARE v_total DECIMAL(10,2);

  SELECT SUM(amount) INTO v_total
  FROM Donations
  WHERE donor_id = p_donor_id;

  RETURN IFNULL(v_total, 0);
END$$

DELIMITER ;
SELECT GetDonorTotal(1) AS DonorTotal;

-- Trigger: Log every donation
DELIMITER $$

CREATE TRIGGER trg_log_donation
AFTER INSERT ON Donations
FOR EACH ROW
BEGIN
  INSERT INTO DonationAudit (donation_id, donor_id, campaign_id, amount)
  VALUES (NEW.donation_id, NEW.donor_id, NEW.campaign_id, NEW.amount);
END$$

DELIMITER ;

-- Secure view: Donors list (no emails)
CREATE VIEW vw_donor_public AS
SELECT donor_id, donor_name
FROM Donors;
SELECT * FROM vw_donor_public;
