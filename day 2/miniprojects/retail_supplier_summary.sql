CREATE DATABASE retailsupplierDB;
USE retailsupplierDB;

CREATE TABLE suppliers (
    supplier_id INT PRIMARY KEY,
    name VARCHAR(100)
);

CREATE TABLE products (
    product_id INT PRIMARY KEY,
    name VARCHAR(100),
    supplier_id INT,
    FOREIGN KEY (supplier_id) REFERENCES suppliers(supplier_id)
);

CREATE TABLE purchases (
    purchase_id INT PRIMARY KEY,
    product_id INT,
    quantity INT,
    purchase_date DATE,
    FOREIGN KEY (product_id) REFERENCES products(product_id)
);

INSERT INTO suppliers (supplier_id, name) 
VALUES
(1, 'Global Traders'),
(2, 'Ace Distributors'),
(3, 'Fresh Supplies');


INSERT INTO products (product_id, name, supplier_id) 
VALUES
(101, 'Laptop', 1),
(102, 'Mouse', 1),
(103, 'Keyboard', 2),
(104, 'Monitor', 2),
(105, 'Printer', 3),
(106, 'Scanner', 3),
(107, 'Webcam', 2); 


INSERT INTO purchases (purchase_id, product_id, quantity, purchase_date) 
VALUES
(1, 101, 10, '2025-01-15'),
(2, 102, 20, '2025-02-10'),
(3, 103, 15, '2025-03-05'),
(4, 104, 5, '2025-04-01'),
(5, 105, 8, '2025-05-18'),
(6, 106, 12, '2025-06-21');

--   Show total stock purchased per supplier.
SELECT 
    s.supplier_id,
    s.name AS supplier_name,
    SUM(pur.quantity) AS total_stock_purchased
FROM 
    purchases pur
JOIN 
    products prod ON pur.product_id = prod.product_id
JOIN 
    suppliers s ON prod.supplier_id = s.supplier_id
GROUP BY 
    s.supplier_id, s.name;

--   List products never purchased.
SELECT 
    p.product_id,
    p.name AS product_name
FROM 
    products p
LEFT JOIN 
    purchases pur ON p.product_id = pur.product_id
WHERE 
    pur.purchase_id IS NULL;

-- Find supplier with the largest product portfolio.
SELECT 
    s.supplier_id,
    s.name AS supplier_name,
    COUNT(p.product_id) AS total_products
FROM 
    suppliers s
JOIN 
    products p ON s.supplier_id = p.supplier_id
GROUP BY 
    s.supplier_id, s.name
ORDER BY 
    total_products DESC
LIMIT 1;

