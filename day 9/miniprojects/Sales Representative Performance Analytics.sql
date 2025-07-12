CREATE DATABASE SalesRepDB;
USE SalesRepDB;

--  Tables
CREATE TABLE Sales_Reps (
  employee_id INT PRIMARY KEY,
  employee_name VARCHAR(100)
);

CREATE TABLE Orders (
  order_id INT PRIMARY KEY,
  employee_id INT,
  order_date DATE,
  total_amount DECIMAL(12,2),
  FOREIGN KEY (employee_id) REFERENCES Sales_Reps(employee_id)
);

CREATE TABLE rep_performance (
  employee_id INT,
  employee_name VARCHAR(100),
  total_sales DECIMAL(12,2),
  sales_rank INT,
  report_date DATETIME DEFAULT CURRENT_TIMESTAMP
);

--  Sample Data
INSERT INTO Sales_Reps VALUES
 (1, 'Alice'),
 (2, 'Bob'),
 (3, 'Charlie');

INSERT INTO Orders VALUES
 (1, 1, '2025-07-01', 10000.00),
 (2, 2, '2025-07-02', 8000.00),
 (3, 1, '2025-07-03', 5000.00),
 (4, 3, '2025-07-04', 12000.00),
 (5, 2, '2025-07-05', 7000.00);

--  ETL Load with Ranking
INSERT INTO rep_performance (employee_id, employee_name, total_sales, sales_rank)
SELECT
  employee_id,
  employee_name,
  total_sales,
  sales_rank
FROM
(
  SELECT
    sr.employee_id,
    sr.employee_name,
    SUM(o.total_amount) AS total_sales,
    ROW_NUMBER() OVER (ORDER BY SUM(o.total_amount) DESC) AS sales_rank
  FROM
    Sales_Reps sr
    JOIN Orders o ON sr.employee_id = o.employee_id
  GROUP BY
    sr.employee_id, sr.employee_name
) AS ranked;

--  Check
SELECT * FROM rep_performance;
