CREATE DATABASE Warehouse_stockDB;
USE Warehouse_stockDB;

CREATE TABLE Products (
  ProductID INT PRIMARY KEY AUTO_INCREMENT,
  ProductName VARCHAR(100) NOT NULL,
  UnitPrice DECIMAL(10, 2) NOT NULL CHECK (UnitPrice >= 0)
);

CREATE TABLE Inward (
  InwardID INT PRIMARY KEY AUTO_INCREMENT,
  ProductID INT NOT NULL,
  Quantity INT NOT NULL CHECK (Quantity > 0),
  MovementDate TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
  FOREIGN KEY (ProductID) REFERENCES Products(ProductID)
);

CREATE TABLE Outward (
  OutwardID INT PRIMARY KEY AUTO_INCREMENT,
  ProductID INT NOT NULL,
  Quantity INT NOT NULL CHECK (Quantity > 0),
  MovementDate TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
  FOREIGN KEY (ProductID) REFERENCES Products(ProductID)
);

CREATE TABLE StockLevels (
  ProductID INT PRIMARY KEY,
  CurrentStock INT NOT NULL CHECK (CurrentStock >= 0),
  FOREIGN KEY (ProductID) REFERENCES Products(ProductID)
);

INSERT INTO Products (ProductName, UnitPrice)
VALUES
('Widget A', 10.00),
('Widget B', 15.50),
('Widget C', 8.75);

INSERT INTO Inward (ProductID, Quantity)
VALUES
(1, 100),
(2, 50),
(1, 40),
(3, 20);

INSERT INTO Outward (ProductID, Quantity)
VALUES
(1, 30),
(2, 70),
(3, 10);

INSERT INTO StockLevels (ProductID, CurrentStock)
VALUES
(1, 110), 
(2, 0),   
(3, 10); 

--	Use GROUP BY with SUM() to calculate net stock.
SELECT 
  p.ProductID,
  p.ProductName,
  COALESCE(SUM(i.Quantity),0) AS TotalInward,
  COALESCE(SUM(o.Quantity),0) AS TotalOutward,
  (COALESCE(SUM(i.Quantity),0) - COALESCE(SUM(o.Quantity),0)) AS NetStock
FROM Products p
LEFT JOIN Inward i ON p.ProductID = i.ProductID
LEFT JOIN Outward o ON p.ProductID = o.ProductID
GROUP BY p.ProductID, p.ProductName;

--	Use JOIN to display product stock with movement history.
SELECT 
  p.ProductID,
  p.ProductName,
  sl.CurrentStock,
  COALESCE(SUM(i.Quantity),0) AS TotalInward,
  COALESCE(SUM(o.Quantity),0) AS TotalOutward
FROM Products p
LEFT JOIN StockLevels sl ON p.ProductID = sl.ProductID
LEFT JOIN Inward i ON p.ProductID = i.ProductID
LEFT JOIN Outward o ON p.ProductID = o.ProductID
GROUP BY p.ProductID, p.ProductName, sl.CurrentStock;

--	Use HAVING to find items with negative stock (potential errors).
SELECT 
  p.ProductID,
  p.ProductName,
  (COALESCE(SUM(i.Quantity),0) - COALESCE(SUM(o.Quantity),0)) AS NetStock
FROM Products p
LEFT JOIN Inward i ON p.ProductID = i.ProductID
LEFT JOIN Outward o ON p.ProductID = o.ProductID
GROUP BY p.ProductID, p.ProductName
HAVING NetStock < 0;

-- Update stock based on movement and rollback if there's inconsistency.

START TRANSACTION;

SELECT CurrentStock INTO @stock FROM StockLevels WHERE ProductID = 1;

UPDATE StockLevels 
SET CurrentStock = CurrentStock - 150 
WHERE ProductID = 1 AND @stock >= 150;

COMMIT;



