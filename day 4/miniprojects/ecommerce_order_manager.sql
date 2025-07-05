CREATE DATABASE ECommerce_DB;
USE ECommerce_DB;

CREATE TABLE Products (
  product_id INT PRIMARY KEY AUTO_INCREMENT,
  product_code VARCHAR(50) NOT NULL UNIQUE,
  product_name VARCHAR(100) NOT NULL,
  price DECIMAL(10, 2) NOT NULL CHECK (price >= 0),
  stock INT NOT NULL CHECK (stock >= 0)
);

CREATE TABLE Customers (
  customer_id INT PRIMARY KEY AUTO_INCREMENT,
  customer_name VARCHAR(100) NOT NULL,
  email VARCHAR(100) NOT NULL UNIQUE
);

CREATE TABLE Orders (
  order_id INT PRIMARY KEY AUTO_INCREMENT,
  customer_id INT NOT NULL,
  order_date TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  payment_status VARCHAR(50) NOT NULL DEFAULT 'Pending',
  FOREIGN KEY (customer_id) REFERENCES Customers(customer_id)
    ON DELETE CASCADE
);

CREATE TABLE OrderItems (
  order_item_id INT PRIMARY KEY AUTO_INCREMENT,
  order_id INT NOT NULL,
  product_id INT NOT NULL,
  quantity INT NOT NULL CHECK (quantity > 0),
  FOREIGN KEY (order_id) REFERENCES Orders(order_id)
    ON DELETE CASCADE,
  FOREIGN KEY (product_id) REFERENCES Products(product_id)
    ON DELETE CASCADE
);

INSERT INTO Products (product_code, product_name, price, stock)
VALUES 
  ('SKU1001', 'Laptop', 70000, 10),
  ('SKU1002', 'Smartphone', 30000, 20),
  ('SKU1003', 'Headphones', 2000, 50);

INSERT INTO Customers (customer_name, email)
VALUES 
  ('Alice Johnson', 'alice@example.com'),
  ('Bob Smith', 'bob@example.com');
  
--	Update product stock after each order.
--	Use transactions to ensure all order operations complete or none (Atomicity).

START TRANSACTION;

INSERT INTO Orders (customer_id, payment_status)
VALUES (1, 'Pending');
SET @last_order_id = LAST_INSERT_ID();

INSERT INTO OrderItems (order_id, product_id, quantity)
VALUES
  (@last_order_id, 1, 1), 
  (@last_order_id, 3, 2); 

UPDATE Products
SET stock = stock - 1
WHERE product_id = 1;

UPDATE Products
SET stock = stock - 2
WHERE product_id = 3;

UPDATE Orders
SET payment_status = 'Paid'
WHERE order_id = @last_order_id;

COMMIT;

--	Delete customer orders if payment fails.
DELETE FROM Orders
WHERE payment_status = 'Pending'
LIMIT 1;


SELECT * FROM Products;
SELECT * FROM Customers;
SELECT * FROM Orders;
SELECT * FROM OrderItems;