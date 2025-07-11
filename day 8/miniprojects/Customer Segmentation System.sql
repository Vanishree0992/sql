CREATE DATABASE CustomersegmentationDB;
USE CustomersegmentationDB;

CREATE TABLE Customers (
  customer_id INT PRIMARY KEY,
  customer_name VARCHAR(100)
);

CREATE TABLE Orders (
  order_id INT PRIMARY KEY,
  customer_id INT,
  order_date DATE,
  amount DECIMAL(12,2),
  FOREIGN KEY (customer_id) REFERENCES Customers(customer_id)
);

INSERT INTO Customers VALUES (1, 'Alice');
INSERT INTO Customers VALUES (2, 'Bob');
INSERT INTO Customers VALUES (3, 'Charlie');
INSERT INTO Customers VALUES (4, 'Diana');
INSERT INTO Customers VALUES (5, 'Ethan');

INSERT INTO Orders VALUES (1, 1, '2024-07-01', 5000.00);
INSERT INTO Orders VALUES (2, 1, '2024-07-05', 3000.00);
INSERT INTO Orders VALUES (3, 2, '2024-07-03', 2000.00);
INSERT INTO Orders VALUES (4, 3, '2024-07-02', 7000.00);
INSERT INTO Orders VALUES (5, 4, '2024-07-04', 4000.00);
INSERT INTO Orders VALUES (6, 5, '2024-07-05', 1000.00);


-- Use CTE to calculate total spend per customer
WITH CustomerSpend AS (
  SELECT
    c.customer_id,
    c.customer_name,
    SUM(o.amount) AS total_spend
  FROM Customers c
  JOIN Orders o ON c.customer_id = o.customer_id
  GROUP BY c.customer_id, c.customer_name
)
SELECT * FROM CustomerSpend;

-- Use NTILE(4) to divide into quartiles
WITH CustomerSpend AS (
  SELECT
    c.customer_id,
    c.customer_name,
    SUM(o.amount) AS total_spend
  FROM Customers c
  JOIN Orders o ON c.customer_id = o.customer_id
  GROUP BY c.customer_id, c.customer_name
)
SELECT
  customer_id,
  customer_name,
  total_spend,
  NTILE(4) OVER (ORDER BY total_spend DESC) AS spend_quartile
FROM CustomerSpend;

-- Assign segments: Platinum, Gold, Silver, Bronze
WITH CustomerSpend AS (
  SELECT
    c.customer_id,
    c.customer_name,
    SUM(o.amount) AS total_spend
  FROM Customers c
  JOIN Orders o ON c.customer_id = o.customer_id
  GROUP BY c.customer_id, c.customer_name
),
CustomerSegmentation AS (
  SELECT
    customer_id,
    customer_name,
    total_spend,
    NTILE(4) OVER (ORDER BY total_spend DESC) AS spend_quartile
  FROM CustomerSpend
)
SELECT
  customer_id,
  customer_name,
  total_spend,
  spend_quartile,
  CASE
    WHEN spend_quartile = 1 THEN 'Platinum'
    WHEN spend_quartile = 2 THEN 'Gold'
    WHEN spend_quartile = 3 THEN 'Silver'
    ELSE 'Bronze'
  END AS segment
FROM CustomerSegmentation
ORDER BY total_spend DESC;


-- Create final view for reporting
CREATE VIEW CustomerSegmentationView AS
WITH CustomerSpend AS (
  SELECT
    c.customer_id,
    c.customer_name,
    SUM(o.amount) AS total_spend
  FROM Customers c
  JOIN Orders o ON c.customer_id = o.customer_id
  GROUP BY c.customer_id, c.customer_name
),
CustomerSegmentation AS (
  SELECT
    customer_id,
    customer_name,
    total_spend,
    NTILE(4) OVER (ORDER BY total_spend DESC) AS spend_quartile
  FROM CustomerSpend
)
SELECT
  customer_id,
  customer_name,
  total_spend,
  spend_quartile,
  CASE
    WHEN spend_quartile = 1 THEN 'Platinum'
    WHEN spend_quartile = 2 THEN 'Gold'
    WHEN spend_quartile = 3 THEN 'Silver'
    ELSE 'Bronze'
  END AS segment
FROM CustomerSegmentation;

