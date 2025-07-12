CREATE DATABASE SalesComparisonDB;
USE SalesComparisonDB;

-- Product Dimension (includes category directly)
CREATE TABLE Dim_Product_Star (
  product_id INT PRIMARY KEY,
  product_name VARCHAR(50),
  category_name VARCHAR(50)
);

-- Fact table
CREATE TABLE Fact_Sales_Star (
  sales_id INT PRIMARY KEY,
  product_id INT,
  quantity INT,
  total_amount DECIMAL(12,2),
  FOREIGN KEY (product_id) REFERENCES Dim_Product_Star(product_id)
);

INSERT INTO Dim_Product_Star VALUES
 (1, 'Shirt', 'Apparel'),
 (2, 'TV', 'Electronics'),
 (3, 'Shoes', 'Footwear');

INSERT INTO Fact_Sales_Star VALUES
 (1, 1, 2, 1000.00),
 (2, 2, 1, 20000.00),
 (3, 3, 1, 2000.00),
 (4, 1, 1, 500.00);

-- Category Dimension
CREATE TABLE Dim_Category_Snowflake (
  category_id INT PRIMARY KEY,
  category_name VARCHAR(50)
);

-- Product Dimension (joins to category)
CREATE TABLE Dim_Product_Snowflake (
  product_id INT PRIMARY KEY,
  product_name VARCHAR(50),
  category_id INT,
  FOREIGN KEY (category_id) REFERENCES Dim_Category_Snowflake(category_id)
);

-- Fact table
CREATE TABLE Fact_Sales_Snowflake (
  sales_id INT PRIMARY KEY,
  product_id INT,
  quantity INT,
  total_amount DECIMAL(12,2),
  FOREIGN KEY (product_id) REFERENCES Dim_Product_Snowflake(product_id)
);

INSERT INTO Dim_Category_Snowflake VALUES
 (1, 'Apparel'),
 (2, 'Electronics'),
 (3, 'Footwear');

INSERT INTO Dim_Product_Snowflake VALUES
 (1, 'Shirt', 1),
 (2, 'TV', 2),
 (3, 'Shoes', 3);

INSERT INTO Fact_Sales_Snowflake VALUES
 (1, 1, 2, 1000.00),
 (2, 2, 1, 20000.00),
 (3, 3, 1, 2000.00),
 (4, 1, 1, 500.00);

--  Total Revenue by Category
EXPLAIN
SELECT
  p.category_name,
  SUM(f.total_amount) AS total_revenue
FROM
  Fact_Sales_Star f
  JOIN Dim_Product_Star p ON f.product_id = p.product_id
GROUP BY
  p.category_name;


-- Snowflake Schema: Total Revenue by Category
EXPLAIN
SELECT
  c.category_name,
  SUM(f.total_amount) AS total_revenue
FROM
  Fact_Sales_Snowflake f
  JOIN Dim_Product_Snowflake p ON f.product_id = p.product_id
  JOIN Dim_Category_Snowflake c ON p.category_id = c.category_id
GROUP BY
  c.category_name;

