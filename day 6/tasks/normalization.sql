USE sql_24DB;
-- 36.	Design an unnormalized table SalesData with repeated columns for multiple products per order.
CREATE TABLE SalesData (
  order_id INT,
  customer_name VARCHAR(50),
  product1 VARCHAR(50),
  product2 VARCHAR(50),
  product3 VARCHAR(50)
);

-- Insert example record
INSERT INTO SalesData (order_id, customer_name, product1, product2, product3)
VALUES (1, 'Alice', 'Laptop', 'Mouse', 'Keyboard'),
       (2, 'Bob', 'Monitor', 'Headphones', NULL),
       (3, 'Charlie', 'Laptop', NULL, NULL);

SELECT * FROM SalesData;
-- 37.	Apply 1NF: Remove repeating groups by creating individual rows for each product.
DROP TABLE IF EXISTS SalesData_1NF;

CREATE TABLE SalesData_1NF (
  order_id INT,
  customer_name VARCHAR(50),
  product_name VARCHAR(50)
);

-- Insert normalized rows
INSERT INTO SalesData_1NF VALUES (1, 'Alice', 'Laptop');
INSERT INTO SalesData_1NF VALUES (1, 'Alice', 'Mouse');
INSERT INTO SalesData_1NF VALUES (1, 'Alice', 'Keyboard');
INSERT INTO SalesData_1NF VALUES (2, 'Bob', 'Monitor');
INSERT INTO SalesData_1NF VALUES (2, 'Bob', 'Headphones');
INSERT INTO SalesData_1NF VALUES (3, 'Charlie', 'Laptop');

SELECT * FROM SalesData_1NF;

-- 38.	Apply 2NF: Remove partial dependency by creating a Products table.
DROP TABLE IF EXISTS Products;

CREATE TABLE Products (
  product_id INT AUTO_INCREMENT PRIMARY KEY,
  product_name VARCHAR(50)
);

-- Insert unique products
INSERT INTO Products (product_name)
SELECT DISTINCT product_name FROM SalesData_1NF;

SELECT * FROM Products;
-- 39.	Apply 3NF: Remove transitive dependency by separating customer info into a Customers table.
-- 40.	Create Orders, Customers, and OrderItems tables with proper foreign keys and normalize data.
DROP TABLE IF EXISTS Customers;

CREATE TABLE Customers (
  customer_id INT AUTO_INCREMENT PRIMARY KEY,
  customer_name VARCHAR(50)
);

-- Insert unique customers
INSERT INTO Customers (customer_name)
SELECT DISTINCT customer_name FROM SalesData_1NF;

SELECT * FROM Customers;
DROP TABLE IF EXISTS Orders;

CREATE TABLE Orders (
  order_id INT PRIMARY KEY,
  customer_id INT,
  FOREIGN KEY (customer_id) REFERENCES Customers(customer_id)
);

-- Insert example orders
INSERT INTO Orders (order_id, customer_id) VALUES
(1, 1),
(2, 2),
(3, 3);

SELECT * FROM Orders;

DROP TABLE IF EXISTS OrderItems;

CREATE TABLE OrderItems (
  order_id INT,
  product_id INT,
  FOREIGN KEY (order_id) REFERENCES Orders(order_id),
  FOREIGN KEY (product_id) REFERENCES Products(product_id)
);

-- Insert items
INSERT INTO OrderItems (order_id, product_id) VALUES
(1, 1),
(1, 2),
(1, 3),
(2, 4),
(2, 5),
(3, 1);

SELECT * FROM OrderItems;


