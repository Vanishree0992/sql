CREATE DATABASE SalesFunnelDB;
USE SalesFunnelDB;

CREATE TABLE Leads (
  lead_id INT PRIMARY KEY,
  lead_name VARCHAR(50),
  lead_date DATE
);

CREATE TABLE Orders (
  order_id INT PRIMARY KEY,
  lead_id INT,
  order_date DATE,
  total_amount DECIMAL(12,2),
  FOREIGN KEY (lead_id) REFERENCES Leads(lead_id)
);

-- 3) Data
INSERT INTO Leads VALUES
 (1, 'Alice', '2025-01-10'),
 (2, 'Bob', '2025-01-15'),
 (3, 'Charlie', '2025-01-20'),
 (4, 'Diana', '2025-02-01'),
 (5, 'Edward', '2025-02-05');

INSERT INTO Orders VALUES
 (1, 1, '2025-01-12', 5000.00),
 (2, 1, '2025-02-15', 7000.00),
 (3, 2, '2025-01-20', 3000.00),
 (4, 4, '2025-02-10', 4000.00);

-- 4) Funnel Analysis
WITH 
Total_Leads AS (
  SELECT COUNT(*) AS total_leads FROM Leads
),
Converted_Customers AS (
  SELECT COUNT(DISTINCT lead_id) AS converted FROM Orders
),
Repeat_Customers AS (
  SELECT COUNT(*) AS repeat_customers
  FROM (
    SELECT lead_id, COUNT(*) AS order_count
    FROM Orders
    GROUP BY lead_id
    HAVING COUNT(*) > 1
  ) AS sub
)

SELECT 
  tl.total_leads,
  cc.converted,
  rc.repeat_customers,
  ROUND(cc.converted / tl.total_leads * 100, 2) AS conversion_rate_pct,
  ROUND(rc.repeat_customers / cc.converted * 100, 2) AS repeat_rate_pct
FROM 
  Total_Leads tl,
  Converted_Customers cc,
  Repeat_Customers rc;