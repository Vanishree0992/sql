-- Create the database
CREATE DATABASE VehicleServiceDB;

-- Use the database
USE VehicleServiceDB;

-- creating table
CREATE TABLE Customers (
    CustomerID INT AUTO_INCREMENT PRIMARY KEY,
    Name VARCHAR(100) NOT NULL,
    Email VARCHAR(100)
);

CREATE TABLE Vehicles (
    VehicleID INT AUTO_INCREMENT PRIMARY KEY,
    CustomerID INT,
    Make VARCHAR(50),
    Model VARCHAR(50),
    Year INT,
    LicensePlate VARCHAR(20),
    FOREIGN KEY (CustomerID) REFERENCES Customers(CustomerID)
);

CREATE TABLE Services (
    ServiceID INT AUTO_INCREMENT PRIMARY KEY,
    ServiceName VARCHAR(100) NOT NULL,
    Cost DECIMAL(10,2)
);

CREATE TABLE ServiceRecords (
    RecordID INT AUTO_INCREMENT PRIMARY KEY,
    VehicleID INT,
    ServiceID INT,
    ServiceDate DATE,
    FOREIGN KEY (VehicleID) REFERENCES Vehicles(VehicleID),
    FOREIGN KEY (ServiceID) REFERENCES Services(ServiceID)
);

-- INSERTING table
INSERT INTO Customers (Name, Email) VALUES
('Alice', 'alice@example.com'),
('Bob', 'bob@example.com'),
('Charlie', 'charlie@example.com');


INSERT INTO Vehicles (CustomerID, Make, Model, Year, LicensePlate) VALUES
(1, 'Toyota', 'Camry', 2020, 'ABC123'),
(1, 'Honda', 'Civic', 2018, 'XYZ789'),
(2, 'Ford', 'F-150', 2021, 'TRK456'),
(3, 'Tesla', 'Model 3', 2022, 'TES999');

INSERT INTO Services (ServiceName, Cost) VALUES
('Oil Change', 50.00),
('Tire Rotation', 30.00),
('Brake Inspection', 40.00),
('Battery Replacement', 120.00);

INSERT INTO ServiceRecords (VehicleID, ServiceID, ServiceDate) VALUES
(1, 1, '2025-06-10'),
(1, 2, '2025-07-01'), -- last month
(2, 1, '2025-06-15'),
(2, 3, '2025-07-01'), -- last month
(3, 4, '2025-05-20'),
(3, 1, '2025-07-01'), -- last month
(4, 1, '2025-07-02'), -- last month
(4, 2, '2025-07-03'), -- last month
(4, 3, '2025-07-04'); -- last month

-- Query vehicles serviced in the last month.
SELECT 
    v.VehicleID,
    v.Make,
    v.Model,
    v.LicensePlate,
    sr.ServiceDate
FROM 
    ServiceRecords sr
JOIN 
    Vehicles v ON sr.VehicleID = v.VehicleID
WHERE 
    sr.ServiceDate >= DATE_SUB(CURDATE(), INTERVAL 1 MONTH);

-- Find customers with more than 2 services in a year.
SELECT 
    c.CustomerID,
    c.Name,
    COUNT(sr.RecordID) AS ServiceCount
FROM 
    Customers c
JOIN 
    Vehicles v ON c.CustomerID = v.CustomerID
JOIN 
    ServiceRecords sr ON v.VehicleID = sr.VehicleID
WHERE 
    YEAR(sr.ServiceDate) = 2025
GROUP BY 
    c.CustomerID, c.Name
HAVING 
    ServiceCount > 2;
