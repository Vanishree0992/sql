-- Create the database
CREATE DATABASE OnlineStoreDB;

-- Use the database
USE OnlineStoreDB;


-- Tables: Products, Categories, Suppliers.
CREATE TABLE Categories (
    CategoryID INT AUTO_INCREMENT PRIMARY KEY,
    CategoryName VARCHAR(100) NOT NULL
);


CREATE TABLE Suppliers (
    SupplierID INT AUTO_INCREMENT PRIMARY KEY,
    SupplierName VARCHAR(100) NOT NULL,
    ContactEmail VARCHAR(100)
);


CREATE TABLE Products (
    ProductID INT AUTO_INCREMENT PRIMARY KEY,
    ProductName VARCHAR(100) NOT NULL,
    Price DECIMAL(10,2),
    CategoryID INT,
    SupplierID INT,
    FOREIGN KEY (CategoryID) REFERENCES Categories(CategoryID),
    FOREIGN KEY (SupplierID) REFERENCES Suppliers(SupplierID)
);

-- Insert products with prices and categories.
INSERT INTO Categories (CategoryName) VALUES 
('Electronics'),
('Books'),
('Clothing');

INSERT INTO Suppliers (SupplierName, ContactEmail) VALUES 
('TechCorp', 'support@techcorp.com'),
('BookWorld', 'contact@bookworld.com'),
('FashionHub', 'info@fashionhub.com');


INSERT INTO Products (ProductName, Price, CategoryID, SupplierID) VALUES 
('Laptop', 1200.00, 1, 1),
('Smartphone', 800.00, 1, 1),
('Headphones', 150.00, 1, 1),
('Novel - Fiction', 20.00, 2, 2),
('Textbook - Science', 85.00, 2, 2),
('T-shirt', 25.00, 3, 3),
('Jeans', 50.00, 3, 3),
('Jacket', 120.00, 3, 3),
('Tablet', 600.00, 1, 1),
('E-Reader', 90.00, 2, 2);


-- Query products by category, price range, or supplier.
SELECT 
    p.ProductName,
    p.Price,
    c.CategoryName
FROM 
    Products p
JOIN 
    Categories c ON p.CategoryID = c.CategoryID
WHERE 
    c.CategoryName = 'Electronics';

-- Query products by category, price range, or supplier.
SELECT 
    ProductName,
    Price
FROM 
    Products
WHERE 
    Price BETWEEN 100 AND 800;

-- Query products by category, price range, or supplier.
SELECT 
    p.ProductName,
    p.Price,
    s.SupplierName
FROM 
    Products p
JOIN 
    Suppliers s ON p.SupplierID = s.SupplierID
WHERE 
    s.SupplierName = 'BookWorld';
--  Find the top 5 most expensive products.

SELECT 
    ProductName,
    Price
FROM 
    Products
ORDER BY 
    Price DESC
LIMIT 5;
