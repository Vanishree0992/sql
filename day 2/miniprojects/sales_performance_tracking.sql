CREATE DATABASE sales_performanace;
USE sales_performanace;

CREATE TABLE regions (
    region_id INT PRIMARY KEY,
    region_name VARCHAR(100)
);


CREATE TABLE salespeople (
    salesperson_id INT PRIMARY KEY,
    name VARCHAR(100),
    region_id INT,
    FOREIGN KEY (region_id) REFERENCES regions(region_id)
);


CREATE TABLE sales (
    sale_id INT PRIMARY KEY,
    salesperson_id INT,
    sale_date DATE,
    amount DECIMAL(10,2),
    FOREIGN KEY (salesperson_id) REFERENCES salespeople(salesperson_id)
);


INSERT INTO regions 
VALUES
(1, 'North'),
(2, 'South'),
(3, 'East'),
(4, 'West');


INSERT INTO salespeople 
VALUES
(1, 'Alice', 1),
(2, 'Bob', 2),
(3, 'Charlie', 3),
(4, 'Diana', 1),
(5, 'Eve', 4);


INSERT INTO sales 
VALUES
(1, 1, '2025-06-01', 1000.00),
(2, 1, '2025-07-01', 1500.00),
(3, 2, '2025-06-05', 2000.00),
(4, 3, '2025-07-03', 2500.00),
(5, 3, '2025-06-15', 500.00),
(6, 4, '2025-07-01', 3000.00);

-- Calculate total sales per region and per salesperson.
SELECT 
    r.region_id,
    r.region_name,
    COALESCE(SUM(s.amount), 0) AS total_sales
FROM regions r
LEFT JOIN salespeople sp ON r.region_id = sp.region_id
LEFT JOIN sales s ON sp.salesperson_id = s.salesperson_id
GROUP BY r.region_id, r.region_name;

SELECT 
    sp.salesperson_id,
    sp.name,
    COALESCE(SUM(s.amount), 0) AS total_sales
FROM salespeople sp
LEFT JOIN sales s ON sp.salesperson_id = s.salesperson_id
GROUP BY sp.salesperson_id, sp.name;


-- List salespeople with no sales in a region (LEFT JOIN).
SELECT 
    sp.salesperson_id,
    sp.name,
    r.region_name
FROM salespeople sp
JOIN regions r ON sp.region_id = r.region_id
LEFT JOIN sales s ON sp.salesperson_id = s.salesperson_id
WHERE s.sale_id IS NULL;

-- Identify regions with the highest sales growth.
WITH monthly_sales AS (
    SELECT 
        r.region_id,
        r.region_name,
        DATE_FORMAT(s.sale_date, '%Y-%m') AS sale_month,
        SUM(s.amount) AS total_monthly_sales
    FROM sales s
    JOIN salespeople sp ON s.salesperson_id = sp.salesperson_id
    JOIN regions r ON sp.region_id = r.region_id
    WHERE DATE_FORMAT(s.sale_date, '%Y-%m') IN ('2025-06', '2025-07')
    GROUP BY r.region_id, r.region_name, sale_month
),
sales_pivot AS (
    SELECT
        region_id,
        region_name,
        MAX(CASE WHEN sale_month = '2025-06' THEN total_monthly_sales ELSE 0 END) AS june_sales,
        MAX(CASE WHEN sale_month = '2025-07' THEN total_monthly_sales ELSE 0 END) AS july_sales
    FROM monthly_sales
    GROUP BY region_id, region_name
)
SELECT 
    region_id,
    region_name,
    june_sales,
    july_sales,
    (july_sales - june_sales) AS sales_growth
FROM sales_pivot
ORDER BY sales_growth DESC;
