-- Create the database
CREATE DATABASE GymManagementDB;

-- Use the database
USE GymManagementDB;

-- creating tables
CREATE TABLE MembershipTypes (
    MembershipTypeID INT AUTO_INCREMENT PRIMARY KEY,
    TypeName VARCHAR(50) NOT NULL,
    DurationMonths INT,
    Price DECIMAL(10,2)
);

CREATE TABLE Members (
    MemberID INT AUTO_INCREMENT PRIMARY KEY,
    Name VARCHAR(100) NOT NULL,
    JoinDate DATE,
    MembershipTypeID INT,
    MembershipExpiry DATE,
    FOREIGN KEY (MembershipTypeID) REFERENCES MembershipTypes(MembershipTypeID)
);

CREATE TABLE Payments (
    PaymentID INT AUTO_INCREMENT PRIMARY KEY,
    MemberID INT,
    Amount DECIMAL(10,2),
    PaymentDate DATE,
    FOREIGN KEY (MemberID) REFERENCES Members(MemberID)
);

-- inserting data
INSERT INTO MembershipTypes (TypeName, DurationMonths, Price) 
VALUES 
('Monthly', 1, 50.00),
('Quarterly', 3, 135.00),
('Yearly', 12, 480.00);

INSERT INTO Members (Name, JoinDate, MembershipTypeID, MembershipExpiry) 
VALUES 
('Alice', '2025-04-01', 1, '2025-05-01'),
('Bob', '2025-01-15', 3, '2026-01-15'),
('Charlie', '2025-03-01', 2, '2025-06-01'),
('David', '2025-02-10', 1, '2025-03-10'),
('Eva', '2025-05-01', 1, '2025-06-01');

INSERT INTO Payments (MemberID, Amount, PaymentDate) VALUES 
(1, 50.00, '2025-04-01'),
(2, 480.00, '2025-01-15'),
(3, 135.00, '2025-03-01'),
(4, 50.00, '2025-02-10'),
(5, 50.00, '2025-05-01');

-- Query members with expired memberships.
SELECT 
    MemberID,
    Name,
    MembershipExpiry
FROM 
    Members
WHERE 
    MembershipExpiry < CURDATE();

-- List members who haven’t made a payment in the last month.
SELECT 
    m.MemberID,
    m.Name
FROM 
    Members m
LEFT JOIN 
    Payments p ON m.MemberID = p.MemberID
GROUP BY 
    m.MemberID, m.Name
HAVING 
    MAX(p.PaymentDate) < DATE_SUB(CURDATE(), INTERVAL 1 MONTH)
    OR MAX(p.PaymentDate) IS NULL;
