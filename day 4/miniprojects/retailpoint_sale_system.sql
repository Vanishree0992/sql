CREATE DATABASE Retail_DB;
USE Retail_DB;

CREATE TABLE Cashiers (
  cashier_id INT PRIMARY KEY AUTO_INCREMENT,
  cashier_name VARCHAR(100) NOT NULL
);

-- ============================================
-- STEP 4: Create Products table
-- ============================================

CREATE TABLE Products (
  product_id INT PRIMARY KEY AUTO_INCREMENT,
  product_name VARCHAR(100) NOT NULL,
  barcode VARCHAR(50) NOT NULL UNIQUE, -- ✅ Enforce unique barcode
  stock_quantity INT NOT NULL CHECK (stock_quantity >= 0),
  price DECIMAL(10, 2) NOT NULL CHECK (price >= 0)
);


CREATE TABLE Sales (
  sale_id INT PRIMARY KEY AUTO_INCREMENT,
  product_id INT NOT NULL,
  cashier_id INT NOT NULL,
  quantity_sold INT NOT NULL CHECK (quantity_sold > 0),
  total_amount DECIMAL(10, 2) NOT NULL CHECK (total_amount >= 0),
  sale_date DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
  FOREIGN KEY (product_id) REFERENCES Products(product_id) ON DELETE CASCADE,
  FOREIGN KEY (cashier_id) REFERENCES Cashiers(cashier_id) ON DELETE CASCADE
);

INSERT INTO Cashiers (cashier_name) VALUES ('Alice'), ('Bob');

INSERT INTO Products (product_name, barcode, stock_quantity, price)
VALUES
  ('Notebook', 'NB123456', 100, 2.50),
  ('Pen', 'PN654321', 200, 1.20);

--	Update product stock post-sale.

START TRANSACTION;

INSERT INTO Sales (product_id, cashier_id, quantity_sold, total_amount)
VALUES (1, 1, 2, 5.00);

UPDATE Products
SET stock_quantity = stock_quantity - 2
WHERE product_id = 1;

COMMIT;

--  Use SAVEPOINT for partial rollback

START TRANSACTION;

INSERT INTO Sales (product_id, cashier_id, quantity_sold, total_amount)
VALUES (2, 2, 1, 1.20);

SAVEPOINT after_pen;

UPDATE Products SET stock_quantity = stock_quantity - 1 WHERE product_id = 2;

INSERT INTO Sales (product_id, cashier_id, quantity_sold, total_amount)
VALUES (1, 2, 1, 2.50);

UPDATE Products SET stock_quantity = stock_quantity - 1 WHERE product_id = 1;

ROLLBACK TO SAVEPOINT after_pen;

COMMIT;

--	Use DELETE to remove voided sales.
DELETE FROM Sales WHERE sale_id = 1;


SELECT * FROM Products;
SELECT * FROM Sales;
SELECT * FROM Cashiers;