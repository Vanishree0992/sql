CREATE DATABASE IF NOT EXISTS FinancialYearDB;
USE FinancialYearDB;

-- 2) Table
CREATE TABLE Orders (
  order_id INT PRIMARY KEY,
  order_date DATE,
  total_amount DECIMAL(12,2)
);

-- 3) Data
INSERT INTO Orders VALUES
 (1, '2024-03-15', 5000.00), -- FY23
 (2, '2024-04-05', 7000.00), -- FY24
 (3, '2024-06-20', 10000.00),-- FY24
 (4, '2025-02-10', 15000.00),-- FY24
 (5, '2025-04-02', 12000.00);-- FY25

--  ETL: Calculate FY
SELECT 
  order_id,
  order_date,
  total_amount,
  EXTRACT(MONTH FROM order_date) AS order_month,
  EXTRACT(YEAR FROM order_date) AS calendar_year,
  CASE 
    WHEN EXTRACT(MONTH FROM order_date) >= 4 THEN EXTRACT(YEAR FROM order_date)
    ELSE EXTRACT(YEAR FROM order_date) - 1
  END AS fiscal_year
FROM 
  Orders;

-- Group by FY & Month
SELECT 
  CASE 
    WHEN EXTRACT(MONTH FROM order_date) >= 4 THEN EXTRACT(YEAR FROM order_date)
    ELSE EXTRACT(YEAR FROM order_date) - 1
  END AS fiscal_year,
  EXTRACT(MONTH FROM order_date) AS order_month,
  SUM(total_amount) AS total_revenue
FROM 
  Orders
GROUP BY 
  fiscal_year, order_month
ORDER BY 
  fiscal_year, order_month;

-- Option: Store it for BI Tools
CREATE OR REPLACE VIEW fy_revenue_dashboard AS
SELECT 
  CASE 
    WHEN EXTRACT(MONTH FROM order_date) >= 4 THEN EXTRACT(YEAR FROM order_date)
    ELSE EXTRACT(YEAR FROM order_date) - 1
  END AS fiscal_year,
  EXTRACT(MONTH FROM order_date) AS order_month,
  SUM(total_amount) AS total_revenue
FROM 
  Orders
GROUP BY 
  fiscal_year, order_month
ORDER BY 
  fiscal_year, order_month;


--  View
CREATE OR REPLACE VIEW fy_revenue_dashboard AS
SELECT 
  CASE 
    WHEN EXTRACT(MONTH FROM order_date) >= 4 THEN EXTRACT(YEAR FROM order_date)
    ELSE EXTRACT(YEAR FROM order_date) - 1
  END AS fiscal_year,
  EXTRACT(MONTH FROM order_date) AS order_month,
  SUM(total_amount) AS total_revenue
FROM 
  Orders
GROUP BY 
  fiscal_year, order_month
ORDER BY 
  fiscal_year, order_month;

--  Query
SELECT * FROM fy_revenue_dashboard;
