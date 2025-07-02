-- Create the database
CREATE DATABASE MovieRentalDB;

-- Use the database
USE MovieRentalDB;

 -- Tables: Movies, Customers, Rentals.
 CREATE TABLE Movies (
    MovieID INT AUTO_INCREMENT PRIMARY KEY,
    Title VARCHAR(100) NOT NULL,
    Genre VARCHAR(50),
    ReleaseYear INT
);

CREATE TABLE Customers (
    CustomerID INT AUTO_INCREMENT PRIMARY KEY,
    Name VARCHAR(100) NOT NULL,
    Email VARCHAR(100)
);

CREATE TABLE Rentals (
    RentalID INT AUTO_INCREMENT PRIMARY KEY,
    CustomerID INT,
    MovieID INT,
    RentalDate DATE,
    ReturnDate DATE,
    DueDate DATE,
    FOREIGN KEY (CustomerID) REFERENCES Customers(CustomerID),
    FOREIGN KEY (MovieID) REFERENCES Movies(MovieID)
);

-- Insert sample movies and rental records.

INSERT INTO Movies (Title, Genre, ReleaseYear) 
VALUES 
('Inception', 'Sci-Fi', 2010),
('Titanic', 'Romance', 1997),
('The Dark Knight', 'Action', 2008),
('Finding Nemo', 'Animation', 2003),
('Interstellar', 'Sci-Fi', 2014),
('The Notebook', 'Romance', 2004);

INSERT INTO Customers (Name, Email)
 VALUES 
('Alice', 'alice@example.com'),
('Bob', 'bob@example.com'),
('Charlie', 'charlie@example.com'),
('David', 'david@example.com');

INSERT INTO Rentals (CustomerID, MovieID, RentalDate, ReturnDate, DueDate) 
VALUES 
(1, 1, '2025-06-20', NULL, '2025-06-27'),
(2, 2, '2025-06-22', '2025-06-25', '2025-06-29'),
(3, 1, '2025-06-23', '2025-06-24', '2025-06-30'),
(4, 3, '2025-06-24', NULL, '2025-07-01'), 
(1, 5, '2025-06-25', '2025-06-27', '2025-07-02'),
(2, 6, '2025-06-26', NULL, '2025-07-03'); 

-- Query overdue rentals and customers who rented specific genres.

SELECT 
    r.RentalID,
    c.Name AS CustomerName,
    m.Title AS MovieTitle,
    r.RentalDate,
    r.DueDate
FROM 
    Rentals r
JOIN 
    Customers c ON r.CustomerID = c.CustomerID
JOIN 
    Movies m ON r.MovieID = m.MovieID
WHERE 
    r.ReturnDate IS NULL
    AND r.DueDate < CURDATE();

SELECT DISTINCT
    c.CustomerID,
    c.Name,
    c.Email
FROM 
    Rentals r
JOIN 
    Customers c ON r.CustomerID = c.CustomerID
JOIN 
    Movies m ON r.MovieID = m.MovieID
WHERE 
    m.Genre = 'Sci-Fi';

-- List top 3 most rented movies.
SELECT 
    m.MovieID,
    m.Title,
    COUNT(r.RentalID) AS RentalCount
FROM 
    Rentals r
JOIN 
    Movies m ON r.MovieID = m.MovieID
GROUP BY 
    m.MovieID, m.Title
ORDER BY 
    RentalCount DESC
LIMIT 3;
