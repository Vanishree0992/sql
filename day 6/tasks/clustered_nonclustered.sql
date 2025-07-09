-- 31.	Create a table Products with product_id as PRIMARY KEY (clustered).
USE sql_24DB;
-- 32.	Add a non-clustered index on product_name.
CREATE INDEX idx_product_name ON Products(product_name);
-- 33.	Insert 10 sample products and query them using WHERE product_name LIKE '%lap%'.
INSERT INTO Products (product_name, price) VALUES
('Laptop X', 800.00),
('Laptop Y', 950.00),
('Desktop Z', 700.00),
('Monitor 24"', 150.00),
('Laptop Bag', 50.00),
('Keyboard', 20.00),
('Mouse', 15.00),
('Headphones', 60.00),
('Laptop Stand', 30.00),
('USB Hub', 25.00);
SELECT * FROM Products WHERE product_name LIKE '%lap%';
-- 34.	Explain the difference in execution between clustered and non-clustered index using EXPLAIN.
EXPLAIN SELECT * FROM Products WHERE product_id = 3; -- Uses clustered PK
EXPLAIN SELECT * FROM Products WHERE product_name LIKE '%lap%'; -- Uses non-clustered
-- 35.	Drop the non-clustered index and test impact on query performance.
DROP INDEX idx_product_name ON Products;
EXPLAIN SELECT * FROM Products WHERE product_name LIKE '%lap%';