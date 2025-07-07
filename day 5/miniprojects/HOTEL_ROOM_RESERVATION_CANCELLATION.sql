CREATE DATABASE Hotel_cancellationDB;
USE Hotel_cancellationDB;

CREATE TABLE Rooms (
  RoomID INT PRIMARY KEY AUTO_INCREMENT,
  RoomNumber VARCHAR(10) NOT NULL UNIQUE,
  RoomType VARCHAR(50) NOT NULL
);

CREATE TABLE Customers (
  CustomerID INT PRIMARY KEY AUTO_INCREMENT,
  CustomerName VARCHAR(100) NOT NULL
);

CREATE TABLE Bookings (
  BookingID INT PRIMARY KEY AUTO_INCREMENT,
  RoomID INT NOT NULL,
  CustomerID INT NOT NULL,
  CheckIn TIMESTAMP NOT NULL,
  CheckOut TIMESTAMP NOT NULL,
  BookingDate TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  FOREIGN KEY (RoomID) REFERENCES Rooms(RoomID),
  FOREIGN KEY (CustomerID) REFERENCES Customers(CustomerID)
);

INSERT INTO Rooms (RoomNumber, RoomType)
VALUES 
('101', 'Single'),
('102', 'Double'),
('103', 'Suite');

INSERT INTO Customers (CustomerName)
VALUES ('Alice'), ('Bob'), ('Carol');

-- 	Use BETWEEN for booking dates.
-- Use subqueries to find overlapping bookings.
SELECT *
FROM Bookings
WHERE RoomID = 1
  AND (
    '2025-07-05' BETWEEN CheckIn AND CheckOut
    OR '2025-07-10' BETWEEN CheckIn AND CheckOut
    OR (CheckIn BETWEEN '2025-07-05' AND '2025-07-10')
    OR (CheckOut BETWEEN '2025-07-05' AND '2025-07-10')
  );

-- Check if available:
SELECT COUNT(*) AS Overlaps
FROM Bookings
WHERE RoomID = 1
  AND (
    '2025-07-05' BETWEEN CheckIn AND CheckOut
    OR '2025-07-10' BETWEEN CheckIn AND CheckOut
    OR (CheckIn BETWEEN '2025-07-05' AND '2025-07-10')
    OR (CheckOut BETWEEN '2025-07-05' AND '2025-07-10')
  );

INSERT INTO Bookings (RoomID, CustomerID, CheckIn, CheckOut)
VALUES (1, 1, '2025-07-05', '2025-07-10');

-- 	Use DELETE and rollback for cancellations.
START TRANSACTION;

DELETE FROM Bookings WHERE BookingID = 2;

ROLLBACK;

COMMIT;

-- Use CASE to tag booking status.
SELECT 
  BookingID,
  CustomerID,
  RoomID,
  CheckIn,
  CheckOut,
  CASE
    WHEN CURRENT_DATE BETWEEN CheckIn AND CheckOut THEN 'Current'
    WHEN CURRENT_DATE < CheckIn THEN 'Upcoming'
    ELSE 'Completed'
  END AS BookingStatus
FROM Bookings;

