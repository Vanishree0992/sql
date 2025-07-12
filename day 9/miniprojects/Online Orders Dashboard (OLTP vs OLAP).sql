CREATE DATABASE OnlineOrders;
USE OnlineOrders;

-- Customers table
CREATE TABLE Customers (
  customer_id INT PRIMARY KEY,
  first_name VARCHAR(50),
  last_name VARCHAR(50),
  email VARCHAR(100)
);

-- Products table
CREATE TABLE Products (
  product_id INT PRIMARY KEY,
  product_name VARCHAR(50),
  price DECIMAL(10,2)
);

-- Orders table
CREATE TABLE Orders (
  order_id INT PRIMARY KEY,
  customer_id INT,
  product_id INT,
  order_date DATE,
  quantity INT,
  total_amount DECIMAL(12,2),
  FOREIGN KEY (customer_id) REFERENCES Customers(customer_id),
  FOREIGN KEY (product_id) REFERENCES Products(product_id)
);


-- Customers
INSERT INTO Customers VALUES
 (1, 'John', 'Doe', 'john@example.com'),
 (2, 'Jane', 'Smith', 'jane@example.com'),
 (3, 'Bob', 'Brown', 'bob@example.com');

-- Products
INSERT INTO Products VALUES
 (1, 'Shirt', 500.00),
 (2, 'TV', 20000.00),
 (3, 'Shoes', 1500.00);

-- Orders
INSERT INTO Orders VALUES
 (1, 1, 1, '2025-01-10', 2, 1000.00),
 (2, 2, 2, '2025-02-15', 1, 20000.00),
 (3, 3, 3, '2025-03-20', 1, 1500.00),
 (4, 1, 1, '2025-04-10', 1, 500.00);

INSERT INTO Orders VALUES (5, 2, 1, '2025-04-15', 2, 1000.00);

UPDATE Orders SET quantity = 3, total_amount = 1500.00 WHERE order_id = 5;

DELETE FROM Orders WHERE order_id = 5;

SELECT o.order_id, o.order_date, p.product_name, o.quantity, o.total_amount
FROM Orders o
JOIN Products p ON o.product_id = p.product_id
WHERE o.customer_id = 1;

-- Create a summary table for monthly analytics
CREATE TABLE Orders_Monthly_Summary (
  year INT,
  month INT,
  total_orders INT,
  total_revenue DECIMAL(12,2)
);

-- Populate summary from OLTP data
INSERT INTO Orders_Monthly_Summary (year, month, total_orders, total_revenue)
SELECT
  YEAR(order_date) AS year,
  MONTH(order_date) AS month,
  COUNT(*) AS total_orders,
  SUM(total_amount) AS total_revenue
FROM Orders
GROUP BY year, month;

SELECT year, month, total_orders, total_revenue
FROM Orders_Monthly_Summary
ORDER BY year, month;

SELECT year, month, total_revenue
FROM Orders_Monthly_Summary
ORDER BY total_revenue DESC
LIMIT 1;

SELECT 
  year, 
  month,
  total_revenue,
  AVG(total_revenue) OVER (
    ORDER BY year, month 
    ROWS BETWEEN 2 PRECEDING AND CURRENT ROW
  ) AS rolling_3_month_avg
FROM Orders_Monthly_Summary;
