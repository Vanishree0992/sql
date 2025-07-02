-- Create the database
CREATE DATABASE RestaurantDB;

-- Use the database
USE RestaurantDB;

-- Tables: Tables, Customers, Reservations.
CREATE TABLE Tables (
    TableID INT AUTO_INCREMENT PRIMARY KEY,
    TableNumber INT NOT NULL,
    Seats INT
);

CREATE TABLE Customers (
    CustomerID INT AUTO_INCREMENT PRIMARY KEY,
    Name VARCHAR(100) NOT NULL,
    PhoneNumber VARCHAR(20)
);

CREATE TABLE Reservations (
    ReservationID INT AUTO_INCREMENT PRIMARY KEY,
    TableID INT,
    CustomerID INT,
    ReservationDate DATE,
    ReservationTime TIME,
    Guests INT,
    FOREIGN KEY (TableID) REFERENCES Tables(TableID),
    FOREIGN KEY (CustomerID) REFERENCES Customers(CustomerID)
);

-- Insert reservation entries for different dates and times.
INSERT INTO Tables (TableNumber, Seats) 
VALUES
(1, 2),
(2, 4),
(3, 4),
(4, 6),
(5, 2);

INSERT INTO Customers (Name, PhoneNumber) 
VALUES
('Alice', '1234567890'),
('Bob', '9876543210'),
('Charlie', '5556667777'),
('David', '4445556666'),
('Eva', '3334445555');

INSERT INTO Reservations (TableID, CustomerID, ReservationDate, ReservationTime, Guests) 
VALUES
(1, 1, '2025-07-05', '19:00:00', 2),
(2, 2, '2025-07-05', '19:30:00', 4),
(3, 1, '2025-07-06', '20:00:00', 4),
(2, 3, '2025-07-07', '18:00:00', 4),
(1, 1, '2025-07-08', '19:00:00', 2),
(4, 4, '2025-07-05', '20:00:00', 6),
(2, 1, '2025-07-09', '19:00:00', 4); 

-- Find available tables at a given time.
SELECT 
    t.TableID,
    t.TableNumber,
    t.Seats
FROM 
    Tables t
WHERE 
    t.TableID NOT IN (
        SELECT 
            r.TableID
        FROM 
            Reservations r
        WHERE 
            r.ReservationDate = '2025-07-05'
            AND r.ReservationTime = '19:00:00'
    );

-- List customers with more than 2 reservations.
SELECT 
    c.CustomerID,
    c.Name,
    COUNT(r.ReservationID) AS ReservationCount
FROM 
    Reservations r
JOIN 
    Customers c ON r.CustomerID = c.CustomerID
GROUP BY 
    c.CustomerID, c.Name
HAVING 
    ReservationCount > 2;

