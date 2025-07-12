CREATE DATABASE IF NOT EXISTS ETLDB;
USE ETLDB;

-- 2) Tables
CREATE TABLE Orders_Staging (
  order_id INT PRIMARY KEY,
  customer_name VARCHAR(100),
  order_date DATE,
  total_amount DECIMAL(12,2)
);

CREATE TABLE dw_orders (
  order_id INT PRIMARY KEY,
  customer_name VARCHAR(100),
  order_date DATE,
  total_amount DECIMAL(12,2)
);

CREATE TABLE etl_logs (
  log_id INT AUTO_INCREMENT PRIMARY KEY,
  job_name VARCHAR(50),
  run_timestamp DATETIME DEFAULT CURRENT_TIMESTAMP,
  status VARCHAR(20),
  message VARCHAR(255)
);

-- 3) Insert raw data
INSERT INTO Orders_Staging VALUES
 (1, 'alice', '2025-07-12', 1234.567),
 (2, 'bob', '2025-07-12', 987.654),
 (3, 'charlie', '2025-07-12', 555.555);

-- 4) ETL Load
INSERT INTO dw_orders (order_id, customer_name, order_date, total_amount)
SELECT 
  order_id,
  UPPER(customer_name),
  order_date,
  ROUND(total_amount, 2)
FROM 
  Orders_Staging;

-- 5) Log success
INSERT INTO etl_logs (job_name, status, message)
VALUES ('Daily_ETL_Run', 'SUCCESS', 'ETL pipeline completed successfully.');

-- 6) Check
SELECT * FROM dw_orders;
SELECT * FROM etl_logs;
