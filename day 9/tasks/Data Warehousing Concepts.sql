CREATE DATABASE data_concepts;
USE data_concepts;
-- 1 Define what a data warehouse is and list its key components.
-- Key Components:
-- Data Sources: Operational databases, flat files, APIs.
-- ETL Process: Extract, Transform, Load.
-- Staging Area: Temporary storage for cleaned data.
-- Data Storage: Star or Snowflake schema tables.
-- Metadata: Data about data.
-- OLAP Engine: Supports complex analytical queries.
-- Front-End Tools: Dashboards, reports, visualization tools.

-- 2️ Differentiate between OLTP and OLAP with real-time examples.
-- Feature	OLTP (Online Transaction Processing)	OLAP (Online Analytical Processing)
-- Purpose	Manage day-to-day transactions	Perform complex analytics
-- Data Volume	Small per transaction	Large historical data
-- Example	Order entry system	Sales performance dashboard
-- Query Type	INSERT, UPDATE, DELETE	SELECT with aggregations
-- Example Use	Booking a movie ticket	Analyzing ticket sales by genre

-- 3️ Create a table simulating a basic OLTP system for order management.

CREATE TABLE Orders (
    order_id INT PRIMARY KEY,
    customer_id INT,
    product_id INT,
    quantity INT,
    order_date DATE,
    total_amount DECIMAL(10,2)
);

-- 4 Create a separate table for OLAP queries (e.g., monthly sales summary).
CREATE TABLE Monthly_Sales_Summary (
    year INT,
    month INT,
    product_id INT,
    total_sales DECIMAL(12,2)
);

-- 5 Write a SQL query to simulate a transactional OLTP insert.
INSERT INTO Orders (order_id, customer_id, product_id, quantity, order_date, total_amount)
VALUES (1, 101, 501, 2, '2025-07-12', 1500.00);

--  Star Schema Design
-- 6 Design a Star Schema for a retail store.
-- Tables:
-- Fact_Sales(sales_id, product_id, customer_id, time_id, location_id, quantity, total_amount)
-- Dim_Product(product_id, product_name, category)
-- Dim_Customer(customer_id, customer_name, email)
-- Dim_Time(time_id, date, month, quarter, year)


CREATE TABLE Dim_Product (
    product_id INT PRIMARY KEY,
    product_name VARCHAR(50),
    category VARCHAR(50)
);

INSERT INTO Dim_Product 
VALUES 
  (1, 'Shirt', 'Apparel'),
  (2, 'Jeans', 'Apparel'),
  (3, 'TV', 'Electronics'),
  (4, 'Phone', 'Electronics'),
  (5, 'Shoes', 'Footwear');

-- 7 Insert sample data.
INSERT INTO Dim_Product VALUES (1, 'Shirt', 'Apparel'), (2, 'Jeans', 'Apparel'), (3, 'TV', 'Electronics'), (4, 'Phone', 'Electronics'), (5, 'Shoes', 'Footwear');

INSERT INTO Dim_Customer VALUES (1, 'Alice', 'alice@mail.com'), (2, 'Bob', 'bob@mail.com'), (3, 'Charlie', 'charlie@mail.com'), (4, 'David', 'david@mail.com'), (5, 'Emma', 'emma@mail.com');

INSERT INTO Dim_Time VALUES (1, '2025-07-01', 7, 3, 2025), (2, '2025-07-02', 7, 3, 2025), (3, '2025-06-15', 6, 2, 2025), (4, '2025-05-20', 5, 2, 2025), (5, '2025-04-10', 4, 2, 2025);

INSERT INTO Dim_Location VALUES (1, 'Mumbai', 'West'), (2, 'Delhi', 'North'), (3, 'Bangalore', 'South'), (4, 'Chennai', 'South'), (5, 'Kolkata', 'East');

-- Fact
INSERT INTO Fact_Sales VALUES 
(1, 1, 1, 1, 1, 2, 2000.00),
(2, 3, 2, 2, 2, 1, 25000.00),
(3, 2, 3, 3, 3, 1, 1500.00),
(4, 4, 4, 4, 4, 3, 30000.00),
(5, 5, 5, 5, 5, 2, 5000.00);

-- 8  Query to calculate total revenue by product category
CREATE TABLE Fact_Sales (
    sales_id INT PRIMARY KEY,
    product_id INT,
    customer_id INT,
    time_id INT,
    location_id INT,
    quantity INT,
    total_amount DECIMAL(12,2)
);

ALTER TABLE Fact_Sales
  ADD FOREIGN KEY (product_id) REFERENCES Dim_Product(product_id);

INSERT INTO Fact_Sales VALUES
  (1, 1, 1, 1, 1, 2, 2000.00),
  (2, 3, 2, 2, 2, 1, 25000.00),
  (3, 2, 3, 3, 3, 1, 1500.00),
  (4, 4, 4, 4, 4, 3, 30000.00),
  (5, 5, 5, 5, 5, 2, 5000.00);

SELECT 
  p.category, 
  SUM(f.total_amount) AS total_revenue
FROM 
  Fact_Sales f
  JOIN Dim_Product p ON f.product_id = p.product_id
GROUP BY 
  p.category;

-- 9 
CREATE TABLE Dim_Location (
    location_id INT PRIMARY KEY,
    city VARCHAR(50),
    region VARCHAR(50)
);

INSERT INTO Dim_Location VALUES
  (1, 'Mumbai', 'West'),
  (2, 'Delhi', 'North'),
  (3, 'Bangalore', 'South'),
  (4, 'Chennai', 'South'),
  (5, 'Kolkata', 'East');

SELECT 
  l.region, 
  SUM(f.total_amount) AS total_sales
FROM 
  Fact_Sales f
  JOIN Dim_Location l ON f.location_id = l.location_id
GROUP BY 
  l.region;

-- 10.	Write a query that joins all dimension tables with the fact table.
CREATE TABLE Dim_Customer (
    customer_id INT PRIMARY KEY,
    customer_name VARCHAR(50),
    email VARCHAR(100)
);

INSERT INTO Dim_Customer VALUES
  (1, 'Alice', 'alice@mail.com'),
  (2, 'Bob', 'bob@mail.com'),
  (3, 'Charlie', 'charlie@mail.com'),
  (4, 'David', 'david@mail.com'),
  (5, 'Emma', 'emma@mail.com');

CREATE TABLE Dim_Time (
    time_id INT PRIMARY KEY,
    date DATE,
    month INT,
    quarter INT,
    year INT
);

INSERT INTO Dim_Time VALUES
  (1, '2025-07-01', 7, 3, 2025),
  (2, '2025-07-02', 7, 3, 2025),
  (3, '2025-06-15', 6, 2, 2025),
  (4, '2025-05-20', 5, 2, 2025),
  (5, '2025-04-10', 4, 2, 2025);

SELECT 
  f.sales_id, f.quantity, f.total_amount,
  p.product_name, p.category,
  c.customer_name, 
  t.date, t.month, t.year,
  l.city, l.region
FROM Fact_Sales f
JOIN Dim_Product p ON f.product_id = p.product_id
JOIN Dim_Customer c ON f.customer_id = c.customer_id
JOIN Dim_Time t ON f.time_id = t.time_id
JOIN Dim_Location l ON f.location_id = l.location_id;
