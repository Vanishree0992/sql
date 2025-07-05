CREATE DATABASE NGODB;
USE NGODB;

CREATE TABLE Donors (
  donor_id INT PRIMARY KEY AUTO_INCREMENT,
  donor_name VARCHAR(100) NOT NULL,
  email VARCHAR(100) UNIQUE,
  last_donation_date DATE
);

CREATE TABLE Donations (
  donation_id INT PRIMARY KEY AUTO_INCREMENT,
  donor_id INT NOT NULL,
  donation_date DATETIME DEFAULT CURRENT_TIMESTAMP, -- ✅ Use DATETIME instead of DATE
  purpose VARCHAR(255),
  amount DECIMAL(10, 2) NOT NULL CHECK (amount > 0),
  FOREIGN KEY (donor_id) REFERENCES Donors(donor_id) ON DELETE CASCADE
);

-- •	Use transactions for pledge and donation recording.
START TRANSACTION;

INSERT INTO Donors (donor_name, email, last_donation_date)
VALUES ('Alice Generous', 'alice@ngo.org', CURDATE());

SET @donor_id = LAST_INSERT_ID();

INSERT INTO Donations (donor_id, purpose, amount)
VALUES (@donor_id, 'Education Fund', 100.00);

UPDATE Donors
SET last_donation_date = CURDATE()
WHERE donor_id = @donor_id;

COMMIT;

-- •	Update donation purpose or amount.
UPDATE Donations
SET amount = 150.00, purpose = 'Health Fund'
WHERE donation_id = 1 AND donation_id > 0;

-- •	Delete old donors if inactive.
DELETE FROM Donors
WHERE last_donation_date < DATE_SUB(CURDATE(), INTERVAL 2 YEAR)
  AND donor_id > 0; 


SELECT * FROM Donors;
SELECT * FROM Donations;