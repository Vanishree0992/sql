-- Create the database
CREATE DATABASE BookstoreDB;

-- Use the database
USE BookstoreDB;

-- creating tables
CREATE TABLE Books (
    BookID INT AUTO_INCREMENT PRIMARY KEY,
    Title VARCHAR(200) NOT NULL,
    Author VARCHAR(100),
    Price DECIMAL(10,2)
);

CREATE TABLE Customers (
    CustomerID INT AUTO_INCREMENT PRIMARY KEY,
    Name VARCHAR(100) NOT NULL,
    Email VARCHAR(100)
);

CREATE TABLE Sales (
    SaleID INT AUTO_INCREMENT PRIMARY KEY,
    BookID INT,
    CustomerID INT,
    SaleDate DATE,
    Quantity INT,
    FOREIGN KEY (BookID) REFERENCES Books(BookID),
    FOREIGN KEY (CustomerID) REFERENCES Customers(CustomerID)
);

-- inserting datas
INSERT INTO Books (Title, Author, Price)
 VALUES
('The Great Gatsby', 'F. Scott Fitzgerald', 12.99),
('To Kill a Mockingbird', 'Harper Lee', 10.99),
('1984', 'George Orwell', 15.50),
('The Catcher in the Rye', 'J.D. Salinger', 11.50),
('Pride and Prejudice', 'Jane Austen', 9.99);

INSERT INTO Customers (Name, Email) 
VALUES
('Alice', 'alice@example.com'),
('Bob', 'bob@example.com'),
('Charlie', 'charlie@example.com'),
('David', 'david@example.com');

INSERT INTO Sales (BookID, CustomerID, SaleDate, Quantity) 
VALUES
(1, 1, '2025-07-01', 2), 
(2, 1, '2025-07-02', 1), 
(3, 1, '2025-07-03', 1),
(2, 2, '2025-07-02', 1), 
(4, 2, '2025-07-05', 2), 
(5, 3, '2025-07-06', 1), 
(3, 3, '2025-07-07', 1), 
(1, 4, '2025-07-08', 1); 

-- best-selling books
SELECT 
    b.BookID,
    b.Title,
    SUM(s.Quantity) AS TotalSold
FROM 
    Sales s
JOIN 
    Books b ON s.BookID = b.BookID
GROUP BY 
    b.BookID, b.Title
ORDER BY 
    TotalSold DESC;

-- customers who purchased more than 3 books
SELECT 
    c.CustomerID,
    c.Name,
    SUM(s.Quantity) AS TotalPurchased
FROM 
    Sales s
JOIN 
    Customers c ON s.CustomerID = c.CustomerID
GROUP BY 
    c.CustomerID, c.Name
HAVING 
    TotalPurchased > 3;
