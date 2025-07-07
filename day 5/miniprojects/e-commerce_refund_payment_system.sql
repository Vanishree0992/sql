CREATE DATABASE Ecommerce_refundDB;
USE Ecommerce_refundDB;

CREATE TABLE Orders (
  OrderID INT PRIMARY KEY AUTO_INCREMENT,
  CustomerName VARCHAR(100) NOT NULL,
  OrderDate DATE NOT NULL,
  TotalAmount DECIMAL(10,2) NOT NULL,
  Status ENUM('PLACED', 'SHIPPED', 'DELIVERED', 'CANCELLED') DEFAULT 'PLACED'
);

CREATE TABLE Payments (
  PaymentID INT PRIMARY KEY AUTO_INCREMENT,
  OrderID INT NOT NULL,
  PaymentDate DATE NOT NULL,
  Amount DECIMAL(10,2) NOT NULL,
  PaymentMethod VARCHAR(50),
  FOREIGN KEY (OrderID) REFERENCES Orders(OrderID)
);

CREATE TABLE Refunds (
  RefundID INT PRIMARY KEY AUTO_INCREMENT,
  OrderID INT NOT NULL,
  RefundDate TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
  Amount DECIMAL(10,2) NOT NULL,
  Reason VARCHAR(255),
  FOREIGN KEY (OrderID) REFERENCES Orders(OrderID)
);

INSERT INTO Orders (CustomerName, OrderDate, TotalAmount, Status)
VALUES
('Alice Johnson', '2025-07-01', 250.00, 'PLACED'),
('Bob Smith', '2025-07-02', 400.00, 'DELIVERED'),
('Carol White', '2025-07-03', 150.00, 'SHIPPED');

INSERT INTO Payments (OrderID, PaymentDate, Amount, PaymentMethod)
VALUES
(1, '2025-07-01', 250.00, 'Credit Card'),
(2, '2025-07-02', 400.00, 'PayPal'),
(3, '2025-07-03', 150.00, 'Debit Card');

--	Use DELETE to cancel an order and insert into the Refunds table in one transaction.
START TRANSACTION;

SELECT Status FROM Orders WHERE OrderID = 1;
INSERT INTO Refunds (OrderID, RefundDate, Amount, Reason)
SELECT 
  OrderID, CURRENT_DATE, TotalAmount, 'Customer Request'
FROM Orders
WHERE OrderID = 1;

DELETE FROM Orders WHERE OrderID = 1;

COMMIT;

--	Use subqueries to check if an order is eligible for refund.
SELECT OrderID, Status
FROM Orders
WHERE OrderID = 1 AND Status IN ('PLACED', 'DELIVERED');

--	Use JOIN to get complete refund summaries.
SELECT 
  r.RefundID,
  r.RefundDate,
  o.CustomerName,
  r.Amount,
  r.Reason,
  p.PaymentMethod
FROM Refunds r
JOIN Orders o ON r.OrderID = o.OrderID
JOIN Payments p ON r.OrderID = p.OrderID;

--	Use CASE to categorize refund reasons.
SELECT 
  RefundID,
  Reason,
  Amount,
  CASE 
    WHEN Reason LIKE '%Customer%' THEN 'Customer Initiated'
    WHEN Reason LIKE '%Damaged%' THEN 'Product Issue'
    WHEN Reason LIKE '%Late%' THEN 'Delivery Issue'
    ELSE 'Other'
  END AS ReasonCategory
FROM Refunds;
