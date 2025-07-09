CREATE DATABASE ECommerce_productDB;
USE ECommerce_productDB;

CREATE TABLE Categories (
  category_id INT AUTO_INCREMENT PRIMARY KEY,
  category_name VARCHAR(100) NOT NULL
);

CREATE TABLE Products (
  product_id INT AUTO_INCREMENT PRIMARY KEY,
  product_name VARCHAR(200) NOT NULL,
  category_id INT NOT NULL,
  price DECIMAL(10,2) NOT NULL,
  description TEXT,
  FOREIGN KEY (category_id) REFERENCES Categories(category_id)
);

CREATE TABLE Inventory (
  inventory_id INT AUTO_INCREMENT PRIMARY KEY,
  product_id INT NOT NULL,
  stock_quantity INT NOT NULL,
  FOREIGN KEY (product_id) REFERENCES Products(product_id)
);

CREATE INDEX idx_product_name ON Products(product_name);
CREATE INDEX idx_category_id ON Products(category_id);
CREATE INDEX idx_price ON Products(price);

INSERT INTO Categories (category_name) VALUES
('Electronics'),
('Clothing'),
('Books');

INSERT INTO Products (product_name, category_id, price, description) VALUES
('Smartphone', 1, 699.99, 'Latest smartphone with 128GB storage'),
('Laptop', 1, 1299.99, 'High performance laptop'),
('Headphones', 1, 199.99, 'Noise-cancelling headphones'),
('T-Shirt', 2, 19.99, '100% cotton t-shirt'),
('Jeans', 2, 49.99, 'Comfort fit jeans'),
('Novel Book', 3, 14.99, 'Bestselling fiction novel'),
('Science Textbook', 3, 89.99, 'Physics textbook for college');

INSERT INTO Inventory (product_id, stock_quantity) VALUES
(1, 50),
(2, 30),
(3, 100),
(4, 200),
(5, 150),
(6, 80),
(7, 40);

EXPLAIN
SELECT 
  p.product_id,
  p.product_name,
  p.price,
  c.category_name
FROM Products p
JOIN Categories c ON p.category_id = c.category_id
WHERE p.price BETWEEN 50 AND 1000
  AND c.category_name = 'Electronics'
ORDER BY p.price ASC;

CREATE OR REPLACE VIEW ProductListing AS
SELECT 
  p.product_id,
  p.product_name,
  c.category_name,
  p.price,
  i.stock_quantity,
  p.description
FROM Products p
JOIN Categories c ON p.category_id = c.category_id
JOIN Inventory i ON p.product_id = i.product_id;

SELECT *
FROM ProductListing
ORDER BY price ASC
LIMIT 5;