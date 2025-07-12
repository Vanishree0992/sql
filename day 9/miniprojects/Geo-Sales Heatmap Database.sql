CREATE DATABASE IF NOT EXISTS GeoSalesDB;
USE GeoSalesDB;

--  Tables
CREATE TABLE Locations (
  location_id INT PRIMARY KEY,
  city VARCHAR(100),
  state VARCHAR(100)
);

CREATE TABLE Orders (
  order_id INT PRIMARY KEY,
  location_id INT,
  order_date DATE,
  total_amount DECIMAL(12,2),
  FOREIGN KEY (location_id) REFERENCES Locations(location_id)
);

--  Sample Data
INSERT INTO Locations VALUES
 (1, 'Bengaluru', 'Karnataka'),
 (2, 'Hyderabad', 'Telangana'),
 (3, 'Mumbai', 'Maharashtra'),
 (4, 'Chennai', 'Tamil Nadu');

INSERT INTO Orders VALUES
 (1, 1, '2025-07-01', 10000.00),
 (2, 1, '2025-07-02', 8000.00),
 (3, 2, '2025-07-02', 15000.00),
 (4, 3, '2025-07-03', 12000.00),
 (5, 4, '2025-07-04', 5000.00);

--  DW Table
CREATE TABLE dw_sales_by_region (
  region_level VARCHAR(50),
  region_name VARCHAR(100),
  total_revenue DECIMAL(12,2),
  report_date DATETIME DEFAULT CURRENT_TIMESTAMP
);

--  ETL: City-wise
INSERT INTO dw_sales_by_region (region_level, region_name, total_revenue)
SELECT 
  'City',
  l.city,
  SUM(o.total_amount)
FROM 
  Orders o
  JOIN Locations l ON o.location_id = l.location_id
GROUP BY 
  l.city;

--  ETL: State-wise
INSERT INTO dw_sales_by_region (region_level, region_name, total_revenue)
SELECT 
  'State',
  l.state,
  SUM(o.total_amount)
FROM 
  Orders o
  JOIN Locations l ON o.location_id = l.location_id
GROUP BY 
  l.state;

--  Final Check
SELECT * FROM dw_sales_by_region;
