CREATE DATABASE checkerDB;
USE checkerDB;

CREATE TABLE Products (
  ProductID INT PRIMARY KEY,
  ProductName VARCHAR(100) NOT NULL
);

CREATE TABLE Store1_Inventory (
  ProductID INT,
  Quantity INT,
  FOREIGN KEY (ProductID) REFERENCES Products(ProductID)
);

CREATE TABLE Store2_Inventory (
  ProductID INT,
  Quantity INT,
  FOREIGN KEY (ProductID) REFERENCES Products(ProductID)
);

INSERT INTO Products (ProductID, ProductName) VALUES
(1, 'Laptop'),
(2, 'Mouse'),
(3, 'Keyboard'),
(4, 'Monitor');


INSERT INTO Store1_Inventory (ProductID, Quantity) VALUES
(1, 10),
(2, 50),
(3, 20);


INSERT INTO Store2_Inventory (ProductID, Quantity) VALUES
(1, 10),
(2, 50),
(4, 15);

--	Use UNION, INTERSECT, and EXCEPT to compare inventories.
SELECT ProductID FROM Store1_Inventory
UNION
SELECT ProductID FROM Store2_Inventory;

SELECT ProductID FROM Store1_Inventory
WHERE ProductID IN (
  SELECT ProductID FROM Store2_Inventory
);

SELECT ProductID FROM Store1_Inventory
WHERE ProductID NOT IN (
  SELECT ProductID FROM Store2_Inventory
);

--	Use joins to merge store data.
SELECT 
  p.ProductID,
  p.ProductName,
  s1.Quantity AS Store1_Qty,
  s2.Quantity AS Store2_Qty
FROM Products p
LEFT JOIN Store1_Inventory s1 ON p.ProductID = s1.ProductID
LEFT JOIN Store2_Inventory s2 ON p.ProductID = s2.ProductID;

--	Use DISTINCT and GROUP BY to detect duplicates.
SELECT ProductID, COUNT(*) AS EntryCount
FROM Store1_Inventory
GROUP BY ProductID
HAVING COUNT(*) > 1;

--	Update incorrect entries using UPDATE and transaction blocks
START TRANSACTION;

UPDATE Store2_Inventory
SET Quantity = 10
WHERE ProductID = 4;

SELECT * FROM Store2_Inventory WHERE ProductID = 4;

COMMIT;