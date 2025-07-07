CREATE DATABASE Transport_routeDB;
USE Transport_routeDB;

CREATE TABLE Routes (
  RouteID INT PRIMARY KEY AUTO_INCREMENT,
  StartLocation VARCHAR(100) NOT NULL,
  EndLocation VARCHAR(100) NOT NULL
);

CREATE TABLE Buses (
  BusID INT PRIMARY KEY AUTO_INCREMENT,
  RouteID INT NOT NULL,
  BusNumber VARCHAR(20) NOT NULL,
  IsAvailable BOOLEAN DEFAULT TRUE,
  FOREIGN KEY (RouteID) REFERENCES Routes(RouteID)
);

CREATE TABLE Bookings (
  BookingID INT PRIMARY KEY AUTO_INCREMENT,
  BusID INT NOT NULL,
  PassengerName VARCHAR(100) NOT NULL,
  BookingDate DATETIME DEFAULT CURRENT_TIMESTAMP,
  FOREIGN KEY (BusID) REFERENCES Buses(BusID)
);

INSERT INTO Routes (StartLocation, EndLocation)
VALUES 
('City A', 'City B'),
('City A', 'City C'),
('City B', 'City D');

INSERT INTO Buses (RouteID, BusNumber, IsAvailable)
VALUES
(1, 'BUS-101', TRUE),
(2, 'BUS-202', TRUE),
(3, 'BUS-303', FALSE);

INSERT INTO Bookings (BusID, PassengerName)
VALUES
(1, 'Alice'),
(1, 'Bob'),
(2, 'Carol'),
(1, 'David'),
(2, 'Eve');

--	Use subqueries to find most booked route.
SELECT *
FROM (
  SELECT 
    r.RouteID,
    CONCAT(r.StartLocation, ' -> ', r.EndLocation) AS RouteName,
    COUNT(bk.BookingID) AS TotalBookings
  FROM Routes r
  JOIN Buses b ON r.RouteID = b.RouteID
  JOIN Bookings bk ON b.BusID = bk.BusID
  GROUP BY r.RouteID, r.StartLocation, r.EndLocation
) AS RouteCounts
ORDER BY TotalBookings DESC
LIMIT 1;


--	Use GROUP BY, COUNT() for route-wise bookings.
SELECT 
  r.RouteID,
  CONCAT(r.StartLocation, ' -> ', r.EndLocation) AS RouteName,
  COUNT(bk.BookingID) AS TotalBookings
FROM Routes r
JOIN Buses b ON r.RouteID = b.RouteID
JOIN Bookings bk ON b.BusID = bk.BusID
GROUP BY r.RouteID, r.StartLocation, r.EndLocation
ORDER BY TotalBookings DESC;

--	Use JOIN to get full booking summary.
SELECT 
  bk.BookingID,
  bk.PassengerName,
  bk.BookingDate,
  b.BusNumber,
  CONCAT(r.StartLocation, ' -> ', r.EndLocation) AS RouteName
FROM Bookings bk
JOIN Buses b ON bk.BusID = b.BusID
JOIN Routes r ON b.RouteID = r.RouteID
ORDER BY bk.BookingDate DESC;

--	Use DELETE for cancelled trips and rollback if bus is not available
START TRANSACTION;

SELECT IsAvailable INTO @isAvailable FROM Buses WHERE BusID = 3;

DELETE FROM Bookings WHERE BusID = 3;


