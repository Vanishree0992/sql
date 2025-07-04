CREATE DATABASE Sales_Analytics;
USE Sales_Analytics;

CREATE TABLE electronics_customers (
    customer_id INT PRIMARY KEY,
    customer_name VARCHAR(100),
    amount_spent DECIMAL(10, 2)
);

CREATE TABLE clothing_customers (
    customer_id INT PRIMARY KEY,
    customer_name VARCHAR(100),
    amount_spent DECIMAL(10, 2)
);

CREATE TABLE groceries_customers (
    customer_id INT PRIMARY KEY,
    customer_name VARCHAR(100),
    amount_spent DECIMAL(10, 2)
);

INSERT INTO electronics_customers 
VALUES
(1, 'Alice', 25000),
(2, 'Bob', 18000),
(3, 'Charlie', 30000),
(4, 'David', 15000);

INSERT INTO clothing_customers 
VALUES
(2, 'Bob', 7000),
(3, 'Charlie', 12000),
(5, 'Eve', 6000),
(6, 'Frank', 5000);

INSERT INTO groceries_customers 
VALUES
(1, 'Alice', 8000),
(5, 'Eve', 4000),
(7, 'Grace', 3000),
(3, 'Charlie', 10000);

--	Use INTERSECT to find customers who purchased from multiple categories.

SELECT customer_id, customer_name FROM electronics_customers
INTERSECT
SELECT customer_id, customer_name FROM clothing_customers;

SELECT customer_id, customer_name FROM electronics_customers
INTERSECT
SELECT customer_id, customer_name FROM clothing_customers
INTERSECT
SELECT customer_id, customer_name FROM groceries_customers;

--	Use EXCEPT to find customers loyal to only one.
SELECT customer_id, customer_name FROM electronics_customers
EXCEPT
SELECT customer_id, customer_name FROM clothing_customers;

--	Use subqueries to find customers who spend above average.

SELECT *
FROM electronics_customers
WHERE amount_spent > (
    SELECT AVG(amount_spent) FROM electronics_customers
);

--	Merge customer lists with UNION
SELECT customer_id, customer_name FROM electronics_customers
UNION
SELECT customer_id, customer_name FROM clothing_customers
UNION
SELECT customer_id, customer_name FROM groceries_customers;
