CREATE DATABASE sales_comparison;
USE sales_comparison;

CREATE TABLE Products (
  ProductID INT PRIMARY KEY AUTO_INCREMENT,
  ProductName VARCHAR(100) NOT NULL
);

CREATE TABLE Sales (
  SaleID INT PRIMARY KEY AUTO_INCREMENT,
  ProductID INT NOT NULL,
  SaleAmount DECIMAL(10,2) NOT NULL CHECK (SaleAmount >= 0),
  SaleDate DATE NOT NULL,
  FOREIGN KEY (ProductID) REFERENCES Products(ProductID)
);

INSERT INTO Products (ProductName) VALUES
('Product A'), ('Product B'), ('Product C');

INSERT INTO Sales (ProductID, SaleAmount, SaleDate) VALUES
(1, 100.00, '2025-07-06'),
(2, 200.00, '2025-07-06'),
(3, 300.00, '2025-07-06');

INSERT INTO Sales (ProductID, SaleAmount, SaleDate) VALUES
(1, 150.00, '2025-07-07'),
(2, 100.00, '2025-07-07'),
(3, 300.00, '2025-07-07');

-- Use DATE_SUB() to get yesterday's data.
SELECT
  p.ProductID,
  p.ProductName,
  IFNULL(today.TotalToday, 0) AS TotalToday,
  IFNULL(yesterday.TotalYesterday, 0) AS TotalYesterday,
  (IFNULL(today.TotalToday, 0) - IFNULL(yesterday.TotalYesterday, 0)) AS SalesDelta,
  CASE
    WHEN IFNULL(today.TotalToday, 0) > IFNULL(yesterday.TotalYesterday, 0) THEN 'Increase'
    WHEN IFNULL(today.TotalToday, 0) < IFNULL(yesterday.TotalYesterday, 0) THEN 'Decrease'
    ELSE 'No Change'
  END AS Trend
FROM Products p
LEFT JOIN (
  SELECT ProductID, SUM(SaleAmount) AS TotalToday
  FROM Sales
  WHERE SaleDate = CURRENT_DATE
  GROUP BY ProductID
) AS today ON p.ProductID = today.ProductID
LEFT JOIN (
  SELECT ProductID, SUM(SaleAmount) AS TotalYesterday
  FROM Sales
  WHERE SaleDate = DATE_SUB(CURRENT_DATE, INTERVAL 1 DAY)
  GROUP BY ProductID
) AS yesterday ON p.ProductID = yesterday.ProductID
ORDER BY SalesDelta DESC;
