CREATE DATABASE storeDB;
USE storeDB;

CREATE TABLE product (
  prod_id INT PRIMARY KEY,
  prod_name VARCHAR(100),
  price DECIMAL(10,2),
  quantity INT
);

CREATE TABLE customer (
  cust_id INT PRIMARY KEY,
  cust_name VARCHAR(100),
  city VARCHAR(100)
);

CREATE TABLE online_orders (
  order_id INT PRIMARY KEY,
  cust_id INT,
  order_date DATE,
  FOREIGN KEY (cust_id) REFERENCES customer(cust_id)
);

CREATE TABLE store_orders (
  order_id INT PRIMARY KEY,
  cust_id INT,
  order_date DATE,
  FOREIGN KEY (cust_id) REFERENCES customer(cust_id)
);

CREATE TABLE wholesale (
  prod_id INT,
  FOREIGN KEY (prod_id) REFERENCES product(prod_id)
);

CREATE TABLE retail (
  prod_id INT,
  FOREIGN KEY (prod_id) REFERENCES product(prod_id)
);

CREATE TABLE electronics (
  prod_id INT PRIMARY KEY,
  prod_name VARCHAR(100)
);

CREATE TABLE furniture (
  prod_id INT PRIMARY KEY,
  prod_name VARCHAR(100)
);

CREATE TABLE suppliers (
  supplier_id INT PRIMARY KEY,
  city VARCHAR(100)
);

INSERT INTO product (prod_id, prod_name, price, quantity) VALUES
(101, 'Laptop', 60000, 15),
(102, 'Phone', 25000, 50),
(103, 'Tablet', 30000, 5),
(104, 'TV', 55000, 8),
(105, 'Printer', 10000, 60);


INSERT INTO customer (cust_id, cust_name, city) VALUES
(1, 'John Doe', 'Mumbai'),
(2, 'Jane Smith', 'Delhi'),
(3, 'Tom Hardy', 'Bangalore'),
(4, 'Emily Rose', 'Chennai');

INSERT INTO online_orders (order_id, cust_id, order_date) VALUES
(201, 1, '2025-01-10'),
(202, 2, '2025-02-15'),
(203, 3, '2025-03-05');

INSERT INTO store_orders (order_id, cust_id, order_date) VALUES
(301, 2, '2025-01-20'),
(302, 3, '2025-03-20'),
(303, 4, '2025-04-01');

INSERT INTO wholesale (prod_id) VALUES
(101), (103), (105);

INSERT INTO retail (prod_id) VALUES
(101), (102), (104);

INSERT INTO electronics (prod_id, prod_name) VALUES
(101, 'Laptop'),
(102, 'Phone');

INSERT INTO furniture (prod_id, prod_name) VALUES
(201, 'Chair'),
(202, 'Desk');

INSERT INTO suppliers (supplier_id, city) VALUES
(1, 'Mumbai'),
(2, 'Delhi'),
(3, 'Pune');

-- 4 Products with their price and the highest price in the product table
 SELECT prod_name,
       price,
       (SELECT MAX(price) FROM product) AS max_price
FROM product;

-- 12 Products priced higher than average
SELECT prod_name, price
FROM product
WHERE price > (SELECT AVG(price) FROM product);

-- 14. Customers with more orders than average per customer
SELECT cust_id
FROM (
  SELECT cust_id, COUNT(*) AS num_orders
  FROM (
    SELECT cust_id FROM online_orders
    UNION ALL
    SELECT cust_id FROM store_orders
  ) all_orders
  GROUP BY cust_id
) cust_counts
WHERE num_orders > (
  SELECT AVG(num_orders)
  FROM (
    SELECT cust_id, COUNT(*) AS num_orders
    FROM (
      SELECT cust_id FROM online_orders
      UNION ALL
      SELECT cust_id FROM store_orders
    ) sq
    GROUP BY cust_id
  ) avg_sq
);

-- 15 Products with quantity below the minimum across all products
SELECT prod_name, quantity
FROM product
WHERE quantity < (SELECT MIN(quantity) FROM product);

-- 21 Unique customer names from both online & store orders
SELECT cust_name FROM customer WHERE cust_id IN (
  SELECT cust_id FROM online_orders
)
UNION
SELECT cust_name FROM customer WHERE cust_id IN (
  SELECT cust_id FROM store_orders
);

-- 22 All customer names including duplicates
SELECT cust_name FROM customer WHERE cust_id IN (
  SELECT cust_id FROM online_orders
)
UNION ALL
SELECT cust_name FROM customer WHERE cust_id IN (
  SELECT cust_id FROM store_orders
);

-- 24 All product names from electronics and furniture
SELECT prod_name FROM electronics
UNION
SELECT prod_name FROM furniture;

-- 25 Cities from customers and suppliers with/without duplicates
-- Unique:
SELECT city FROM customer
UNION
SELECT city FROM suppliers;

-- With duplicates:
SELECT city FROM customer
UNION ALL
SELECT city FROM suppliers;

-- 28 Product IDs in both wholesale and retail
SELECT prod_id FROM wholesale
INTERSECT
SELECT prod_id FROM retail;

-- 29 Customers who ordered only from website, not stores
SELECT cust_id FROM online_orders
EXCEPT
SELECT cust_id FROM store_orders;

-- 42 Product stock status by quantity
SELECT prod_name, quantity,
  CASE
    WHEN quantity < 10 THEN 'Low'
    WHEN quantity < 50 THEN 'Moderate'
    ELSE 'High'
  END AS stock_status
FROM product;

