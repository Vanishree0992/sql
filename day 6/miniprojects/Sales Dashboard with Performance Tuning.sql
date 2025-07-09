CREATE DATABASE Sales_performanceDB;
USE Sales_performanceDB;

CREATE TABLE Customers (
  customer_id INT AUTO_INCREMENT PRIMARY KEY,
  customer_name VARCHAR(100) NOT NULL,
  email VARCHAR(100)
);

CREATE TABLE SalesPersons (
  salesperson_id INT AUTO_INCREMENT PRIMARY KEY,
  salesperson_name VARCHAR(100) NOT NULL,
  region VARCHAR(50)
);

CREATE TABLE Products (
  product_id INT AUTO_INCREMENT PRIMARY KEY,
  product_name VARCHAR(100) NOT NULL,
  price DECIMAL(10,2) NOT NULL
);

CREATE TABLE Sales (
  sale_id INT AUTO_INCREMENT PRIMARY KEY,
  sale_date DATE NOT NULL,
  product_id INT NOT NULL,
  customer_id INT NOT NULL,
  salesperson_id INT NOT NULL,
  quantity INT NOT NULL,
  total_amount DECIMAL(12,2) NOT NULL,
  FOREIGN KEY (product_id) REFERENCES Products(product_id),
  FOREIGN KEY (customer_id) REFERENCES Customers(customer_id),
  FOREIGN KEY (salesperson_id) REFERENCES SalesPersons(salesperson_id)
);

CREATE INDEX idx_sale_date ON Sales(sale_date);
CREATE INDEX idx_product_id ON Sales(product_id);
CREATE INDEX idx_customer_id ON Sales(customer_id);

-- Customers
INSERT INTO Customers (customer_name, email) VALUES
('Alice Johnson', 'alice@example.com'),
('Bob Smith', 'bob@example.com'),
('Carol White', 'carol@example.com');

-- SalesPersons
INSERT INTO SalesPersons (salesperson_name, region) VALUES
('David Lee', 'East'),
('Eva Green', 'West');

-- Products
INSERT INTO Products (product_name, price) VALUES
('Laptop', 1200.00),
('Smartphone', 800.00),
('Tablet', 500.00);

-- Sales (>25 rows)
INSERT INTO Sales (sale_date, product_id, customer_id, salesperson_id, quantity, total_amount) VALUES
('2025-06-01', 1, 1, 1, 1, 1200.00),
('2025-06-02', 2, 1, 2, 2, 1600.00),
('2025-06-03', 3, 2, 1, 1, 500.00),
('2025-06-04', 1, 2, 2, 1, 1200.00),
('2025-06-05', 2, 3, 1, 1, 800.00),
('2025-06-06', 1, 1, 2, 2, 2400.00),
('2025-06-07', 2, 1, 1, 1, 800.00),
('2025-06-08', 3, 2, 2, 1, 500.00),
('2025-06-09', 1, 2, 1, 1, 1200.00),
('2025-06-10', 2, 3, 2, 1, 800.00),
('2025-06-11', 1, 1, 1, 1, 1200.00),
('2025-06-12', 2, 1, 2, 2, 1600.00),
('2025-06-13', 3, 2, 1, 1, 500.00),
('2025-06-14', 1, 2, 2, 1, 1200.00),
('2025-06-15', 2, 3, 1, 1, 800.00),
('2025-06-16', 1, 1, 2, 2, 2400.00),
('2025-06-17', 2, 1, 1, 1, 800.00),
('2025-06-18', 3, 2, 2, 1, 500.00),
('2025-06-19', 1, 2, 1, 1, 1200.00),
('2025-06-20', 2, 3, 2, 1, 800.00),
('2025-06-21', 1, 1, 1, 1, 1200.00),
('2025-06-22', 2, 1, 2, 2, 1600.00),
('2025-06-23', 3, 2, 1, 1, 500.00),
('2025-06-24', 1, 2, 2, 1, 1200.00),
('2025-06-25', 2, 3, 1, 1, 800.00);


SELECT 
  DATE_FORMAT(sale_date, '%Y-%m') AS sale_month,
  SUM(total_amount) AS total_sales
FROM Sales
GROUP BY sale_month
HAVING total_sales > 2000;

EXPLAIN
SELECT 
  DATE_FORMAT(sale_date, '%Y-%m') AS sale_month,
  SUM(total_amount) AS total_sales
FROM Sales
GROUP BY sale_month
HAVING total_sales > 2000;

CREATE TABLE SalesSummary AS
SELECT
  s.sale_id,
  s.sale_date,
  p.product_name,
  c.customer_name,
  sp.salesperson_name,
  s.quantity,
  s.total_amount
FROM Sales s
JOIN Products p ON s.product_id = p.product_id
JOIN Customers c ON s.customer_id = c.customer_id
JOIN SalesPersons sp ON s.salesperson_id = sp.salesperson_id;


SELECT *
FROM SalesSummary
ORDER BY sale_date DESC
LIMIT 10;