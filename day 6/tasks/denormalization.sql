USE sql_24DB;
-- 41.	Create a denormalized table combining Orders, Customers, and OrderItems.

CREATE TABLE DenormalizedSales (
  order_id INT,
  customer_name VARCHAR(50),
  product_name VARCHAR(50)
);

-- Insert denormalized rows
INSERT INTO DenormalizedSales (order_id, customer_name, product_name)
VALUES
(1, 'Alice', 'Laptop'),
(1, 'Alice', 'Mouse'),
(1, 'Alice', 'Keyboard'),
(2, 'Bob', 'Monitor'),
(2, 'Bob', 'Headphones'),
(3, 'Charlie', 'Laptop');

SELECT * FROM DenormalizedSales;

-- 42.	Insert sample records with duplicated customer names and product info.
INSERT INTO DenormalizedSales VALUES (4, 'Alice', 'Laptop');
INSERT INTO DenormalizedSales VALUES (4, 'Alice', 'Laptop Bag');
INSERT INTO DenormalizedSales VALUES (4, 'Alice', 'Mouse');

-- 43.	Write a query that retrieves full order info without joins (denormalized benefit).
SELECT *
FROM DenormalizedSales
WHERE customer_name = 'Alice';

-- 44.	Compare performance of normalized vs denormalized query for data retrieval.
CREATE TABLE OrderItems (
  order_id INT,
  product_id INT,
  FOREIGN KEY (order_id) REFERENCES Orders(order_id),
  FOREIGN KEY (product_id) REFERENCES Products(product_id)
);
INSERT INTO OrderItems (order_id, product_id) VALUES
(1, 1), -- Laptop
(1, 2), -- Mouse
(1, 3), -- Keyboard
(2, 4), -- Monitor
(2, 5), -- Headphones
(3, 1);

SELECT * FROM OrderItems;

SELECT o.order_id, c.customer_name, p.product_name
FROM Orders o
JOIN Customers c ON o.customer_id = c.customer_id
JOIN OrderItems oi ON o.order_id = oi.order_id
JOIN Products p ON oi.product_id = p.product_id
WHERE c.customer_name = 'Alice'
LIMIT 0, 1000;

SELECT * 
FROM DenormalizedSales
WHERE customer_name = 'Alice';
-- 45.	Discuss and document trade-offs: update anomalies vs query performance.
-- ✅ Normalized	✅ Denormalized
-- ✔️ Avoids redundancy	✔️ Fewer JOINs → faster reads
-- ✔️ Less storage	✔️ Simpler queries for reports
-- ✔️ Consistent data	❌ Redundant data → updates harder
-- ❌ More complex queries	❌ Insert/update anomalies: need to update same data in many rows