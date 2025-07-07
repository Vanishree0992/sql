CREATE DATABASE Sales_incenticeDB;
USE Sales_incenticeDB;

CREATE TABLE Salespeople (
  SalespersonID INT PRIMARY KEY AUTO_INCREMENT,
  SalespersonName VARCHAR(100) NOT NULL
);

CREATE TABLE Sales (
  SaleID INT PRIMARY KEY AUTO_INCREMENT,
  SalespersonID INT NOT NULL,
  SaleAmount DECIMAL(10,2) NOT NULL CHECK (SaleAmount >= 0),
  SaleDate DATE NOT NULL,
  FOREIGN KEY (SalespersonID) REFERENCES Salespeople(SalespersonID)
);

CREATE TABLE Bonuses (
  BonusID INT PRIMARY KEY AUTO_INCREMENT,
  SalespersonID INT NOT NULL,
  TotalSales DECIMAL(10,2) NOT NULL,
  BonusTier VARCHAR(20) NOT NULL,
  BonusAmount DECIMAL(10,2) NOT NULL,
  FOREIGN KEY (SalespersonID) REFERENCES Salespeople(SalespersonID)
);

INSERT INTO Salespeople (SalespersonName)
VALUES 
('Alice'),
('Bob'),
('Carol');

INSERT INTO Sales (SalespersonID, SaleAmount, SaleDate)
VALUES
(1, 5000.00, '2025-07-01'),
(1, 3000.00, '2025-07-05'),
(2, 2000.00, '2025-07-02'),
(2, 1500.00, '2025-07-03'),
(3, 1000.00, '2025-07-04');

--	Use CASE to assign bonus tiers.
SELECT 
  SalespersonID,
  SalespersonName,
  TotalSales,
  CASE
    WHEN TotalSales >= 7000 THEN 'High'
    WHEN TotalSales >= 4000 THEN 'Medium'
    ELSE 'Low'
  END AS BonusTier,
  CASE
    WHEN TotalSales >= 7000 THEN 1000
    WHEN TotalSales >= 4000 THEN 500
    ELSE 200
  END AS BonusAmount
FROM (
  SELECT 
    s.SalespersonID,
    sp.SalespersonName,
    SUM(s.SaleAmount) AS TotalSales
  FROM Sales s
  JOIN Salespeople sp ON s.SalespersonID = sp.SalespersonID
  GROUP BY s.SalespersonID, sp.SalespersonName
) AS SalesSummary;

--	Use SUM() and AVG() to analyze sales data.
SELECT 
  s.SalespersonID,
  sp.SalespersonName,
  SUM(s.SaleAmount) AS TotalSales,
  AVG(s.SaleAmount) AS AverageSale
FROM Sales s
JOIN Salespeople sp ON s.SalespersonID = sp.SalespersonID
GROUP BY s.SalespersonID, sp.SalespersonName;
--	Use transactions to update bonus and rollback if sales data is incomplete.
START TRANSACTION;

-- Example: Insert bonuses for each salesperson
INSERT INTO Bonuses (SalespersonID, TotalSales, BonusTier, BonusAmount)
SELECT 
  SalespersonID,
  TotalSales,
  CASE
    WHEN TotalSales >= 7000 THEN 'High'
    WHEN TotalSales >= 4000 THEN 'Medium'
    ELSE 'Low'
  END AS BonusTier,
  CASE
    WHEN TotalSales >= 7000 THEN 1000
    WHEN TotalSales >= 4000 THEN 500
    ELSE 200
  END AS BonusAmount
FROM (
  SELECT 
    s.SalespersonID,
    SUM(s.SaleAmount) AS TotalSales
  FROM Sales s
  GROUP BY s.SalespersonID
) AS SalesSummary;

-- Check if any salesperson has NULL or missing sales
SELECT COUNT(*) INTO @missing_sales
FROM Salespeople sp
LEFT JOIN Sales s ON sp.SalespersonID = s.SalespersonID
GROUP BY sp.SalespersonID
HAVING COUNT(s.SaleID) = 0;

 COMMIT;

