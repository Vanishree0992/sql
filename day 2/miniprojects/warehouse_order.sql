CREATE DATABASE warehouseDB;
USE warehouseDB;


CREATE TABLE employees (
    employee_id INT PRIMARY KEY,
    name VARCHAR(100),
    role VARCHAR(50)
);

CREATE TABLE products (
    product_id INT PRIMARY KEY,
    product_name VARCHAR(100),
    stock INT
);


CREATE TABLE orders (
    order_id INT PRIMARY KEY,
    employee_id INT,  -- employee who fulfilled the order
    order_date DATE,
    FOREIGN KEY (employee_id) REFERENCES employees(employee_id)
);


CREATE TABLE order_items (
    order_item_id INT PRIMARY KEY,
    order_id INT,
    product_id INT,
    quantity INT,
    FOREIGN KEY (order_id) REFERENCES orders(order_id),
    FOREIGN KEY (product_id) REFERENCES products(product_id)
);


INSERT INTO employees 
VALUES
(1, 'Alice', 'Picker'),
(2, 'Bob', 'Packer'),
(3, 'Charlie', 'Picker');


INSERT INTO products
 VALUES
(1, 'Widget A', 10),
(2, 'Widget B', 0),
(3, 'Widget C', 3),
(4, 'Widget D', 0);


INSERT INTO orders 
VALUES
(1, 1, '2025-06-01'),
(2, 2, '2025-06-02'),
(3, 1, '2025-06-03'),
(4, 3, '2025-06-04');


INSERT INTO order_items 
VALUES
(1, 1, 1, 2),
(2, 1, 2, 1),
(3, 2, 1, 3),
(4, 3, 3, 1),
(5, 4, 4, 2);

-- Count orders handled per employee.
SELECT 
    e.employee_id,
    e.name,
    COUNT(o.order_id) AS total_orders
FROM employees e
LEFT JOIN orders o ON e.employee_id = o.employee_id
GROUP BY e.employee_id, e.name;

-- Identify products frequently out of stock.
SELECT 
    product_id,
    product_name
FROM products
WHERE stock = 0;

-- Show employees with top fulfillment rates.
WITH employee_fulfillment AS (
    SELECT 
        e.employee_id,
        e.name,
        COUNT(DISTINCT o.order_id) AS total_orders,
        SUM(oi.quantity) AS total_items
    FROM employees e
    JOIN orders o ON e.employee_id = o.employee_id
    JOIN order_items oi ON o.order_id = oi.order_id
    GROUP BY e.employee_id, e.name
)
SELECT 
    employee_id,
    name,
    total_orders,
    total_items,
    ROUND(CAST(total_items AS FLOAT) / total_orders, 2) AS fulfillment_rate
FROM employee_fulfillment
ORDER BY fulfillment_rate DESC;

