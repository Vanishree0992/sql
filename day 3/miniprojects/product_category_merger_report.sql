CREATE DATABASE ECommerce_Analysis;
USE ECommerce_Analysis;

CREATE TABLE electronics (
    product_id INT PRIMARY KEY,
    product_name VARCHAR(100),
    price DECIMAL(10, 2)
);

CREATE TABLE clothing (
    product_id INT PRIMARY KEY,
    product_name VARCHAR(100),
    price DECIMAL(10, 2)
);

CREATE TABLE furniture (
    product_id INT PRIMARY KEY,
    product_name VARCHAR(100),
    price DECIMAL(10, 2)
);

INSERT INTO electronics
 VALUES
(1, 'Smartphone A1', 35000),
(2, 'Laptop X1', 75000),
(3, 'Bluetooth Speaker', 5000);

INSERT INTO clothing 
VALUES
(4, 'T-Shirt Classic', 800),
(5, 'Jeans Regular', 1500),
(6, 'Smartphone A1', 35000); 

INSERT INTO furniture
 VALUES
(7, 'Wooden Chair', 4500),
(8, 'Dining Table', 15000),
(9, 'Sofa Set', 35000);

--	Use UNION to combine products from electronics, clothing, and furniture.
SELECT product_name, price FROM electronics
UNION
SELECT product_name, price FROM clothing
UNION
SELECT product_name, price FROM furniture;

--	Use UNION ALL to check duplicate products.
SELECT product_name, price FROM electronics
UNION ALL
SELECT product_name, price FROM clothing
UNION ALL
SELECT product_name, price FROM furniture;

--	Show max price, min price using subqueries.
SELECT 
    product_name,
    price,
    (SELECT MAX(price) FROM (
        SELECT price FROM electronics
        UNION ALL
        SELECT price FROM clothing
        UNION ALL
        SELECT price FROM furniture
    ) AS all_products) AS max_price,
    (SELECT MIN(price) FROM (
        SELECT price FROM electronics
        UNION ALL
        SELECT price FROM clothing
        UNION ALL
        SELECT price FROM furniture
    ) AS all_products) AS min_price
FROM (
    SELECT product_name, price FROM electronics
    UNION
    SELECT product_name, price FROM clothing
    UNION
    SELECT product_name, price FROM furniture
) AS combined_products;

--	Classify products by price using CASE.
SELECT 
    product_name,
    price,
    CASE
        WHEN price > 30000 THEN 'High'
        WHEN price > 10000 THEN 'Medium'
        ELSE 'Low'
    END AS price_category
FROM (
    SELECT product_name, price FROM electronics
    UNION
    SELECT product_name, price FROM clothing
    UNION
    SELECT product_name, price FROM furniture
) AS combined_products;
