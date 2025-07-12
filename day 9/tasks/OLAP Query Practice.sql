CREATE DATABASE olapDB;
USE olapDB; 

CREATE TABLE Orders (
  order_id INT PRIMARY KEY,
  customer_id INT,
  order_date DATE,
  total_amount DECIMAL(12,2)
);

-- Example data:
INSERT INTO Orders VALUES
  (1, 1, '2025-01-10', 1000.00),
  (2, 2, '2025-01-20', 2000.00),
  (3, 3, '2025-02-15', 1500.00),
  (4, 1, '2025-02-25', 2500.00),
  (5, 2, '2025-03-05', 3000.00),
  (6, 3, '2025-04-10', 4000.00);

CREATE TABLE Products (
  product_id INT PRIMARY KEY,
  product_name VARCHAR(50)
);

-- 40 Group by month using EXTRACT(MONTH FROM order_date)
SELECT 
  EXTRACT(YEAR FROM order_date) AS order_year,
  EXTRACT(MONTH FROM order_date) AS order_month,
  SUM(total_amount) AS total_sales
FROM 
  Orders
GROUP BY 
  order_year, order_month
ORDER BY 
  order_year, order_month;

-- 41 Calculate quarterly revenue
SELECT 
  EXTRACT(YEAR FROM order_date) AS order_year,
  QUARTER(order_date) AS order_quarter,
  SUM(total_amount) AS quarterly_revenue
FROM 
  Orders
GROUP BY 
  order_year, order_quarter
ORDER BY 
  order_year, order_quarter;

-- 42  Average order size by product
CREATE TABLE Order_Details (
  order_detail_id INT PRIMARY KEY,
  order_id INT,
  product_id INT,
  quantity INT,
  unit_price DECIMAL(12,2),
  line_total DECIMAL(12,2),
  FOREIGN KEY (order_id) REFERENCES Orders(order_id),
  FOREIGN KEY (product_id) REFERENCES Products(product_id)
);

INSERT INTO Products VALUES
  (1, 'Shirt'),
  (2, 'TV'),
  (3, 'Shoes');
  
SELECT 
  p.product_name,
  AVG(od.line_total) AS avg_order_size
FROM 
  Order_Details od
  JOIN Products p ON od.product_id = p.product_id
GROUP BY 
  p.product_name;

  -- 43 Time series report using EXTRACT(YEAR) & EXTRACT(MONTH)
  SELECT 
  EXTRACT(YEAR FROM order_date) AS order_year,
  EXTRACT(MONTH FROM order_date) AS order_month,
  COUNT(order_id) AS order_count,
  SUM(total_amount) AS total_sales
FROM 
  Orders
GROUP BY 
  order_year, order_month
ORDER BY 
  order_year, order_month;

-- 44 Compare this month vs. last month revenue (using window function LAG)
SELECT 
  order_year,
  order_month,
  monthly_revenue,
  monthly_revenue - LAG(monthly_revenue) OVER (ORDER BY order_year, order_month) AS revenue_change
FROM (
  SELECT 
    EXTRACT(YEAR FROM order_date) AS order_year,
    EXTRACT(MONTH FROM order_date) AS order_month,
    SUM(total_amount) AS monthly_revenue
  FROM 
    Orders
  GROUP BY 
    order_year, order_month
) AS monthly_summary;
