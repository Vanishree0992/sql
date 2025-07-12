CREATE DATABASE Retail_Snowflake_Schema;
USE Retail_Snowflake_Schema;

CREATE TABLE Category_Details (
  category_id INT PRIMARY KEY,
  category_name VARCHAR(50)
);

CREATE TABLE Dim_Product_Snowflake (
  product_id INT PRIMARY KEY,
  product_name VARCHAR(50),
  category_id INT,
  FOREIGN KEY (category_id) REFERENCES Category_Details(category_id)
);

CREATE TABLE Dim_Customer (
  customer_id INT PRIMARY KEY,
  customer_name VARCHAR(50),
  email VARCHAR(100)
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
  FOREIGN KEY (product_id) REFERENCES Dim_Product_Snowflake(product_id),
  FOREIGN KEY (customer_id) REFERENCES Dim_Customer(customer_id),
  FOREIGN KEY (time_id) REFERENCES Dim_Time(time_id),
  FOREIGN KEY (location_id) REFERENCES Dim_Location(location_id)
);

INSERT INTO Category_Details VALUES
  (1, 'Apparel'),
  (2, 'Electronics'),
  (3, 'Footwear');

INSERT INTO Dim_Product_Snowflake VALUES
  (1, 'Shirt', 1),
  (2, 'Jeans', 1),
  (3, 'TV', 2),
  (4, 'Phone', 2),
  (5, 'Shoes', 3);

INSERT INTO Dim_Customer VALUES
  (1, 'Alice', 'alice@mail.com'),
  (2, 'Bob', 'bob@mail.com'),
  (3, 'Charlie', 'charlie@mail.com'),
  (4, 'David', 'david@mail.com'),
  (5, 'Emma', 'emma@mail.com');

INSERT INTO Dim_Time VALUES
  (1, '2025-07-01', 7, 3, 2025),
  (2, '2025-07-02', 7, 3, 2025),
  (3, '2025-06-15', 6, 2, 2025),
  (4, '2025-05-20', 5, 2, 2025),
  (5, '2025-04-10', 4, 2, 2025);

INSERT INTO Dim_Location VALUES
  (1, 'Mumbai', 'West'),
  (2, 'Delhi', 'North'),
  (3, 'Bangalore', 'South'),
  (4, 'Chennai', 'South'),
  (5, 'Kolkata', 'East');

INSERT INTO Fact_Sales VALUES
  (1, 1, 1, 1, 1, 2, 2000.00),
  (2, 3, 2, 2, 2, 1, 25000.00),
  (3, 2, 3, 3, 3, 1, 1500.00),
  (4, 4, 4, 4, 4, 3, 30000.00),
  (5, 5, 5, 5, 5, 2, 5000.00);

-- Total revenue per product category (Snowflake Schema)
SELECT 
  cd.category_name, 
  SUM(f.total_amount) AS total_revenue
FROM 
  Fact_Sales f
  JOIN Dim_Product_Snowflake p ON f.product_id = p.product_id
  JOIN Category_Details cd ON p.category_id = cd.category_id
GROUP BY 
  cd.category_name;

-- Compare performance Star vs Snowflake
EXPLAIN SELECT 
  cd.category_name, 
  SUM(f.total_amount) AS total_revenue
FROM 
  Fact_Sales f
  JOIN Dim_Product_Snowflake p ON f.product_id = p.product_id
  JOIN Category_Details cd ON p.category_id = cd.category_id
GROUP BY 
  cd.category_name;

-- Count number of sales per customer location
SELECT 
  l.city, 
  COUNT(f.sales_id) AS sales_count
FROM 
  Fact_Sales f
  JOIN Dim_Location l ON f.location_id = l.location_id
GROUP BY 
  l.city;
