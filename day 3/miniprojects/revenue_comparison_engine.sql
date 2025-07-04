CREATE DATABASE Revenue_Analytics;
USE Revenue_Analytics;

CREATE TABLE revenue (
    revenue_id INT PRIMARY KEY,
    revenue_date DATE,
    amount DECIMAL(12, 2)
);

INSERT INTO revenue VALUES
(1, '2024-01-15', 80000),
(2, '2024-02-15', 75000),
(3, '2024-03-15', 90000),
(4, '2024-04-15', 60000),
(5, '2024-05-15', 95000),
(6, '2024-06-15', 70000),
(7, '2025-01-15', 85000),
(8, '2025-02-15', 77000),
(9, '2025-03-15', 92000),
(10, '2025-04-15', 61000),
(11, '2025-05-15', 97000),
(12, '2025-06-15', 69000);


--	Use DATE functions to group revenue by year/month.
SELECT 
    YEAR(revenue_date) AS revenue_year,
    MONTH(revenue_date) AS revenue_month,
    SUM(amount) AS monthly_revenue
FROM revenue
GROUP BY YEAR(revenue_date), MONTH(revenue_date)
ORDER BY revenue_year, revenue_month;

--	Use subquery to calculate year-wise average revenue.
SELECT 
    revenue_year,
    AVG(monthly_revenue) AS avg_revenue_per_month
FROM (
    SELECT 
        YEAR(revenue_date) AS revenue_year,
        MONTH(revenue_date) AS revenue_month,
        SUM(amount) AS monthly_revenue
    FROM revenue
    GROUP BY YEAR(revenue_date), MONTH(revenue_date)
) AS monthly_data
GROUP BY revenue_year;

--	Highlight months where revenue was higher than average.

WITH monthly_data AS (
    SELECT 
        YEAR(revenue_date) AS revenue_year,
        MONTH(revenue_date) AS revenue_month,
        SUM(amount) AS monthly_revenue
    FROM revenue
    GROUP BY YEAR(revenue_date), MONTH(revenue_date)
),

yearly_avg AS (
    SELECT 
        revenue_year,
        AVG(monthly_revenue) AS avg_revenue
    FROM monthly_data
    GROUP BY revenue_year
)

SELECT 
    m.revenue_year,
    m.revenue_month,
    m.monthly_revenue
FROM monthly_data m
JOIN yearly_avg y ON m.revenue_year = y.revenue_year
WHERE m.monthly_revenue > y.avg_revenue
ORDER BY m.revenue_year, m.revenue_month;

--	Use CASE to classify month as High/Low revenue.
SELECT 
    revenue_year,
    revenue_month,
    monthly_revenue,
    CASE
        WHEN monthly_revenue > (
            SELECT AVG(mr)
            FROM (
                SELECT SUM(amount) AS mr
                FROM revenue
                WHERE YEAR(revenue_date) = main.revenue_year
                GROUP BY MONTH(revenue_date)
            ) AS sub_months
        ) THEN 'High'
        ELSE 'Low'
    END AS revenue_class
FROM (
    SELECT 
        YEAR(revenue_date) AS revenue_year,
        MONTH(revenue_date) AS revenue_month,
        SUM(amount) AS monthly_revenue
    FROM revenue
    GROUP BY YEAR(revenue_date), MONTH(revenue_date)
) AS main
ORDER BY revenue_year, revenue_month;

