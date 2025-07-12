CREATE DATABASE Retail_Aggregation;
USE Retail_Aggregation;

CREATE TABLE Dim_Product (
  product_id INT PRIMARY KEY,
  product_name VARCHAR(50),
  category VARCHAR(50)
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

CREATE TABLE Fact_Sales (
  sales_id INT PRIMARY KEY,
  product_id INT,
  customer_id INT,
  time_id INT,
  quantity INT,
  total_amount DECIMAL(12,2),
  FOREIGN KEY (product_id) REFERENCES Dim_Product(product_id),
  FOREIGN KEY (customer_id) REFERENCES Dim_Customer(customer_id),
  FOREIGN KEY (time_id) REFERENCES Dim_Time(time_id)
);

INSERT INTO Dim_Product VALUES
  (1, 'Shirt', 'Apparel'),
  (2, 'Jeans', 'Apparel'),
  (3, 'TV', 'Electronics'),
  (4, 'Phone', 'Electronics'),
  (5, 'Shoes', 'Footwear');


INSERT INTO Dim_Customer VALUES
  (1, 'Alice', 'alice@mail.com'),
  (2, 'Bob', 'bob@mail.com'),
  (3, 'Charlie', 'charlie@mail.com'),
  (4, 'David', 'david@mail.com'),
  (5, 'Emma', 'emma@mail.com');


INSERT INTO Dim_Time VALUES
  (1, '2025-01-10', 1, 1, 2025),
  (2, '2025-02-15', 2, 1, 2025),
  (3, '2025-02-20', 2, 1, 2025),
  (4, '2025-03-05', 3, 1, 2025),
  (5, '2025-03-15', 3, 1, 2025),
  (6, '2025-04-10', 4, 2, 2025);


INSERT INTO Fact_Sales VALUES
  (1, 1, 1, 1, 2, 2000.00),
  (2, 2, 2, 2, 1, 1500.00),
  (3, 3, 2, 3, 1, 25000.00),
  (4, 4, 3, 4, 3, 30000.00),
  (5, 5, 4, 5, 2, 5000.00),
  (6, 1, 5, 6, 1, 1000.00);

-- Group total sales by month and year
SELECT 
  t.year, 
  t.month, 
  SUM(f.total_amount) AS total_sales
FROM 
  Fact_Sales f
  JOIN Dim_Time t ON f.time_id = t.time_id
GROUP BY 
  t.year, t.month
ORDER BY 
  t.year, t.month;

-- Filter where monthly sales > ₹10,000
SELECT 
  t.year, 
  t.month, 
  SUM(f.total_amount) AS total_sales
FROM 
  Fact_Sales f
  JOIN Dim_Time t ON f.time_id = t.time_id
GROUP BY 
  t.year, t.month
HAVING 
  SUM(f.total_amount) > 10000
ORDER BY 
  total_sales DESC;


-- Report: Number of orders per product
SELECT 
  p.product_name, 
  COUNT(f.sales_id) AS order_count
FROM 
  Fact_Sales f
  JOIN Dim_Product p ON f.product_id = p.product_id
GROUP BY 
  p.product_name;

-- Average sale amount per customer
SELECT 
  c.customer_name, 
  AVG(f.total_amount) AS avg_sale
FROM 
  Fact_Sales f
  JOIN Dim_Customer c ON f.customer_id = c.customer_id
GROUP BY 
  c.customer_name;

-- Max, Min, Avg order total per product category
SELECT 
  p.category,
  MAX(f.total_amount) AS max_order,
  MIN(f.total_amount) AS min_order,
  AVG(f.total_amount) AS avg_order
FROM 
  Fact_Sales f
  JOIN Dim_Product p ON f.product_id = p.product_id
GROUP BY 
  p.category;

-- Monthly performance: Year, Month, Total Orders, Total Revenue
SELECT 
  t.year,
  t.month,
  COUNT(f.sales_id) AS total_orders,
  SUM(f.total_amount) AS total_revenue
FROM 
  Fact_Sales f
  JOIN Dim_Time t ON f.time_id = t.time_id
GROUP BY 
  t.year, t.month
ORDER BY 
  t.year, t.month;

-- Top 5 customers by total spend
SELECT 
  c.customer_name,
  SUM(f.total_amount) AS total_spent
FROM 
  Fact_Sales f
  JOIN Dim_Customer c ON f.customer_id = c.customer_id
GROUP BY 
  c.customer_name
ORDER BY 
  total_spent DESC
LIMIT 5;

-- Identify months with decline in revenue using LAG
SELECT 
  year, 
  month, 
  total_revenue,
  total_revenue - LAG(total_revenue) OVER (ORDER BY year, month) AS revenue_change
FROM (
  SELECT 
    t.year, 
    t.month, 
    SUM(f.total_amount) AS total_revenue
  FROM 
    Fact_Sales f
    JOIN Dim_Time t ON f.time_id = t.time_id
  GROUP BY 
    t.year, t.month
) AS monthly_summary;

-- Customer retention trend by month
SELECT 
  t.year, 
  t.month, 
  COUNT(DISTINCT f.customer_id) AS active_customers
FROM 
  Fact_Sales f
  JOIN Dim_Time t ON f.time_id = t.time_id
GROUP BY 
  t.year, t.month
ORDER BY 
  t.year, t.month;

-- Analyze seasonal trends in product category sales
SELECT 
  t.month,
  p.category,
  SUM(f.total_amount) AS total_sales
FROM 
  Fact_Sales f
  JOIN Dim_Time t ON f.time_id = t.time_id
  JOIN Dim_Product p ON f.product_id = p.product_id
GROUP BY 
  t.month, p.category
ORDER BY 
  t.month, total_sales DESC;
