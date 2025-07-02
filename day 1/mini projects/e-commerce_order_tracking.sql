-- Create the database
CREATE DATABASE ECommerceDB;

-- Use the database
USE ECommerceDB;

-- creating tables
CREATE TABLE Customers (
    CustomerID INT AUTO_INCREMENT PRIMARY KEY,
    Name VARCHAR(100) NOT NULL,
    Email VARCHAR(100)
);

CREATE TABLE Products (
    ProductID INT AUTO_INCREMENT PRIMARY KEY,
    ProductName VARCHAR(100) NOT NULL,
    Price DECIMAL(10,2)
);

CREATE TABLE Orders (
    OrderID INT AUTO_INCREMENT PRIMARY KEY,
    CustomerID INT,
    OrderDate DATE,
    Status VARCHAR(50),
    FOREIGN KEY (CustomerID) REFERENCES Customers(CustomerID)
);

CREATE TABLE OrderItems (
    OrderItemID INT AUTO_INCREMENT PRIMARY KEY,
    OrderID INT,
    ProductID INT,
    Quantity INT,
    FOREIGN KEY (OrderID) REFERENCES Orders(OrderID),
    FOREIGN KEY (ProductID) REFERENCES Products(ProductID)
);

-- inserting data
INSERT INTO Customers (Name, Email)
 VALUES 
('Alice', 'alice@example.com'),
('Bob', 'bob@example.com'),
('Charlie', 'charlie@example.com');

INSERT INTO Products (ProductName, Price)
 VALUES 
('Laptop', 1200.00),
('Smartphone', 800.00),
('Headphones', 150.00),
('Keyboard', 50.00),
('Mouse', 25.00);

INSERT INTO Orders (CustomerID, OrderDate, Status)
 VALUES 
(1, '2025-07-01', 'Pending'),
(1, '2025-06-15', 'Shipped'),
(2, '2025-07-02', 'Pending'),
(3, '2025-06-20', 'Delivered');

INSERT INTO OrderItems (OrderID, ProductID, Quantity) VALUES 
(1, 1, 1), 
(1, 3, 2), 
(2, 2, 1), 
(3, 4, 1), 
(3, 5, 1), 
(4, 3, 5), 
(4, 5, 6); 


-- pending order\
SELECT 
    o.OrderID,
    c.Name AS CustomerName,
    o.OrderDate,
    o.Status
FROM 
    Orders o
JOIN 
    Customers c ON o.CustomerID = c.CustomerID
WHERE 
    o.Status = 'Pending';

-- order history
SELECT 
    o.OrderID,
    o.OrderDate,
    o.Status,
    p.ProductName,
    oi.Quantity
FROM 
    Orders o
JOIN 
    OrderItems oi ON o.OrderID = oi.OrderID
JOIN 
    Products p ON oi.ProductID = p.ProductID
JOIN 
    Customers c ON o.CustomerID = c.CustomerID
WHERE 
    c.Name = 'Alice'
ORDER BY 
    o.OrderDate DESC;

-- products ordered more than 10times
SELECT 
    p.ProductID,
    p.ProductName,
    SUM(oi.Quantity) AS TotalOrdered
FROM 
    OrderItems oi
JOIN 
    Products p ON oi.ProductID = p.ProductID
GROUP BY 
    p.ProductID, p.ProductName
HAVING 
    TotalOrdered > 10;
