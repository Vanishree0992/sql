CREATE DATABASE Retail_DW;
USE Retail_DW;

CREATE TABLE Dim_Product (
  product_id INT PRIMARY KEY,
  product_name VARCHAR(50),
  category VARCHAR(50)
);

CREATE TABLE Dim_Customer (
  customer_id INT PRIMARY KEY,
  first_name VARCHAR(50),
  last_name VARCHAR(50),
  email VARCHAR(100),
  segment VARCHAR(50)
);

CREATE TABLE Dim_Time (
  time_id INT PRIMARY KEY,
  date DATE,
  month INT,
  quarter INT,
  year INT
);

CREATE TABLE Dim_Location (
  location_id INT PRIMARY KEY,
  city VARCHAR(50),
  region VARCHAR(50)
);

CREATE TABLE Fact_Sales (
  sales_id INT PRIMARY KEY,
  product_id INT,
  customer_id INT,
  time_id INT,
  location_id INT,
  quantity INT,
  total_amount DECIMAL(12,2),
  FOREIGN KEY (product_id) REFERENCES Dim_Product(product_id),
  FOREIGN KEY (customer_id) REFERENCES Dim_Customer(customer_id),
  FOREIGN KEY (time_id) REFERENCES Dim_Time(time_id),
  FOREIGN KEY (location_id) REFERENCES Dim_Location(location_id)
);

-- Dim_Product
INSERT INTO Dim_Product VALUES
 (1, 'Shirt', 'Apparel'),
 (2, 'TV', 'Electronics'),
 (3, 'Shoes', 'Footwear');

-- Dim_Customer
INSERT INTO Dim_Customer VALUES
 (1, 'John', 'Doe', 'john@example.com', 'Regular'),
 (2, 'Jane', 'Smith', 'jane@example.com', 'VIP'),
 (3, 'Bob', 'Brown', 'bob@example.com', 'Regular');

-- Dim_Time
INSERT INTO Dim_Time VALUES
 (1, '2025-01-10', 1, 1, 2025),
 (2, '2025-02-15', 2, 1, 2025),
 (3, '2025-03-20', 3, 1, 2025);

-- Dim_Location
INSERT INTO Dim_Location VALUES
 (1, 'New York', 'East'),
 (2, 'Los Angeles', 'West'),
 (3, 'Chicago', 'Midwest');

-- Staging Orders table
CREATE TABLE Orders_Staging (
  order_id INT,
  product_id INT,
  customer_id INT,
  order_date DATE,
  location_id INT,
  quantity INT,
  total_amount DECIMAL(12,2)
);


-- Load sample staging data
INSERT INTO Orders_Staging VALUES
 (1, 1, 1, '2025-01-10', 1, 2, 1000.00),
 (2, 2, 2, '2025-02-15', 2, 1, 5000.00),
 (3, 3, 3, '2025-03-20', 3, 1, 2000.00);

-- 1. Transform names: uppercase first/last
UPDATE Dim_Customer
SET first_name = UPPER(first_name),
    last_name = UPPER(last_name)
WHERE customer_id > 0;

-- 2. Load into Fact_Sales (join to Dim_Time)
INSERT INTO Fact_Sales (sales_id, product_id, customer_id, time_id, location_id, quantity, total_amount)
SELECT 
  o.order_id,
  o.product_id,
  o.customer_id,
  t.time_id,
  o.location_id,
  o.quantity,
  o.total_amount
FROM 
  Orders_Staging o
  JOIN Dim_Time t ON o.order_date = t.date;

-- Top-Selling Products
SELECT 
  p.product_name,
  SUM(f.quantity) AS total_units_sold,
  SUM(f.total_amount) AS total_revenue
FROM 
  Fact_Sales f
  JOIN Dim_Product p ON f.product_id = p.product_id
GROUP BY 
  p.product_name
ORDER BY 
  total_revenue DESC
LIMIT 5;

-- Monthly Revenue
SELECT 
  t.year,
  t.month,
  SUM(f.total_amount) AS monthly_revenue
FROM 
  Fact_Sales f
  JOIN Dim_Time t ON f.time_id = t.time_id
GROUP BY 
  t.year, t.month
ORDER BY 
  t.year, t.month;

-- Customer Segments
SELECT 
  c.segment,
  COUNT(DISTINCT f.customer_id) AS num_customers,
  SUM(f.total_amount) AS total_spent
FROM 
  Fact_Sales f
  JOIN Dim_Customer c ON f.customer_id = c.customer_id
GROUP BY 
  c.segment;
