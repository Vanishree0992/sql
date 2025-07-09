-- Create the database
CREATE DATABASE ngo_database;

-- Use it
USE ngo_database;
CREATE TABLE Donors (
  donor_id INT AUTO_INCREMENT PRIMARY KEY,
  donor_name VARCHAR(100),
  email VARCHAR(100)
);

-- Sample donors
INSERT INTO Donors (donor_name, email) VALUES
('Alice Johnson', 'alice@example.org'),
('Bob Smith', 'bob@example.org'),
('Charlie Lee', 'charlie@example.org'),
('Diana Prince', 'diana@example.org'),
('Eve Adams', 'eve@example.org');

CREATE TABLE Campaigns (
  campaign_id INT AUTO_INCREMENT PRIMARY KEY,
  campaign_name VARCHAR(100),
  goal_amount DECIMAL(12,2)
);

-- Sample campaigns
INSERT INTO Campaigns (campaign_name, goal_amount) VALUES
('School Supplies Drive', 5000),
('Healthcare Fundraiser', 10000),
('Community Kitchen', 7000);

CREATE TABLE Donations (
  donation_id INT AUTO_INCREMENT PRIMARY KEY,
  donor_id INT,
  campaign_id INT,
  donation_date DATE,
  amount DECIMAL(10,2),
  FOREIGN KEY (donor_id) REFERENCES Donors(donor_id),
  FOREIGN KEY (campaign_id) REFERENCES Campaigns(campaign_id)
);

-- Sample donations
INSERT INTO Donations (donor_id, campaign_id, donation_date, amount) VALUES
(1, 1, '2024-06-01', 100),
(1, 2, '2024-06-10', 200),
(2, 1, '2024-06-15', 150),
(3, 2, '2024-06-20', 250),
(4, 3, '2024-06-25', 300),
(5, 1, '2024-07-01', 120),
(5, 3, '2024-07-02', 180),
(2, 3, '2024-07-03', 220);


CREATE INDEX idx_donor_name ON Donors(donor_name);

-- Index on campaign_id
CREATE INDEX idx_campaign_id ON Donations(campaign_id);

-- Index on donation_date
CREATE INDEX idx_donation_date ON Donations(donation_date);


EXPLAIN SELECT 
  c.campaign_name, 
  SUM(d.amount) AS total_donated
FROM Donations d
JOIN Campaigns c ON d.campaign_id = c.campaign_id
GROUP BY d.campaign_id;


CREATE TABLE CampaignDonationsSummary (
  campaign_id INT,
  campaign_name VARCHAR(100),
  total_amount DECIMAL(12,2)
);

-- Populate summary table
INSERT INTO CampaignDonationsSummary (campaign_id, campaign_name, total_amount)
SELECT 
  c.campaign_id,
  c.campaign_name,
  SUM(d.amount)
FROM Donations d
JOIN Campaigns c ON d.campaign_id = c.campaign_id
GROUP BY c.campaign_id;

-- View summary
SELECT * FROM CampaignDonationsSummary;

SELECT 
  d.donation_id, 
  dn.donor_name, 
  c.campaign_name, 
  d.donation_date, 
  d.amount
FROM Donations d
JOIN Donors dn ON d.donor_id = dn.donor_id
JOIN Campaigns c ON d.campaign_id = c.campaign_id
ORDER BY d.donation_date DESC
LIMIT 5;