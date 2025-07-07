CREATE DATABASE LoyaltyDB;
USE LoyaltyDB;

CREATE TABLE Customers (
  CustomerID INT PRIMARY KEY AUTO_INCREMENT,
  CustomerName VARCHAR(100) NOT NULL,
  JoinDate TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE Purchases (
  PurchaseID INT PRIMARY KEY AUTO_INCREMENT,
  CustomerID INT NOT NULL,
  PurchaseDate TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  Amount DECIMAL(10,2) NOT NULL CHECK (Amount >= 0),
  FOREIGN KEY (CustomerID) REFERENCES Customers(CustomerID)
);

CREATE TABLE Points (
  PointID INT PRIMARY KEY AUTO_INCREMENT,
  CustomerID INT NOT NULL,
  PurchaseID INT NOT NULL,
  PointsEarned INT NOT NULL CHECK (PointsEarned >= 0),
  EarnedDate TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  FOREIGN KEY (CustomerID) REFERENCES Customers(CustomerID),
  FOREIGN KEY (PurchaseID) REFERENCES Purchases(PurchaseID)
);

INSERT INTO Customers (CustomerName)
VALUES ('Alice Johnson'), ('Bob Smith'), ('Carol White');

INSERT INTO Purchases (CustomerID, PurchaseDate, Amount)
VALUES 
(1, '2025-07-01', 200.00),
(1, '2025-07-05', 150.00),
(2, '2025-07-03', 300.00),
(3, '2025-07-02', 400.00),
(3, '2025-07-06', 100.00);

INSERT INTO Points (CustomerID, PurchaseID, PointsEarned)
SELECT 
  p.CustomerID,
  p.PurchaseID,
  FLOOR(p.Amount / 10)
FROM Purchases p;

--	Use SUM(), GROUP BY to compute total spending.
SELECT 
  c.CustomerID,
  c.CustomerName,
  SUM(p.Amount) AS TotalSpent,
  CASE
    WHEN SUM(p.Amount) >= 500 THEN 'Gold'
    WHEN SUM(p.Amount) >= 300 THEN 'Silver'
    ELSE 'Bronze'
  END AS LoyaltyLevel
FROM Customers c
JOIN Purchases p ON c.CustomerID = p.CustomerID
GROUP BY c.CustomerID, c.CustomerName
ORDER BY TotalSpent DESC;

--	Use CASE to categorize loyalty levels.
--	Use subqueries to find the top spender of the month.
SELECT CustomerID, CustomerName, MonthlySpent
FROM (
  SELECT 
    c.CustomerID,
    c.CustomerName,
    SUM(p.Amount) AS MonthlySpent
  FROM Customers c
  JOIN Purchases p ON c.CustomerID = p.CustomerID
  WHERE MONTH(p.PurchaseDate) = 7 AND YEAR(p.PurchaseDate) = 2025
  GROUP BY c.CustomerID, c.CustomerName
) AS MonthlyTotals
ORDER BY MonthlySpent DESC
LIMIT 1;

--	Insert points earned with transactions for consistency

START TRANSACTION;

INSERT INTO Purchases (CustomerID, PurchaseDate, Amount)
VALUES (1, '2025-07-07', 250.00);

SET @last_purchase_id = LAST_INSERT_ID();

INSERT INTO Points (CustomerID, PurchaseID, PointsEarned)
VALUES (1, @last_purchase_id, FLOOR(250.00 / 10));

COMMIT;

