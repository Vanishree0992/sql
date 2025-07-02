-- Create the database
CREATE DATABASE HotelBookingDB;

-- Use the database
USE HotelBookingDB;

-- creating tables
CREATE TABLE Rooms (
    RoomID INT AUTO_INCREMENT PRIMARY KEY,
    RoomNumber VARCHAR(10) NOT NULL,
    RoomType VARCHAR(50),
    Price DECIMAL(10,2)
);


CREATE TABLE Guests (
    GuestID INT AUTO_INCREMENT PRIMARY KEY,
    Name VARCHAR(100) NOT NULL,
    Email VARCHAR(100)
);

CREATE TABLE Bookings (
    BookingID INT AUTO_INCREMENT PRIMARY KEY,
    RoomID INT,
    GuestID INT,
    CheckIn DATE,
    CheckOut DATE,
    FOREIGN KEY (RoomID) REFERENCES Rooms(RoomID),
    FOREIGN KEY (GuestID) REFERENCES Guests(GuestID)
);

-- inserting data
INSERT INTO Rooms (RoomNumber, RoomType, Price)
 VALUES 
('101', 'Single', 100.00),
('102', 'Double', 150.00),
('103', 'Suite', 300.00),
('104', 'Single', 100.00),
('105', 'Double', 150.00);

INSERT INTO Guests (Name, Email) 
VALUES 
('Alice', 'alice@example.com'),
('Bob', 'bob@example.com'),
('Charlie', 'charlie@example.com'),
('David', 'david@example.com'),
('Eva', 'eva@example.com');

INSERT INTO Bookings (RoomID, GuestID, CheckIn, CheckOut) 
VALUES 
(1, 1, '2025-07-10', '2025-07-12'),
(2, 2, '2025-07-11', '2025-07-15'),
(3, 1, '2025-07-15', '2025-07-20'),
(1, 1, '2025-08-01', '2025-08-05'),
(4, 3, '2025-07-10', '2025-07-12'),
(5, 1, '2025-09-01', '2025-09-10');

-- - Find available rooms for a given date.
SELECT 
    r.RoomID,
    r.RoomNumber,
    r.RoomType,
    r.Price
FROM 
    Rooms r
WHERE 
    r.RoomID NOT IN (
        SELECT 
            b.RoomID
        FROM 
            Bookings b
        WHERE 
            '2025-07-11' BETWEEN b.CheckIn AND DATE_SUB(b.CheckOut, INTERVAL 1 DAY)
    );

-- List guests with more than 3 bookings.
SELECT 
    g.GuestID,
    g.Name,
    COUNT(b.BookingID) AS BookingCount
FROM 
    Guests g
JOIN 
    Bookings b ON g.GuestID = b.GuestID
GROUP BY 
    g.GuestID, g.Name
HAVING 
    BookingCount > 3;

