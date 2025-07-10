CREATE DATABASE product_search;
USE product_search;

CREATE TABLE Categories (
  category_id INT PRIMARY KEY AUTO_INCREMENT,
  category_name VARCHAR(100)
);

CREATE TABLE Products (
  product_id INT PRIMARY KEY AUTO_INCREMENT,
  product_name VARCHAR(100),
  category_id INT,
  price DECIMAL(10,2),
  discount DECIMAL(5,2), -- percent
  stock INT,
  FOREIGN KEY (category_id) REFERENCES Categories(category_id)
);

CREATE TABLE ProductAudit (
  audit_id INT PRIMARY KEY AUTO_INCREMENT,
  product_id INT,
  action VARCHAR(50),
  old_price DECIMAL(10,2),
  new_price DECIMAL(10,2),
  updated_on DATETIME DEFAULT CURRENT_TIMESTAMP
);

INSERT INTO Categories (category_name) VALUES 
('Electronics'), ('Books'), ('Clothing');

INSERT INTO Products (product_name, category_id, price, discount, stock) VALUES
('Laptop', 1, 800.00, 10, 15),
('Smartphone', 1, 600.00, 5, 0),
('Tablet', 1, 300.00, 15, 10),
('Headphones', 1, 50.00, 0, 25),
('Monitor', 1, 200.00, 5, 5),
('Keyboard', 1, 30.00, 0, 50),
('Novel', 2, 15.00, 0, 100),
('Biography', 2, 20.00, 5, 30),
('Science Textbook', 2, 100.00, 10, 0),
('Children Book', 2, 12.00, 0, 40),
('T-Shirt', 3, 25.00, 5, 200),
('Jeans', 3, 40.00, 10, 150),
('Jacket', 3, 80.00, 15, 0),
('Dress', 3, 60.00, 20, 80),
('Shorts', 3, 20.00, 0, 70),
('Sweater', 3, 45.00, 5, 60),
('Sneakers', 3, 70.00, 10, 90),
('Sandals', 3, 30.00, 0, 100),
('Hat', 3, 15.00, 0, 110),
('Socks', 3, 5.00, 0, 300);

-- View: Available Products Only
CREATE OR REPLACE VIEW AvailableProductsView AS
SELECT 
  p.product_id,
  p.product_name,
  c.category_name,
  p.price,
  p.discount,
  p.stock
FROM Products p
JOIN Categories c ON p.category_id = c.category_id
WHERE p.stock > 0;
SELECT * FROM AvailableProductsView;

-- Function: Return price after discount
DELIMITER $$

CREATE FUNCTION GetPriceAfterDiscount(p_price DECIMAL(10,2), p_discount DECIMAL(5,2))
RETURNS DECIMAL(10,2)
DETERMINISTIC
BEGIN
  RETURN p_price * (1 - p_discount / 100);
END$$

DELIMITER ;
SELECT GetPriceAfterDiscount(200, 15) AS FinalPrice;

-- Stored Procedure: Filter by category & price range
DELIMITER $$

CREATE PROCEDURE GetProductsByCategoryAndPrice(
  IN p_category_id INT,
  IN p_min_price DECIMAL(10,2),
  IN p_max_price DECIMAL(10,2)
)
BEGIN
  SELECT 
    p.product_id,
    p.product_name,
    c.category_name,
    p.price,
    p.discount,
    p.stock
  FROM Products p
  JOIN Categories c ON p.category_id = c.category_id
  WHERE p.category_id = p_category_id
    AND p.price BETWEEN p_min_price AND p_max_price
    AND p.stock > 0;
END$$

DELIMITER ;
CALL GetProductsByCategoryAndPrice(1, 100, 900);

-- Trigger: Log product updates
DELIMITER $$

CREATE TRIGGER trg_log_product_update
AFTER UPDATE ON Products
FOR EACH ROW
BEGIN
  IF OLD.price != NEW.price THEN
    INSERT INTO ProductAudit (product_id, action, old_price, new_price)
    VALUES (NEW.product_id, 'Price Changed', OLD.price, NEW.price);
  END IF;
END$$

DELIMITER ;
UPDATE Products SET price = 850 WHERE product_id = 1;
SELECT * FROM ProductAudit;

-- When discount logic changes: Recreate view
DROP VIEW IF EXISTS AvailableProductsView;

CREATE OR REPLACE VIEW AvailableProductsView AS
SELECT 
  p.product_id,
  p.product_name,
  c.category_name,
  p.price,
  p.discount,
  GetPriceAfterDiscount(p.price, p.discount) AS final_price,
  p.stock
FROM Products p
JOIN Categories c ON p.category_id = c.category_id
WHERE p.stock > 0;
SELECT * FROM AvailableProductsView;