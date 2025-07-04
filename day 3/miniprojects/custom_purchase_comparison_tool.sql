CREATE DATABASE Retail_Comparison;
USE Retail_Comparison;

CREATE TABLE online_purchases (
    customer_id INT PRIMARY KEY,
    customer_name VARCHAR(100),
    purchase_frequency INT,
    total_amount DECIMAL(10, 2)
);

CREATE TABLE offline_purchases (
    customer_id INT PRIMARY KEY,
    customer_name VARCHAR(100),
    purchase_frequency INT,
    total_amount DECIMAL(10, 2)
);

INSERT INTO online_purchases 
VALUES
(1, 'Alice', 5, 12000),
(2, 'Bob', 2, 4000),
(3, 'Charlie', 7, 21000),
(4, 'David', 1, 1500);

INSERT INTO offline_purchases 
VALUES
(3, 'Charlie', 3, 9000),
(4, 'David', 5, 12500),
(5, 'Eva', 4, 11000),
(6, 'Frank', 1, 2000);

--	Use UNION and UNION ALL to merge customer data from two sources.
SELECT customer_id, customer_name FROM online_purchases
UNION
SELECT customer_id, customer_name FROM offline_purchases;

SELECT customer_id, customer_name FROM online_purchases
UNION ALL
SELECT customer_id, customer_name FROM offline_purchases;

--	Use INTERSECT to find customers active on both platforms.
SELECT customer_id, customer_name FROM online_purchases
INTERSECT
SELECT customer_id, customer_name FROM offline_purchases;

--	Use subqueries to find customers who bought more than the average
SELECT *
FROM (
    SELECT customer_id, customer_name, total_amount FROM online_purchases
    UNION ALL
    SELECT customer_id, customer_name, total_amount FROM offline_purchases
) AS all_customers
WHERE total_amount > (
    SELECT AVG(total_amount)
    FROM (
        SELECT total_amount FROM online_purchases
        UNION ALL
        SELECT total_amount FROM offline_purchases
    ) AS avg_table
);

--	Classify customers based on purchase frequency.
WITH combined_freq AS (
    SELECT customer_id, customer_name, SUM(purchase_frequency) AS total_freq
    FROM (
        SELECT customer_id, customer_name, purchase_frequency FROM online_purchases
        UNION ALL
        SELECT customer_id, customer_name, purchase_frequency FROM offline_purchases
    ) AS all_freq
    GROUP BY customer_id, customer_name
)

SELECT 
    customer_id,
    customer_name,
    total_freq,
    CASE
        WHEN total_freq > 5 THEN 'High'
        WHEN total_freq BETWEEN 3 AND 5 THEN 'Medium'
        ELSE 'Low'
    END AS frequency_category
FROM combined_freq;
