CREATE DATABASE ChurnDB;
USE ChurnDB;

CREATE TABLE Customers (
  customer_id INT PRIMARY KEY,
  customer_name VARCHAR(100),
  registration_date DATE
);
CREATE TABLE Orders (
  order_id INT PRIMARY KEY,
  customer_id INT,
  order_date DATE,
  total_amount DECIMAL(12,2),
  FOREIGN KEY (customer_id) REFERENCES Customers(customer_id)
);

INSERT INTO Customers VALUES
 (1, 'Alice', '2024-01-10'),
 (2, 'Bob', '2024-03-15'),
 (3, 'Charlie', '2024-04-20'),
 (4, 'Diana', '2024-05-05'),
 (5, 'Edward', '2024-06-01');

INSERT INTO Orders VALUES
 (1, 1, '2024-12-01', 5000.00),
 (2, 1, '2025-02-01', 6000.00),
 (3, 2, '2025-02-15', 3000.00),
 (4, 3, '2025-02-20', 4000.00),
 (5, 4, '2025-06-05', 7000.00);
-- Edward has no orders yet

-- Find last purchase per customer
SELECT 
  c.customer_id,
  c.customer_name,
  MAX(o.order_date) AS last_purchase_date,
  DATEDIFF(CURRENT_DATE, MAX(o.order_date)) AS days_since_last_purchase
FROM 
  Customers c
  LEFT JOIN Orders o ON c.customer_id = o.customer_id
GROUP BY 
  c.customer_id, c.customer_name;

-- Filter for 90+ days inactive
SELECT 
  c.customer_id,
  c.customer_name,
  MAX(o.order_date) AS last_purchase_date,
  DATEDIFF(CURRENT_DATE, MAX(o.order_date)) AS days_since_last_purchase
FROM 
  Customers c
  LEFT JOIN Orders o ON c.customer_id = o.customer_id
GROUP BY 
  c.customer_id, c.customer_name
HAVING 
  days_since_last_purchase >= 90 OR last_purchase_date IS NULL;

CREATE TABLE churn_candidates (
  candidate_id INT AUTO_INCREMENT PRIMARY KEY,
  customer_id INT,
  customer_name VARCHAR(100),
  last_purchase_date DATE,
  days_inactive INT,
  flagged_date DATETIME DEFAULT CURRENT_TIMESTAMP
);


INSERT INTO churn_candidates (customer_id, customer_name, last_purchase_date, days_inactive)
SELECT 
  c.customer_id,
  c.customer_name,
  MAX(o.order_date) AS last_purchase_date,
  DATEDIFF(CURRENT_DATE, MAX(o.order_date)) AS days_since_last_purchase
FROM 
  Customers c
  LEFT JOIN Orders o ON c.customer_id = o.customer_id
GROUP BY 
  c.customer_id, c.customer_name
HAVING 
  days_since_last_purchase >= 90 OR last_purchase_date IS NULL;

SELECT * FROM churn_candidates;
