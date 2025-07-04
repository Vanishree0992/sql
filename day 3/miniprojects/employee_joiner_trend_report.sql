CREATE DATABASE HR_Analytics;
USE HR_Analytics;

CREATE TABLE employees (
    employee_id INT PRIMARY KEY,
    full_name VARCHAR(100),
    join_date DATE,
    department_id INT
);

INSERT INTO employees VALUES
(1, 'Alice', '2024-01-15', 1),
(2, 'Bob', '2023-07-10', 2),
(3, 'Charlie', '2023-12-01', 1),
(4, 'David', '2022-11-25', 3),
(5, 'Eve', '2024-03-05', 2),
(6, 'Frank', '2023-05-20', 1),
(7, 'Grace', '2024-06-30', 3);

--	Use DATE_SUB to get employees who joined in the last 6 months.
SELECT *
FROM employees
WHERE join_date >= DATE_SUB(CURDATE(), INTERVAL 6 MONTH);

--	Use subqueries to find employees who joined before and after company average join date.

SELECT AVG(join_date) FROM employees;

--	Aggregate joiners per month using GROUP BY.

SELECT
    YEAR(join_date) AS join_year,
    MONTH(join_date) AS join_month,
    COUNT(*) AS num_joined
FROM employees
GROUP BY join_year, join_month
ORDER BY join_year, join_month;

--	Use CASE WHEN for year-wise hiring classification.

SELECT
    YEAR(join_date) AS join_year,
    MONTH(join_date) AS join_month,
    COUNT(*) AS num_joined,
    CASE
        WHEN COUNT(*) > 2 THEN 'High'
        WHEN COUNT(*) BETWEEN 1 AND 2 THEN 'Medium'
        ELSE 'Low'
    END AS hiring_level
FROM employees
GROUP BY join_year, join_month
ORDER BY join_year, join_month;
