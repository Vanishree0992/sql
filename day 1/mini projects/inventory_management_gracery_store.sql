-- Create the database
CREATE DATABASE GroceryInventoryDB;

-- Use the database
USE GroceryInventoryDB;

-- creating tables
CREATE TABLE Suppliers (
    SupplierID INT AUTO_INCREMENT PRIMARY KEY,
    SupplierName VARCHAR(100) NOT NULL,
    ContactEmail VARCHAR(100)
);

CREATE TABLE Products (
    ProductID INT AUTO_INCREMENT PRIMARY KEY,
    ProductName VARCHAR(100) NOT NULL,
    SupplierID INT,
    Price DECIMAL(10,2),
    FOREIGN KEY (SupplierID) REFERENCES Suppliers(SupplierID)
);


CREATE TABLE Stock (
    StockID INT AUTO_INCREMENT PRIMARY KEY,
    ProductID INT,
    Quantity INT,
    LastUpdated DATE,
    FOREIGN KEY (ProductID) REFERENCES Products(ProductID)
);

-- inserting tables
INSERT INTO Suppliers (SupplierName, ContactEmail) 
VALUES
('Fresh Farms', 'freshfarms@example.com'),
('Green Valley', 'greenvalley@example.com'),
('Organic Supplies', 'organic@example.com');

INSERT INTO Products (ProductName, SupplierID, Price) 
VALUES
('Apples', 1, 1.20),
('Bananas', 1, 0.80),
('Carrots', 2, 0.50),
('Tomatoes', 2, 0.90),
('Spinach', 2, 1.00),
('Milk', 3, 1.50),
('Eggs', 3, 2.50),
('Bread', 3, 2.00),
('Cheese', 3, 3.00),
('Yogurt', 3, 1.20),
('Butter', 3, 2.80);

INSERT INTO Stock (ProductID, Quantity, LastUpdated) VALUES
(1, 50, '2025-07-01'),
(2, 20, '2025-07-01'),
(3, 5, '2025-07-01'),   
(4, 8, '2025-07-01'),   
(5, 15, '2025-07-01'),
(6, 30, '2025-07-01'),
(7, 2, '2025-07-01'),   
(8, 12, '2025-07-01'),
(9, 18, '2025-07-01'),
(10, 7, '2025-07-01'), 
(11, 25, '2025-07-01');

-- Query low-stock products (below threshold).
SELECT 
    p.ProductName,
    s.SupplierName,
    st.Quantity
FROM 
    Stock st
JOIN 
    Products p ON st.ProductID = p.ProductID
JOIN 
    Suppliers s ON p.SupplierID = s.SupplierID
WHERE 
    st.Quantity < 10;

-- List suppliers providing more than 5 products.
SELECT 
    s.SupplierID,
    s.SupplierName,
    COUNT(p.ProductID) AS ProductCount
FROM 
    Suppliers s
JOIN 
    Products p ON s.SupplierID = p.SupplierID
GROUP BY 
    s.SupplierID, s.SupplierName
HAVING 
    ProductCount > 5;
