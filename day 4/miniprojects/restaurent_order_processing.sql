CREATE DATABASE Restaurant_database;
USE Restaurant_database;

CREATE TABLE MenuItems (
  item_id INT PRIMARY KEY AUTO_INCREMENT,
  item_name VARCHAR(100) NOT NULL,
  price DECIMAL(10, 2) NOT NULL CHECK (price >= 0)
);

CREATE TABLE Orders (
  order_id INT PRIMARY KEY AUTO_INCREMENT,
  table_number INT NOT NULL,
  order_time DATETIME DEFAULT CURRENT_TIMESTAMP,
  kitchen_status ENUM('Pending', 'In Progress', 'Served', 'Cancelled') DEFAULT 'Pending'
);

CREATE TABLE OrderItems (
  order_item_id INT PRIMARY KEY AUTO_INCREMENT,
  order_id INT NOT NULL,
  item_id INT NOT NULL,
  quantity INT NOT NULL CHECK (quantity > 0),
  FOREIGN KEY (order_id) REFERENCES Orders(order_id) ON DELETE CASCADE,
  FOREIGN KEY (item_id) REFERENCES MenuItems(item_id) ON DELETE CASCADE
);


INSERT INTO MenuItems (item_name, price)
VALUES 
  ('Margherita Pizza', 8.99),
  ('Pasta Carbonara', 12.50),
  ('Caesar Salad', 6.75);

-- •	Use transaction to handle full meal order atomicity.
START TRANSACTION;

INSERT INTO Orders (table_number, kitchen_status)
VALUES (5, 'In Progress');

SET @order_id = LAST_INSERT_ID();

INSERT INTO OrderItems (order_id, item_id, quantity) VALUES 
  (@order_id, 1, 2),
  (@order_id, 3, 1);

COMMIT;

-- •	Update kitchen status 

UPDATE Orders
SET kitchen_status = 'Served'
WHERE order_id = @order_id AND order_id > 0; 

-- •	Delete cancelled orders.

DELETE FROM Orders
WHERE kitchen_status = 'Cancelled'
  AND order_id > 0; 

SELECT * FROM MenuItems;
SELECT * FROM Orders;
SELECT * FROM OrderItems;