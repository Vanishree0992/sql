CREATE DATABASE RegionalRevenueDB;
USE RegionalRevenueDB;

CREATE TABLE Dim_Location (
  location_id INT PRIMARY KEY,
  region VARCHAR(50),
  city VARCHAR(50)
);

CREATE TABLE Dim_Customer (
  customer_id INT PRIMARY KEY,
  customer_name VARCHAR(50),
  location_id INT,
  FOREIGN KEY (location_id) REFERENCES Dim_Location(location_id)
);

CREATE TABLE Dim_Product (
  product_id INT PRIMARY KEY,
  product_name VARCHAR(50),
  category VARCHAR(50)
);

CREATE TABLE Fact_Orders (
  order_id INT PRIMARY KEY,
  customer_id INT,
  product_id INT,
  order_date DATE,
  quantity INT,
  total_amount DECIMAL(12,2),
  FOREIGN KEY (customer_id) REFERENCES Dim_Customer(customer_id),
  FOREIGN KEY (product_id) REFERENCES Dim_Product(product_id)
);

INSERT INTO Dim_Location VALUES
 (1, 'North', 'Delhi'),
 (2, 'South', 'Chennai'),
 (3, 'West', 'Mumbai'),
 (4, 'East', 'Kolkata');

INSERT INTO Dim_Customer VALUES
 (1, 'John Doe', 1),
 (2, 'Jane Smith', 2),
 (3, 'Bob Brown', 3),
 (4, 'Alice White', 4);

INSERT INTO Dim_Product VALUES
 (1, 'Shirt', 'Apparel'),
 (2, 'TV', 'Electronics'),
 (3, 'Shoes', 'Footwear');

INSERT INTO Fact_Orders VALUES
 (1, 1, 1, '2025-01-10', 2, 1000.00),   -- North - Apparel
 (2, 2, 2, '2025-01-15', 1, 20000.00), -- South - Electronics
 (3, 3, 3, '2025-02-05', 1, 2000.00),  -- West - Footwear
 (4, 4, 1, '2025-02-20', 3, 1500.00),  -- East - Apparel
 (5, 1, 2, '2025-03-01', 1, 15000.00), -- North - Electronics
 (6, 2, 1, '2025-03-25', 2, 1000.00);  -- South - Apparel

-- Regional Revenue Tracker Query
SELECT 
  l.region,
  p.category,
  SUM(f.total_amount) AS total_revenue
FROM 
  Fact_Orders f
  JOIN Dim_Customer c ON f.customer_id = c.customer_id
  JOIN Dim_Location l ON c.location_id = l.location_id
  JOIN Dim_Product p ON f.product_id = p.product_id
GROUP BY 
  l.region, p.category
HAVING 
  SUM(f.total_amount) > 5000
ORDER BY 
  l.region, total_revenue DESC;
