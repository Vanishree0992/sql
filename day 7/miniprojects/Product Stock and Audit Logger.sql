CREATE DATABASE product_stock_audit;
USE product_stock_audit;

CREATE TABLE Products (
  product_id INT PRIMARY KEY AUTO_INCREMENT,
  product_name VARCHAR(100),
  category VARCHAR(50),
  stock_qty INT,
  supplier_price DECIMAL(10,2),
  selling_price DECIMAL(10,2)
);


CREATE TABLE StockAudit (
  audit_id INT PRIMARY KEY AUTO_INCREMENT,
  product_id INT,
  action VARCHAR(50),
  old_stock INT,
  new_stock INT,
  action_date DATETIME DEFAULT CURRENT_TIMESTAMP
);

INSERT INTO Products (product_name, category, stock_qty, supplier_price, selling_price)
VALUES 
('Laptop A', 'Electronics', 40, 500.00, 700.00),
('Laptop B', 'Electronics', 100, 600.00, 850.00),
('Mouse', 'Accessories', 30, 5.00, 10.00),
('Keyboard', 'Accessories', 80, 10.00, 20.00),
('Monitor 24"', 'Electronics', 45, 120.00, 200.00),
('Monitor 27"', 'Electronics', 55, 150.00, 250.00),
('USB Drive', 'Accessories', 20, 2.00, 5.00),
('External HDD', 'Electronics', 35, 50.00, 80.00),
('Desk Chair', 'Furniture', 60, 40.00, 90.00),
('Desk Table', 'Furniture', 15, 80.00, 150.00),
('Printer', 'Electronics', 25, 100.00, 180.00),
('Scanner', 'Electronics', 65, 90.00, 160.00),
('Speaker', 'Accessories', 45, 15.00, 30.00),
('Webcam', 'Accessories', 50, 20.00, 40.00),
('Projector', 'Electronics', 10, 200.00, 350.00),
('Smartphone', 'Electronics', 75, 300.00, 500.00),
('Tablet', 'Electronics', 80, 250.00, 450.00),
('Router', 'Accessories', 90, 25.00, 60.00),
('Switch', 'Accessories', 40, 30.00, 70.00),
('Headphones', 'Accessories', 35, 12.00, 25.00),
('Office Lamp', 'Furniture', 55, 8.00, 20.00);

-- View: LowStockItems (no supplier price)
CREATE VIEW LowStockItems AS
SELECT product_id, product_name, category, stock_qty, selling_price
FROM Products
WHERE stock_qty < 50;
SELECT * FROM LowStockItems;

-- Stored Procedure: Add new product
DELIMITER $$
CREATE PROCEDURE AddProduct(
  IN p_name VARCHAR(100),
  IN p_category VARCHAR(50),
  IN p_stock INT,
  IN p_supplier_price DECIMAL(10,2),
  IN p_selling_price DECIMAL(10,2)
)
BEGIN
  INSERT INTO Products (product_name, category, stock_qty, supplier_price, selling_price)
  VALUES (p_name, p_category, p_stock, p_supplier_price, p_selling_price);
END$$

DELIMITER ;
CALL AddProduct('New Mouse', 'Accessories', 20, 4.00, 8.00);

-- Trigger: Log insert/update to StockAudit
DELIMITER $$
CREATE TRIGGER trg_log_insert
AFTER INSERT ON Products
FOR EACH ROW
BEGIN
  INSERT INTO StockAudit (product_id, action, old_stock, new_stock)
  VALUES (NEW.product_id, 'INSERT', NULL, NEW.stock_qty);
END$$
CREATE TRIGGER trg_log_update
AFTER UPDATE ON Products
FOR EACH ROW
BEGIN
  INSERT INTO StockAudit (product_id, action, old_stock, new_stock)
  VALUES (NEW.product_id, 'UPDATE', OLD.stock_qty, NEW.stock_qty);
END$$

DELIMITER ;

SELECT * FROM StockAudit;

--  Function: Return total stock for a category
DELIMITER $$
CREATE FUNCTION GetTotalStockByCategory(cat VARCHAR(50))
RETURNS INT
DETERMINISTIC
BEGIN
  DECLARE total INT;
  SELECT SUM(stock_qty) INTO total
  FROM Products
  WHERE category = cat;
  RETURN total;
END$$
DELIMITER ;
SELECT GetTotalStockByCategory('Accessories') AS TotalStock; 