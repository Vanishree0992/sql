-- Create the database
CREATE DATABASE ParkingLotDB;

-- Use the database
USE ParkingLotDB;

-- create tables
CREATE TABLE Lots (
    LotID INT AUTO_INCREMENT PRIMARY KEY,
    LotName VARCHAR(100) NOT NULL,
    Capacity INT NOT NULL
);

CREATE TABLE Vehicles (
    VehicleID INT AUTO_INCREMENT PRIMARY KEY,
    LicensePlate VARCHAR(20) NOT NULL,
    OwnerName VARCHAR(100)
);

CREATE TABLE ParkingRecords (
    RecordID INT AUTO_INCREMENT PRIMARY KEY,
    LotID INT,
    VehicleID INT,
    EntryTime DATETIME,
    ExitTime DATETIME,
    FOREIGN KEY (LotID) REFERENCES Lots(LotID),
    FOREIGN KEY (VehicleID) REFERENCES Vehicles(VehicleID)
);

-- inserting data
INSERT INTO Lots (LotName, Capacity) 
VALUES
('Lot A', 2),
('Lot B', 3);


INSERT INTO Vehicles (LicensePlate, OwnerName) 
VALUES
('ABC123', 'Alice'),
('XYZ789', 'Bob'),
('DEF456', 'Charlie'),
('GHI999', 'David');

-- Vehicle currently parked
INSERT INTO ParkingRecords (LotID, VehicleID, EntryTime, ExitTime) 
VALUES
(1, 1, '2025-07-02 08:00:00', NULL),
(1, 2, '2025-07-02 08:30:00', NULL),
(2, 3, '2025-07-02 09:00:00', NULL);

-- Vehicle that exited
INSERT INTO ParkingRecords (LotID, VehicleID, EntryTime, ExitTime) 
VALUES
(2, 4, '2025-07-02 09:30:00', '2025-07-02 11:00:00');

-- currentlt parked 
SELECT 
    v.VehicleID,
    v.LicensePlate,
    v.OwnerName,
    l.LotName,
    pr.EntryTime
FROM 
    ParkingRecords pr
JOIN 
    Vehicles v ON pr.VehicleID = v.VehicleID
JOIN 
    Lots l ON pr.LotID = l.LotID
WHERE 
    pr.ExitTime IS NULL;

-- lots that are full
SELECT 
    l.LotID,
    l.LotName,
    l.Capacity,
    COUNT(pr.RecordID) AS CurrentlyParked
FROM 
    Lots l
JOIN 
    ParkingRecords pr ON l.LotID = pr.LotID
WHERE 
    pr.ExitTime IS NULL
GROUP BY 
    l.LotID, l.LotName, l.Capacity
HAVING 
    CurrentlyParked >= l.Capacity;
