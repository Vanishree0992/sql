CREATE DATABASE restaurant_db;
USE restaurant_db;

CREATE TABLE menu_items (
    item_id INT PRIMARY KEY AUTO_INCREMENT,
    item_name VARCHAR(100),
    price DECIMAL(10,2)
);

CREATE TABLE customers (
    customer_id INT PRIMARY KEY AUTO_INCREMENT,
    name VARCHAR(100),
    contact_info VARCHAR(100)
);

CREATE TABLE orders (
    order_id INT PRIMARY KEY AUTO_INCREMENT,
    customer_id INT,
    order_date DATE,
    FOREIGN KEY (customer_id) REFERENCES customers(customer_id)
);

CREATE TABLE order_details (
    order_detail_id INT PRIMARY KEY AUTO_INCREMENT,
    order_id INT,
    item_id INT,
    quantity INT,
    FOREIGN KEY (order_id) REFERENCES orders(order_id),
    FOREIGN KEY (item_id) REFERENCES menu_items(item_id)
);

INSERT INTO menu_items (item_name, price) VALUES
('Burger', 8.99),
('Pizza', 12.50),
('Pasta', 10.00),
('Salad', 6.50),
('Soda', 2.00);


INSERT INTO customers (name, contact_info) VALUES
('Alice', 'alice@example.com'),
('Bob', 'bob@example.com'),
('Charlie', 'charlie@example.com');

INSERT INTO orders (customer_id, order_date) VALUES
(1, '2025-07-01'),
(2, '2025-07-02'),
(1, '2025-07-03');

INSERT INTO order_details (order_id, item_id, quantity) VALUES
(1, 1, 2), 
(1, 5, 2),  
(2, 2, 1),  
(2, 5, 1),  
(3, 3, 1);  

-- Compute total revenue per menu item.
SELECT 
    mi.item_name,
    SUM(od.quantity * mi.price) AS total_revenue
FROM 
    order_details od
JOIN 
    menu_items mi ON od.item_id = mi.item_id
GROUP BY 
    mi.item_name
ORDER BY 
    total_revenue DESC;

-- List customers with the highest order totals.
SELECT 
    c.name AS customer_name,
    SUM(od.quantity * mi.price) AS total_spent
FROM 
    customers c
JOIN 
    orders o ON c.customer_id = o.customer_id
JOIN 
    order_details od ON o.order_id = od.order_id
JOIN 
    menu_items mi ON od.item_id = mi.item_id
GROUP BY 
    c.customer_id
ORDER BY 
    total_spent DESC;

-- Find menu items never ordered.
SELECT 
    mi.item_name
FROM 
    menu_items mi
LEFT JOIN 
    order_details od ON mi.item_id = od.item_id
WHERE 
    od.item_id IS NULL;

