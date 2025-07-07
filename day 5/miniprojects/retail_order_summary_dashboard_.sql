CREATE DATABASE Retail_summaryDB;
USE Retail_summaryDB;

CREATE TABLE Customers (
  CustomerID INT PRIMARY KEY AUTO_INCREMENT,
  FirstName VARCHAR(50) NOT NULL,
  LastName VARCHAR(50) NOT NULL,
  Email VARCHAR(100) UNIQUE NOT NULL
);


CREATE TABLE Products (
  ProductID INT PRIMARY KEY AUTO_INCREMENT,
  ProductName VARCHAR(100) NOT NULL,
  Price DECIMAL(10,2) NOT NULL CHECK (Price >= 0)
);


CREATE TABLE Orders (
  OrderID INT PRIMARY KEY AUTO_INCREMENT,
  CustomerID INT NOT NULL,
  OrderDate TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  FOREIGN KEY (CustomerID) REFERENCES Customers(CustomerID)
);

CREATE TABLE OrderItems (
  OrderItemID INT PRIMARY KEY AUTO_INCREMENT,
  OrderID INT NOT NULL,
  ProductID INT NOT NULL,
  Quantity INT NOT NULL CHECK (Quantity > 0),
  FOREIGN KEY (OrderID) REFERENCES Orders(OrderID),
  FOREIGN KEY (ProductID) REFERENCES Products(ProductID)
);



INSERT INTO Customers (FirstName, LastName, Email)
VALUES
('Alice', 'Johnson', 'alice@example.com'),
('Bob', 'Smith', 'bob@example.com'),
('Carol', 'White', 'carol@example.com');


INSERT INTO Products (ProductName, Price)
VALUES
('Laptop', 1200.00),
('Mouse', 25.00),
('Keyboard', 45.00),
('Monitor', 300.00),
('Headphones', 80.00);


INSERT INTO Orders (CustomerID, OrderDate)
VALUES
(1, '2025-07-07'),
(2, '2025-07-07'),
(3, '2025-07-07'),
(1, '2025-07-08');


INSERT INTO OrderItems (OrderID, ProductID, Quantity)
VALUES
(1, 1, 1), 
(1, 2, 2), 
(2, 3, 1), 
(2, 4, 1), 
(3, 5, 3), 
(4, 2, 1), 
(4, 3, 1); 


--	Use joins to generate complete order summaries.
SELECT 
  o.OrderID,
  o.OrderDate,
  CONCAT(c.FirstName, ' ', c.LastName) AS CustomerName,
  p.ProductName,
  oi.Quantity,
  (oi.Quantity * p.Price) AS ItemTotal
FROM Orders o
JOIN Customers c ON o.CustomerID = c.CustomerID
JOIN OrderItems oi ON o.OrderID = oi.OrderID
JOIN Products p ON oi.ProductID = p.ProductID
ORDER BY o.OrderDate, CustomerName;

--	Use SUM(), COUNT(), GROUP BY to calculate total sales per day.
SELECT 
  OrderDate,
  COUNT(DISTINCT OrderID) AS TotalOrders,
  SUM(oi.Quantity * p.Price) AS TotalSales
FROM Orders o
JOIN OrderItems oi ON o.OrderID = oi.OrderID
JOIN Products p ON oi.ProductID = p.ProductID
GROUP BY OrderDate
ORDER BY OrderDate;

--	Use subqueries to identify best-selling products.
SELECT 
  ProductName,
  TotalSold
FROM (
  SELECT 
    p.ProductName,
    SUM(oi.Quantity) AS TotalSold
  FROM OrderItems oi
  JOIN Products p ON oi.ProductID = p.ProductID
  GROUP BY p.ProductID
) AS ProductSales
WHERE TotalSold = (
  SELECT MAX(ProductTotals)
  FROM (
    SELECT SUM(Quantity) AS ProductTotals
    FROM OrderItems
    GROUP BY ProductID
  ) AS Totals
);

--	Use DISTINCT, ORDER BY on customer names and order dates.
SELECT DISTINCT 
  CONCAT(c.FirstName, ' ', c.LastName) AS CustomerName,
  o.OrderDate
FROM Customers c
JOIN Orders o ON c.CustomerID = o.CustomerID
ORDER BY CustomerName, o.OrderDate;

