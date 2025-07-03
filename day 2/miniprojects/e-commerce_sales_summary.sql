CREATE DATABASE salessummary;
USE salessummary;

CREATE TABLE customers (
    customer_id INTEGER PRIMARY KEY,
    name TEXT NOT NULL
);

CREATE TABLE products (
    product_id INTEGER PRIMARY KEY,
    name TEXT NOT NULL,
    price REAL NOT NULL
);


CREATE TABLE orders (
    order_id INTEGER PRIMARY KEY,
    customer_id INTEGER,
    order_date DATE,
    FOREIGN KEY(customer_id) REFERENCES customers(customer_id)
);

CREATE TABLE order_items (
    order_item_id INTEGER PRIMARY KEY,
    order_id INTEGER,
    product_id INTEGER,
    quantity INTEGER,
    FOREIGN KEY(order_id) REFERENCES orders(order_id),
    FOREIGN KEY(product_id) REFERENCES products(product_id)
);


INSERT INTO customers (customer_id, name) VALUES
(1, 'Alice'),
(2, 'Bob'),
(3, 'Charlie');


INSERT INTO products (product_id, name, price) 
VALUES
(1, 'Laptop', 1200),
(2, 'Phone', 800),
(3, 'Headphones', 150);


INSERT INTO orders (order_id, customer_id, order_date) 
VALUES
(1, 1, '2025-07-01'),
(2, 2, '2025-07-02');


INSERT INTO order_items (order_item_id, order_id, product_id, quantity) 
VALUES
(1, 1, 1, 1),  
(2, 1, 3, 2),  
(3, 2, 2, 1);  


-- Show total sales per product and per customer.
SELECT 
    p.name AS product_name,
    SUM(oi.quantity * p.price) AS total_sales
FROM 
    products p
JOIN order_items oi ON p.product_id = oi.product_id
GROUP BY 
    p.product_id;

SELECT 
    c.name AS customer_name,
    SUM(oi.quantity * p.price) AS total_spent
FROM 
    customers c
JOIN orders o ON c.customer_id = o.customer_id
JOIN order_items oi ON o.order_id = oi.order_id
JOIN products p ON oi.product_id = p.product_id
GROUP BY 
    c.customer_id;

-- List products with sales above a certain amount.
SELECT 
    p.name AS product_name,
    SUM(oi.quantity * p.price) AS total_sales
FROM 
    products p
JOIN order_items oi ON p.product_id = oi.product_id
GROUP BY 
    p.product_id
HAVING 
    total_sales > 1000;


-- Identify customers with no orders (LEFT JOIN).
SELECT 
    c.name AS customer_name
FROM 
    customers c
LEFT JOIN orders o ON c.customer_id = o.customer_id
WHERE 
    o.order_id IS NULL;
