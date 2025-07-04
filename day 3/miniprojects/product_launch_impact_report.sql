CREATE DATABASE Marketing_Analytics;
USE Marketing_Analytics;

CREATE TABLE products (
    product_id INT PRIMARY KEY,
    product_name VARCHAR(100),
    launch_date DATE
);

CREATE TABLE sales (
    sale_id INT PRIMARY KEY,
    product_id INT,
    sale_amount DECIMAL(10,2),
    FOREIGN KEY (product_id) REFERENCES products(product_id)
);

INSERT INTO products 
VALUES
(1, 'Smartphone X', '2025-06-01'),
(2, 'Laptop Pro', '2025-04-20'),
(3, 'Tablet Mini', '2024-12-10'),
(4, 'Smartwatch Z', '2023-10-05'),
(5, 'Camera A1', '2025-05-10');

INSERT INTO sales
 VALUES
(101, 1, 150000),
(102, 2, 80000),
(103, 3, 120000),
(104, 4, 40000),
(105, 5, 110000),
(106, 1, 90000),
(107, 2, 70000),
(108, 5, 50000);

--	Use DATE functions to get products launched in the last 3 months.
SELECT *
FROM products
WHERE launch_date >= DATE_SUB(CURDATE(), INTERVAL 3 MONTH);

--	Compare sales of new vs existing products using UNION.

SELECT 
    p.product_id, 
    p.product_name, 
    'New' AS product_type,
    SUM(s.sale_amount) AS total_sales
FROM products p
JOIN sales s ON p.product_id = s.product_id
WHERE p.launch_date >= DATE_SUB(CURDATE(), INTERVAL 3 MONTH)
GROUP BY p.product_id, p.product_name
UNION
SELECT 
    p.product_id, 
    p.product_name, 
    'Existing' AS product_type,
    SUM(s.sale_amount) AS total_sales
FROM products p
JOIN sales s ON p.product_id = s.product_id
WHERE p.launch_date < DATE_SUB(CURDATE(), INTERVAL 3 MONTH)
GROUP BY p.product_id, p.product_name;

--	Use subqueries to find average sales.
SELECT 
    product_id,
    ROUND(AVG(sale_amount)) AS avg_sales
FROM sales
GROUP BY product_id;

--	Classify launch as Successful/Neutral/Fail using CASE.
SELECT 
    p.product_id,
    p.product_name,
    SUM(s.sale_amount) AS total_sales,
    CASE
        WHEN SUM(s.sale_amount) > 100000 THEN 'Successful'
        WHEN SUM(s.sale_amount) BETWEEN 50000 AND 100000 THEN 'Neutral'
        ELSE 'Fail'
    END AS launch_result
FROM products p
JOIN sales s ON p.product_id = s.product_id
GROUP BY p.product_id, p.product_name;
