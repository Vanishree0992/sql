-- Create database
CREATE DATABASE TravelAgencyDB;

-- Use database
USE TravelAgencyDB;

-- create tables
CREATE TABLE Customers (
    CustomerID INT AUTO_INCREMENT PRIMARY KEY,
    Name VARCHAR(100) NOT NULL,
    Email VARCHAR(100)
);

CREATE TABLE Trips (
    TripID INT AUTO_INCREMENT PRIMARY KEY,
    Destination VARCHAR(100) NOT NULL,
    StartDate DATE,
    EndDate DATE,
    Price DECIMAL(10,2)
);

CREATE TABLE Bookings (
    BookingID INT AUTO_INCREMENT PRIMARY KEY,
    CustomerID INT,
    TripID INT,
    BookingDate DATE,
    FOREIGN KEY (CustomerID) REFERENCES Customers(CustomerID),
    FOREIGN KEY (TripID) REFERENCES Trips(TripID)
);

-- insert data
INSERT INTO Customers (Name, Email)
 VALUES 
('Alice', 'alice@example.com'),
('Bob', 'bob@example.com'),
('Charlie', 'charlie@example.com');

INSERT INTO Trips (Destination, StartDate, EndDate, Price)
 VALUES 
('Paris', '2025-08-01', '2025-08-07', 1500.00),
('Tokyo', '2025-09-10', '2025-09-20', 2500.00),
('New York', '2025-07-15', '2025-07-22', 2000.00),
('Sydney', '2025-10-05', '2025-10-15', 3000.00),
('Rome', '2025-08-20', '2025-08-27', 1800.00);

INSERT INTO Bookings (CustomerID, TripID, BookingDate)
 VALUES 
(1, 1, '2025-06-15'),
(1, 3, '2025-06-20'),
(2, 2, '2025-06-25'),
(2, 1, '2025-06-26');

-- Find all trips booked by a customer.
SELECT 
    c.Name AS CustomerName,
    t.Destination,
    t.StartDate,
    t.EndDate,
    t.Price
FROM 
    Bookings b
JOIN 
    Customers c ON b.CustomerID = c.CustomerID
JOIN 
    Trips t ON b.TripID = t.TripID
WHERE 
    c.Name = 'Alice';

-- List trips with no bookings.
SELECT 
    t.TripID,
    t.Destination,
    t.StartDate,
    t.EndDate,
    t.Price
FROM 
    Trips t
LEFT JOIN 
    Bookings b ON t.TripID = b.TripID
WHERE 
    b.BookingID IS NULL;
