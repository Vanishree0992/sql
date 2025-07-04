CREATE DATABASE Customer_Support;
USE Customer_Support;

CREATE TABLE products (
    product_id INT PRIMARY KEY,
    product_name VARCHAR(100)
);

CREATE TABLE orders (
    order_id INT PRIMARY KEY,
    product_id INT,
    order_date DATE,
    FOREIGN KEY (product_id) REFERENCES products(product_id)
);

CREATE TABLE returns (
    return_id INT PRIMARY KEY,
    order_id INT,
    return_date DATE,
    return_reason_code INT,  
    FOREIGN KEY (order_id) REFERENCES orders(order_id)
);

INSERT INTO products 
VALUES
(1, 'Bluetooth Speaker'),
(2, 'Laptop Stand'),
(3, 'Wireless Mouse'),
(4, 'Smartphone Case');

INSERT INTO orders 
VALUES
(101, 1, '2025-05-01'),
(102, 1, '2025-05-03'),
(103, 2, '2025-05-04'),
(104, 2, '2025-05-06'),
(105, 3, '2025-05-07'),
(106, 3, '2025-05-10'),
(107, 4, '2025-05-12'),
(108, 1, '2025-05-13');

INSERT INTO returns 
VALUES
(201, 101, '2025-05-08', 1),
(202, 103, '2025-05-10', 3),
(203, 108, '2025-05-15', 1),
(204, 106, '2025-05-16', 2);

--	Use subqueries to find most returned products.
SELECT 
    p.product_name,
    COUNT(r.return_id) AS return_count
FROM returns r
JOIN orders o ON r.order_id = o.order_id
JOIN products p ON o.product_id = p.product_id
GROUP BY p.product_name
HAVING return_count = (
    SELECT MAX(return_cnt)
    FROM (
        SELECT COUNT(*) AS return_cnt
        FROM returns r
        JOIN orders o ON r.order_id = o.order_id
        GROUP BY o.product_id
    ) AS sub
);

--	Use CASE to classify return reason (Damaged, Late, Not as Described).
SELECT 
    r.return_id,
    o.order_id,
    p.product_name,
    CASE 
        WHEN r.return_reason_code = 1 THEN 'Damaged'
        WHEN r.return_reason_code = 2 THEN 'Late'
        WHEN r.return_reason_code = 3 THEN 'Not as Described'
        ELSE 'Other'
    END AS reason
FROM returns r
JOIN orders o ON r.order_id = o.order_id
JOIN products p ON o.product_id = p.product_id;

--	Use JOIN to link orders and returns.
SELECT 
    o.order_id,
    p.product_name,
    o.order_date,
    r.return_date
FROM orders o
JOIN products p ON o.product_id = p.product_id
LEFT JOIN returns r ON o.order_id = r.order_id
ORDER BY o.order_date;

--	Filter products with return rate above average.
WITH product_stats AS (
    SELECT 
        p.product_id,
        p.product_name,
        COUNT(DISTINCT o.order_id) AS total_orders,
        COUNT(DISTINCT r.return_id) AS total_returns,
        COUNT(DISTINCT r.return_id) * 1.0 / COUNT(DISTINCT o.order_id) AS return_rate
    FROM products p
    JOIN orders o ON p.product_id = o.product_id
    LEFT JOIN returns r ON o.order_id = r.order_id
    GROUP BY p.product_id, p.product_name
),

avg_rate AS (
    SELECT AVG(return_rate) AS avg_return_rate FROM product_stats
)

SELECT 
    ps.product_name,
    ps.total_orders,
    ps.total_returns,
    ROUND(ps.return_rate, 2) AS return_rate,
    ROUND(ar.avg_return_rate, 2) AS average_rate
FROM product_stats ps
JOIN avg_rate ar ON 1=1
WHERE ps.return_rate > ar.avg_return_rate;
